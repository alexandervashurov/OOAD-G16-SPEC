% Author: Nicolas Guelfi
% Date: 12/01/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrop/4.
:- multifile msmop/3.
:- dynamic msrop/4.
:- multifile isTypeOf/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic testCaseNumberLength/1.
:- assert(testCaseNumberLength(3)).

generateZeros(0,'').

generateZeros(Qty,Atom):-
Qty>0,
ShorterQty is Qty -1 , 
generateZeros(ShorterQty,ShorterAtom),
atom_concat(ShorterAtom,'0',Atom)
.

msrFormatInteger(Number,FormattedAtom):-
name(Number,AtomCodes),
atom_codes(AAtomValue,AtomCodes),
atom_length(AAtomValue,N),
testCaseNumberLength(Digits),
PrefixeLength is Digits-N,
(PrefixeLength<0
-> (retractall(testCaseNumberLength(_)),
    NewDigits is Digits+1,
    assert(testCaseNumberLength(NewDigits)),
    msrFormatInteger(Number,FormattedAtom)
   )
; (generateZeros(PrefixeLength,ZerosAtom),
   atom_concat(ZerosAtom,AAtomValue,FormattedAtom)
  )
).

getOperationType(AType,OperationName,AType):-
 operations(OperationsList),
 member([AType,OperationName,_],OperationsList),!.

getOperationType(AType,OperationName,Result):-
 allSuperTypes(AType,SuperTypes),
 Result^(member(Result,SuperTypes),
         getOperationType(Result,OperationName,Result)
        ).
 

msrConst(AType,AValuesList,AConstant):-
  msrVar(AType,AConstant),
  msrop(AType,new,AValuesList,AConstant).


msrClose([]).
msrClose([AFreeTypedValue]) :-
var(AFreeTypedValue)
 -> (msrException([msrexInterface,
                  msrClose,
                  [AFreeTypedValue],
                  'Unbounded input parameter'])
    )
 ; (  getType(AFreeTypedValue,AType),
      (primitiveTypes(PrimitiveTypesList),
       member([AType,[]],PrimitiveTypesList)
      )
       -> ( (AFreeTypedValue = [AType , AVal] ,var(AVal))
            -> (msrop(AType,new,[bound],ABoundTypedValue),
                AFreeTypedValue = ABoundTypedValue)
            ; true)
        ; ( (AFreeTypedValue = [ AType, Fields , SuperFields])
            -> ( findall([FieldName,FieldValue],
                         (member([FieldName,FieldValue],Fields),
                          msrClose([FieldValue])),
                         ClosedValuesList),
                 msrClose(SuperFields),
                 AFreeTypedValue = [ AType, ClosedValuesList , SuperFields]
               )
            ; abort
          )
   ),!.

msrClose([AFreeTypedValue | AFreeTypedValuesList]) :-
  ! , msrClose([AFreeTypedValue]),
  msrClose(AFreeTypedValuesList).


msrCreate(AType,AVal):-
  msrVar(AType,AVal),
  msrop(AType,new,[bound],AVal),
  (msrNav([AVal],[is,[]],[[ptBoolean,true]])
   -> true
   ; (msrCreate(AType,AVal)
     )).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% UPDATE OBJECT IN MESSAM %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getTypedDataFromFieldPath(ATypedDataIN,
                          AfieldPathIN,
                          ATypedDataOUT):-
 (var(ATypedDataIN);var(AfieldPathIN))
 -> (msrException([msrexInterface,
                  getTypedDataFromFieldPath,
                  [ATypedDataIN,
                   AfieldPathIN,
                   ATypedDataOUT],
                  'Unbounded input parameter'])
    )
 ;(
      AfieldPathIN = [PathHead | PathQueue],
      (PathQueue = [] 
       -> fail
       ;
       (ATypedDataIN = [ TypeName,
                          FixedLevelTypedValueList,
                          HierarchicalTypedValueList],

        member([PathHead,PathHeadValue],FixedLevelTypedValueList),
        getTypedDataFromFieldPath(PathHeadValue,
                                  PathQueue,
                                  ATypedDataOUT)
        )
      )
  )
.

