% Author: Nicolas Guelfi
% Date: 12/01/2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrop/4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Operation that can be applied to any value of a type that is derived from another type
% or to a value of a type t with t as parameter (i.e. identity operation)

:-newMetaOperation(as, [[msrAnyType,msrAnyType],[msrAnyType]]).

msrop(_AnyType,as,[AValueIN,ATypeOUT],AValueOUT):-
 getType(AValueIN,ATypeIN),
 ( (ATypeIN = ATypeOUT)
   -> AValueOUT = AValueIN
   ; ( isSubType(ATypeIN,ATypeOUT),
       generalize(AValueIN,ATypeOUT,AValueOUT)
     )
 ).


:-newMetaOperation(etEq, [[msrAnyType,msrAnyType],[msrAnyType]]).
msrop(_AnyType,etEq,[AValueIN1,AValueIN2],AValueOUT):-
( AValueIN1 = [ATypeIN1,AetVallueIN1],
  AValueIN2 = [ATypeIN2,AetVallueIN2],
  enumerationTypes(EnumerationTypes),
  member([ATypeIN1,_],EnumerationTypes),
  member([ATypeIN2,_],EnumerationTypes),
  AetVallueIN1 = AetVallueIN2
)
-> AValueOUT = [ptBoolean,true]
; AValueOUT = [ptBoolean,false]
.

