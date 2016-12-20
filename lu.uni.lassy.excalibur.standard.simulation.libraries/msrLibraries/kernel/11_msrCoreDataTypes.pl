% Author: Nicolas Guelfi
% Date: 12/01/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrop/4.
:- multifile isTypeOf/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------
% Messim/Messam Core DataTypes
% ------------------------------------------
%%%%%% Core Types

% ------------------------------------------
%%  dtOID
% ------------------------------------------
:- newType(dataTypes,[dtOID,[]]).
:-inherit(dtOID,[dtInteger]).
:-newOperation(dtOID,is,[[dtOID],[ptBoolean]]).

:-addProtectedOperation(dtOID,new).
msrop(dtOID,new,[bound],AnOID):-
 getNextObjectID(OID),
 msrop(dtOID,new,[OID],AnOID),!.

msrop(dtOID,is,[AValue],Result):-
(isTypeOf(dtOID,AValue),
 getField(AValue,[value],[ptInteger,AnInteger]),
 AnInteger >= 0
)
  -> Result = [ptBoolean,true]
  ; Result = [ptBoolean,false]
.
 
% ------------------------------------------
%%  createC
% ------------------------------------------
% not optimized at all creation of correct typed value
% using a retry approach until valid !!!
% implies that an is operation exists !!!
msrop(ATypeName,createC,ParametersList,ValueOUT):-
 msrop(ATypeName,create,ParametersList,ValueOUTTemp),
 (msrop(ATypeName,is,[ValueOUTTemp],[ptBoolean,true])
 ->      ValueOUT = ValueOUTTemp 
         ; 
         (write(ValueOUTTemp),write(nl),
          msrop(ATypeName,createC,ParametersList,AnOtherValueOUT),
         ValueOUT = AnOtherValueOUT)
 ),!.
 


% ------------------------------------------