getTypedDataFromFieldPath(ATypedDataIN,
                          [AfieldNameIN],
                          ATypedDataOUT):-
  (var(ATypedDataIN);\+atomic(AfieldNameIN))
 -> (msrException([msrexInterface,
                  getTypedDataFromFieldPath,
                  [ATypedDataIN,
                   [AfieldNameIN],
                   ATypedDataOUT],
                  'Unbounded input parameter'])
    )
 ;
      ( ATypedDataIN = [ TypeName,
                         FixedLevelTypedValueList,
                         HierarchicalTypedValueList],
        ( member([AfieldNameIN,ATypedDataOUT],FixedLevelTypedValueList)
          -> true
          ; ( HierarchicalTypedValueList = [ Head | Queue] ,
              (getTypedDataFromFieldPath(Head,
                                         [AfieldNameIN],
                                         ATypedDataOUT)
               -> true
               ; ( getTypedDataFromFieldPath([TypeName,[],Queue],
                                             [AfieldNameIN],
                                             ATypedDataOUT)
                 )
              )
            )
        )
      )
.

msmop(msrIsKilled,ObjectValue,[]):-
 (var(ObjectValue)
  ;(getField(ObjectValue,[oid,value],[ptInteger,TheVal]),var(TheVal))
 )
 -> (msrException([msrexInterface,
                  msmop,
                  [msrIsKilled,ObjectValue],
                  'Unbounded input parameter or non object type'])
    )
 ;
 ( getField(ObjectValue,[oid],TheOID),
   findObject(TheOID,ObjectValueLastVersion),
   getType(ObjectValueLastVersion,ActType),
   currentMessamVersion(Version),

   messam(Version,classes,ActType,ObjectsList),
   member(ObjectValueLastVersion,ObjectsList),
   replaceInList(ObjectValueLastVersion,
                 msrNull,
                 ObjectsList,
                 NewObjectsList),
   retract(messam(Version,classes,ActType,ObjectsList)),
   assert(messam(Version,classes,ActType,NewObjectsList)),
              
   (isSubType(ActType,ctMsrActor)
     -> (msrNav([ObjectValue],
                [msmAtPre,rnInterfaceIN],[ObjectInterfaceIN]),
         msrNav([ObjectValue],
                [msmAtPre,rnInterfaceOUT],[ObjectInterfaceOUT]),
         msmop(msrIsKilled,ObjectInterfaceIN,[]),
         msmop(msrIsKilled,ObjectInterfaceOUT,[])
        )
      ; true
   ),
 

   allSubTypes(ActType,SubTypesList),
   findall(Object,
           (member(Type,SubTypesList),
            messam(Version,classes,Type,SubObjectsList),
            member(Object,SubObjectsList),
            generalize(Object,
                       ActType,
                       ObjectValueLastVersion),
            msmop(msrIsKilled,Object,[])
           ),
           AllSubTypesKilledObjects),
   
   allSuperTypes(ActType,SuperTypesList),
   findall(Object,
           (
            member(Type,SuperTypesList),
            generalize(ObjectValueLastVersion,
                       Type,
                       Object),
            msmop(msrIsKilled,Object,[])
           ),
           AllSuperTypesKilledObjects),
   
   findall(RelationA,
           (
            messam(Version,relations,RelationA,Records),
            replaceInList([[RoleA,ObjectValueLastVersion],
                           [RoleB,RoleBObject]],
                          msrNull,
                          Records,
                          NewRecords),
            ((Records = NewRecords)
             -> fail
            ; (retract(messam(Version,relations,Relation,Records)),
               assert(messam(Version,relations,Relation,NewRecords))
              )),
            retract(messam(Version,relations,Relation,Records)),
            assert(messam(Version,relations,Relation,NewRecords))
           ),
           ModifiedRelationsRoleA),

    findall(RelationB,
           (messam(Version,relations,RelationB,Records),
            replaceInList([[RoleA,ObjectA],
                           [RoleB,ObjectValueLastVersion]],
                           msrNull,
                           Records,
                           NewRecords),
            ((Records = NewRecords)
             -> fail
            ; (retract(messam(Version,relations,Relation,Records)),
               assert(messam(Version,relations,Relation,NewRecords))
              ))
           ),
           ModifiedRelationsRoleB)
 )
.

getAllSuperInstances([],[]).

getAllSuperInstances([ObjectValue | ObjectsListQueue],
                     SuperObjectsList):-
   getField(ObjectValue,[oid],TheOID),
   findObject(TheOID,ObjectValueLastVersion),
   getType(ObjectValueLastVersion,ActType),
   allSuperTypes(ActType,SuperTypesList),
   findall(ASuperTypeClassInstance,
           (member(ASuperType,SuperTypesList),
            generalize(ObjectValueLastVersion,
                       ASuperType,
                       ASuperTypeClassInstance)
           ),
           ObjectValueSuperValues),
   getAllSuperInstances(ObjectsListQueue,QueueSuperObjectsList),!,
   append(ObjectValueSuperValues,
          QueueSuperObjectsList,
          SuperObjectsList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% List Predicates %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msrColArithmetics([],Op,_):- !,
  (msrException([msrexInterface,
                  msrSum,
                  [],
                  'Incorrect input parameter(s)'])
    )
  .

msrColArithmetics([Value],Op,Value):- !,
  getType(Value,AType),
  (isValidColArithmeticOperation(AType,Op)
   -> true
   ; (msrException([msrexInterface,
                    msrSum,
                    [Value],
                    'non summable value !'])
    )
   )
.

msrColArithmetics([Value | Queue],Op,TheResultValue):-
  msrColArithmetics([Value],Op,TheHeadValue),
  msrColArithmetics(Queue,Op,TheQueueValue),
  msrNav([TheHeadValue],
         [Op,[TheQueueValue]],
         [TheResultValue])
.

% to update
isValidColArithmeticOperation(AType,Op):-
  allSuperTypes(AType,SuperTypesList),
  append([AType],SuperTypesList,AllTypesList),
  SummableType^(member(SummableType,AllTypesList),
                member(SummableType,
                       [ptInteger,ptReal,dtInteger,dtReal]))
.

msrCountOccurences(A,[],0).
msrCountOccurences(A,[A | Queue],N):- !,
  msrCountOccurences(A,Queue,M),
  N is M + 1
.
msrCountOccurences(A,[B | Queue],N):- !,
  msrCountOccurences(A,Queue,N)
.


replaceInList(A,B,[],[]):-!.

%replaceInList(A,msrNull,[A],msrNull):-!.
%replaceInList(A,msrNull,A,msrNull):-!.

replaceInList(A,B,A,B):-!.

replaceInList(A,B,[A],[B]):- \+(B = msrNull),!.

replaceInList(A,B,[C],[NewC]):-
  \+(C = A),
  replaceInList(A,B,C,NewC),!.

replaceInList(A,B,C,C):-
  atomic(C),
  \+(C = A),!.

replaceInList(A,B,[H|Q],Result):-
  replaceInList(A,B,H,NewH),!,
  replaceInList(A,B,Q,NewQ),!,
  ((NewH = msrNull ) 
   -> ((NewQ = msrNull)
        -> Result = [] 
        ; Result = NewQ
      )
  ; ((NewQ = msrNull)
      -> Result = [NewH] 
      ; Result = [NewH | NewQ]
      )
  )
  .



deleteInList(A,[],[]).

deleteInList(A,A,[]):-!.

deleteInList(A,[A],[]):-!.

deleteInList(A,[B],[NewB]):-
  deleteInList(A,B,NewB),!.

deleteInList(A,C,C):-
  \+(C = A),
  atomic(C),!.

deleteInList(A,[H|Q],Result):-
  deleteInList(A,H,NewH),!,
  deleteInList(A,Q,NewQ),!,
  reconstruct(NewH,NewQ,Result)
  .

reconstruct([],[],[]):-!.
reconstruct(H,[],[H]):-!.
reconstruct([],H,[H]):-!.
reconstruct(NewH,NewQ,Result):-
  (atomic(NewH)
  -> (atomic(NewQ)
      -> Result = [NewH , NewQ]
     ; Result = [NewH | NewQ]
     )
  ; (atomic(NewQ)
      -> Result = [NewH , NewQ] 
     ; Result = [NewH | NewQ]
    )
  )
    .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inheritedInterfacesInitialization:- 
 msrFilePath(tmpFilePath,TmpFilePath),
 tell(TmpFilePath),
 write(':- multifile msrop/4.'),
 write('\n'),
 findall(ActorType,
         (actorTypes(ActorsList),
          member([ActorType,_Profile],
                 ActorsList)),
         ActorTypesList),
          
% trace,
 inheritAllInterfaces(ActorTypesList),
 told,tell(user),
 [TmpFilePath].

inheritAllInterfaces([]).

inheritAllInterfaces([AType | Queue]):-
 allSubTypes(AType,ATypeSubTypesList),
 inheritInterface(AType,ATypeSubTypesList),
 inheritAllInterfaces(Queue)
 .

inheritInterface(_AType,[]).

inheritInterface(AType,[ASubType  | Queue ]):-
 interfaceTypes(InterfacesList),

 member([AType,ctOutputInterface,AOutputInterfaceType],InterfacesList),
 member([ASubType,ctOutputInterface,AOutputInterfaceSubType],InterfacesList),
 outputEvents(OutputEventsList),
 
 findall(OutputEvent,
         (member([AOutputInterfaceType,OutputEvent,OutputEventPofile],
                 OutputEventsList),
          newEvents(outputEvents, 
                    [AOutputInterfaceSubType,
                     OutputEvent,
                     OutputEventPofile])
         ),
         LO),

 member([AType,ctInputInterface,AInputInterfaceType],InterfacesList),
 member([ASubType,ctInputInterface,AInputInterfaceSubType],InterfacesList),
 inputEvents(InputEventsList),
 findall(InputEvent,
         (member([AInputInterfaceType,InputEvent,InputEventPofile],
                 InputEventsList),
          newEvents(inputEvents, 
                    [AInputInterfaceSubType,
                     InputEvent,
                     InputEventPofile])
         ),
         LI),

write(AType),write(' - '),write(ASubType),write('\n'),
sll(LO),write('------\n'),
sll(LI),write('------\n'),

 inheritInterface(AType,Queue)
. 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


linkTypeOwner(AType,ALink,outputEvent,TheOwnerInterfaceType):-
 interfaceTypes(InterfaceLists),
 member([Actor,ctOutputInterface,AType],InterfaceLists),
 allSuperTypes(Actor,ActorSuperTypesList),
 AllActorTypes = [Actor | ActorSuperTypesList],
 outputEvents(OutputEventsList),
 
 TheOwnerInterfaceType^(
  member(TheOwnerActor,AllActorTypes),
  member([TheOwnerActor,ctOutputInterface,TheOwnerInterfaceType],
         InterfaceLists),
  member([TheOwnerInterfaceType,ALink,_Profile],
         OutputEventsList)
                       )
.

linkTypeOwner(AType,ALink,inputEvent,TheOwnerInterfaceType):-
 interfaceTypes(InterfaceLists),
 member([Actor,ctInputInterface,AType],InterfaceLists),
 allSuperTypes(Actor,ActorSuperTypesList),
 AllActorTypes = [Actor | ActorSuperTypesList],
 inputEvents(InputEventsList),
 
 TheOwnerInterfaceType^(
  member(TheOwnerActor,AllActorTypes),
  member([TheOwnerActor,ctInputInterface,TheOwnerInterfaceType],
         InterfaceLists),
  member([TheOwnerInterfaceType,ALink,_Profile],
         InputEventsList)
                       )
.

linkTypeOwner(AType,ALink,
              relationRole,
              TheOwnerType):-
 allSuperTypes(AType,ATypeSuperTypesList),
 AllTargetTypes = [AType | ATypeSuperTypesList],
 relationTypes(RelationDefList),
 TheOwnerType^( member(TheOwnerType,AllTargetTypes),
                member([RelationCategory,
                        RelationName,
                        RelatedTypesList,
                        PartsDefList],
                       RelationDefList),
                member([TheOwnerType,_ARoleName],RelatedTypesList),
                member(APart,PartsDefList),
                getField(APart,[roleName],[ptString,ALink])
              ),!.
  

getInheritedInterface(InterfaceInstance,
                      InterfaceSuperType,
                      SuperTypeInterfaceInstance):-
interfaceTypes(InterfaceTypesList),
member([OwnerActorType,InterfaceCategory,InterfaceSuperType],
       InterfaceTypesList),
(InterfaceCategory = ctInputInterface
-> Role = rnInterfaceIN
; Role = rnInterfaceOUT),
msrNav([InterfaceInstance],
       [rnActor,as,[OwnerActorType],Role],
       [SuperTypeInterfaceInstance])
.



