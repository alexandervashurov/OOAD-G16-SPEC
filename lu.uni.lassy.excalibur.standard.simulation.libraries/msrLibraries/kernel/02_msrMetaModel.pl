% Author: Nicolas Guelfi
% Date: 12/01/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrNav/3.
:- multifile msrop/4.
:- dynamic msrop/4.
:- multifile isTypeOf/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DYNAMIC PREDICATES  */
:-dynamic allTypesDefinition/1.
:-retractall(allTypesDefinition(_)).
:-assert(allTypesDefinition([])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Events
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newEvents(Category,ValuesList):-
(\+var(Category),member(Category,[outputEvents,inputEvents]))
->
(!,
ValuesList = [AClassType,
              AnEventName,
              ASignature],
newOperation(AClassType,AnEventName,ASignature),
GetGoal=..[Category,EventsListAtPre],
GetGoal,
append(EventsListAtPre,[ValuesList],ValuesListAtPost),
RetractAllGoalPartA=..[Category,_],
RetractAllGoal=..[retractall,RetractAllGoalPartA],
RetractAllGoal,
SetGoalPartA=..[Category,ValuesListAtPost],
SetGoal=..['assert',SetGoalPartA],
SetGoal
)
; (msrException([msrexInterface,
                  newEvents,
                  [Category,ValuesList],
                  'Unbounded input parameter or incorrect category'])
    ).


msrop(_ActInputInterface,AnInputEvent,Parameters,[[ptBoolean,true]]):-
 isInputEvent(AnInputEvent),
 Parameters= ([InterfaceIN | EventParametersList]),
 msrSent([InterfaceIN,AnInputEvent,EventParametersList])
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State & Environment Relations Closure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



initializeOperationDeclaration(Operation,ActType):-
  operations(OperationsList),
  (member([ActType , Operation , _Def],
          OperationsList)
   -> true 
  ; (
       write(':-newOperation('),write(ActType),
       write(',init,[['),write(ActType),write('],[ptBoolean]]).'),write('\n')
    )
  ).

initializeOperations(_Operation,[]).

initializeOperations(Operation,[ActType | Queue]):-
initializeOperation(Operation,ActType),
initializeOperations(Operation, Queue).

initializeOperation(init,ActType):-
  
 initializeOperationDeclaration(init,ActType),

 write('msrop('),write(ActType),write(','),
 write(init),write(','),write('[ThectType],'),write('Result'),
 write('):-'),
 write('\n'),
 write('( \n'),
 write('msrop('),write(ActType),write(','),write(new),write(','),
 write('[free]'),write(',ThectType),!,'),write('\n'),

 write('msmop('),write(msrIsNew),write(','),write('ThectType'),
 write(','),write('[])'),write('\n'),
 write(')'),
 write('\n'),
 write('-> Result = [ptBoolean,true] \n ; Result = [ptBoolean,false] \n . \n')
.

initializeOperations(destroy,X).

initializeGenericOperations(ASuperType,AnOperation):-
 classTypes(ClassTypesList),
 findall(ActType,(isSubType(ActType,ASuperType),
                  member([ActType,[[oid,dtOID] | Attributes]],ClassTypesList),
                  Attributes = []),
         NoOperationClassTypesList),
 initializeOperations(AnOperation,NoOperationClassTypesList).

initializeGenericAllOperations:-
        msrFilePath(tmp2FilePath,TmpFilePath),
        tell(TmpFilePath),
        write(':- multifile msrop/4.'),
        write('\n'),
        write(':-write(writeFROMFILE).'),write('\n'),
        
        initializeGenericOperations(ctMsrActor,init),
        initializeGenericOperations(ctInputInterface,init),
        initializeGenericOperations(ctOutputInterface,init),
        
        classTypes(ClassTypesList),
        findall(ActType, member([ActType,_],ClassTypesList),AllClassTypesList),
        initializeOperations(destroy,AllClassTypesList),

        told,
        tell(user),
        [TmpFilePath]
        .

initializeMsrInterfaceRelations(ActorTypeName, 
                                InterfaceType, 
                                InterfaceName):-
( InterfaceType = ctOutputInterface
 -> InterfaceRoleName = rnInterfaceOUT
 ; InterfaceRoleName = rnInterfaceIN),
  atomic_list_concat([rt,ActorTypeName,InterfaceName],RelationName),
  msrop(rtRelDefPart,create,
        [ActorTypeName,rnActor,associate,'1','1'],
         DefPartrnActor),
  msrop(rtRelDefPart,create,
         [InterfaceName,InterfaceRoleName,associate,'1','1'],
         DefPartrnInterface),
  newType(relationTypes,[association,
                         RelationName,
                         [[ActorTypeName,rnActor],[InterfaceName,InterfaceRoleName]],
                        [DefPartrnInterface,DefPartrnActor]
                        ]).


 initializeMsrActorRelations(ActorTypeName,ActorRoleName):-
  atomic_list_concat([rtctState,ActorTypeName],RelationName),
  msrop(rtRelDefPart,create,
        [ctState,rnSystem,composite,'1','1'],
         DefPartrnSystem),
  msrop(rtRelDefPart,create,
         [ActorTypeName,ActorRoleName,part,'1','*'],
         DefPartrnActor),
  newType(relationTypes,[composition,
                         RelationName,
                         [[ctState,rnSystem],[ActorTypeName,ActorRoleName]],
                        [DefPartrnSystem,DefPartrnActor]
                        ]).

newActor(ActorName,RoleName,AttributesList):-
 newType(classTypes,[ActorName,AttributesList]),
 actorTypes(ActorTypesList),
 append([[ActorName,[[oid , dtOID] | AttributesList]]],
        ActorTypesList,
        ActorTypesListNew),
 retractall(actorTypes(_)),
 assert(actorTypes(ActorTypesListNew)),

 inherit(ActorName,[ctMsrActor]),
 initializeMsrActorRelations(ActorName,RoleName).

%% TODO
newProActiveActor(ActorName):- true.

newInterface(ActorName, InterfaceType, InterfaceName):-
 newType(classTypes,[InterfaceName,[]]),
 interfaceTypes(InterfaceTypesList),
 append([[ActorName, InterfaceType, InterfaceName]],
        InterfaceTypesList,
        InterfaceTypesListNew),
 retractall(interfaceTypes(_)),
 assert(interfaceTypes(InterfaceTypesListNew)),
 inherit(InterfaceName,[InterfaceType]),
 initializeMsrInterfaceRelations(ActorName, 
                                 InterfaceType, 
                                 InterfaceName).

newStateClass(ClassDef):-
 newType(classTypes,[ctState,ClassDef]).

newSystemClass(ClassName, 
               ClassDef, 
               [PartRoleName,PartRoleCardinality]):-
 newType(classTypes,[ClassName,ClassDef]),
 
 msrop(rtRelDefPart,create,
        [ctState,rnSystem,composite,'1','1'],
         DefPartrnSystem),
 msrop(rtRelDefPart,create,
         [ClassName,PartRoleName,part | PartRoleCardinality],
         DefPartrnClassName),

 atomic_list_concat([rt,ctState,ClassName],RelationName),

 newType(relationTypes,[composition,
                         RelationName,
                         [[ctState,rnSystem],[ClassName,PartRoleName]],
                        [DefPartrnSystem,DefPartrnClassName]
                        ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Associations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getAssociationName(AType,ARoleNameAtom,AnAssociationName):-
relationTypes(RelationTypesList),
 findall(AName,
        (member([_Category,
                 AName,
                 _RelatedTypesList,
                 RelDefinition],
                RelationTypesList),
         member(ArtRelDefPart1,RelDefinition),
         member(ArtRelDefPart2,RelDefinition),
         \+ArtRelDefPart1=ArtRelDefPart2,
         msrNav([ArtRelDefPart1],[partEnd],[[ptString,AType]]),
         msrNav([ArtRelDefPart2],[roleName],[[ptString,ARoleNameAtom]])
        ),
        [AnAssociationName]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global Messir Specification Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theSystem(TheSystem):-
 msmop(getMsmCurrentVersion,[],CurrentVersionValue),
 messam(CurrentVersionValue,classes,ctState,[TheSystem])
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Operation Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newOperation(AType,AnOperationName, AParametersList):-
%ensureOverriding(AType,AnOperationName),
GetGoal=..[operations,OperationsListAtPre],
GetGoal,
append([[AType, AnOperationName,AParametersList]],OperationsListAtPre,ValuesListAtPost),
RetractAllGoalPartA=..[operations,_],
RetractAllGoal=..[retractall,RetractAllGoalPartA],
RetractAllGoal,
SetGoalPartA=..[operations,ValuesListAtPost],
SetGoal=..['assert',SetGoalPartA],
SetGoal,!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meta Operation Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newMetaOperation(AnOperationName, AParametersList):-
GetGoal=..[metaOperations,OperationsListAtPre],
GetGoal,
append([[AnOperationName,AParametersList]],OperationsListAtPre,ValuesListAtPost),
RetractAllGoalPartA=..[metaOperations,_],
RetractAllGoal=..[retractall,RetractAllGoalPartA],
RetractAllGoal,
SetGoalPartA=..[metaOperations,ValuesListAtPost],
SetGoal=..['assert',SetGoalPartA],
SetGoal,!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Operation Predicates - Various
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getOperationOutputType(ATypeName,AOperationName,AOutputTypeName):-
  operations(OperationsList),
  member([ATypeName,AOperationName,[ _InputTypesList ,[AOutputTypeName]]],
         OperationsList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generic New Operation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateVarList(0,[]).

generateVarList(Length,VariablesList):-
NewLength is Length -1 ,
generateVarList(NewLength,VariablesListQueue),
append([_],VariablesListQueue,VariablesList).


msrop(ATypeName,new,[free],AValue):-
 allTypesDefinition(ATypesList),
 member([_ATypeCategory,[ATypeName,_ATypeDef]],
        ATypesList),
 fieldsNumber(ATypeName,Length),
 if( (Length = 0) %for primitive types
      ,
      (VariablesList = [_])
      ,
       (generateVarList(Length,VariablesList))
    ),!,
 msrop(ATypeName,create,VariablesList,AValue).

msrop(ATypeName,new,[bound],AValue):-
 allTypesDefinition(ATypesList),
 
 member([_ATypeCategory,[ATypeName,_ATypeDef]],
        ATypesList),
 (isProtectedOperation(ATypeName,new)
 -> fail
 ;  % test if it is a class and use a generated oid
    (!,msrop(ATypeName,create,_,AValue))
 ).

msrop(ATypeName,new,ParametersList,AValue):-
 (ParametersList=[Val],member(Val,[free,bound]))
 -> (isProtectedOperation(ATypeName,new)
     -> fail
    ; msrException([msrexInterface,
                  msrop,
                  [ATypeName,new,ParametersList,AValue],
                  'Incorrect input parameters'])
    )
 ;(
 allTypesDefinition(ATypesList),
 member([_ATypeCategory,[ATypeName,_ATypeDef]],
        ATypesList),
 msrop(ATypeName,create,ParametersList,AValue)
  )
 .

buildTypedValuesList(_Freeness,[],[]).

buildTypedValuesList(Freeness,
                     [ATypeName | ATypesList],
                     [AValue | AValuesList]):-
msrop(ATypeName,new,Freeness,AValue),!,
buildTypedValuesList(Freeness,
                     AValuesList,
                     AValuesList).
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generic Creation Operation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msrVar(AType,AFreeTypedValue):-
 msrop(AType,new,[free],AFreeTypedValue),!.

msrVarCol(_AType,Dim,_ACol):- var(Dim),! .

msrVarCol(AType,[ptInteger,0],[]):-
% Should be imroved not to allow the creation of variables for types that are not elligible
  \+(var(AType)),!.

msrVarCol(AType,Dim,[AFreeTypedValue | AVarList]):-
  (var(Dim) ; var(AType) ; \+(msrop(ptInteger,is,[Dim],[ptBoolean,true])))
  ->  ((msrException([msrexInterface,
                  msrVarCol,
                  [AType,Dim,[AFreeTypedValue | AVarList]],
                  'Incorrect input parameter(s)'])
    )
)
  ; (msrop(AType,new,[free],AFreeTypedValue),
     msrNav([Dim],[sub,[[ptInteger,1]]],[NextDim]) ,
     msrVarCol(AType,NextDim, AVarList)
    )
   .

containsVariables([]):-fail.
containsVariables([Var | VariableList]):-
 var(Var) 
 -> true
 ; containsVariables(VariableList).

addProtectedOperation(Type,Operation):-
 (containsVariables([Type,Operation])
  -> (msrException([msrexInterface,
                  addProtectedOperation,
                  [Type,Operation],
                  'Incorrect input parameter(s)'])
    )
 ; (protectedOperations(ProtectedOperationsList),
    append([[Type,Operation]],ProtectedOperationsList,NewprotectedOperations),
    retractall(protectedOperations(_)),
    assert(protectedOperations(NewprotectedOperations))
   )
 ).

isProtectedOperation(Type,Operation):-
 (containsVariables([Type,Operation])
  -> fail
 ; (protectedOperations(ProtectedOperationsList),
    member([Type,Operation],ProtectedOperationsList)
   )
 ).

msrop(AetName,create,ValuesList,AValueOUT):-
      enumerationTypes(EnumerationTypesList),
      member([AetName,AetValuesList],EnumerationTypesList),
      (var(ValuesList) 
        -> random_select(AValue, AetValuesList , _)
        ; ((ValuesList = [AValue | _],var(AValue))
          -> true
          ; ((ValuesList = [AValue | _], member(AValue,AetValuesList))
          -> true
            ; (ValuesList = []
            -> true
            ; fail)))),
      AValueOUT = [AetName,AValue]
.

%% PUT IMPLICATIONS
msrop(AdtName,create,ValuesList,AValueOUT):-
      ( (dataTypes(TypesList) , 
         member([AdtName,AdtDef],TypesList))
      ;
        (classTypes(TypesList) , 
        member([AdtName,AdtDef],TypesList))),
        
      createFixedLevelValues(AdtDef,ValuesList,AFixedLevelValuesList,ANewValuesList),
      subTypes(SubTypesList),
      ( member([AdtName,AdtSuperTypesList],SubTypesList)
        ->  createSuperTypesLevelValues(
                         AdtSuperTypesList,
                         ANewValuesList,
                         SuperTypesLevelValuesList,_)
        ; SuperTypesLevelValuesList = []),
      AValueOUT = [AdtName, AFixedLevelValuesList , SuperTypesLevelValuesList]
% cut removed on 121022      !
      .

createFixedLevelValues( [],
                        ValuesList,
                        [],
                        ValuesList).

createFixedLevelValues( AdtDef,
                        ValuesList,
                        AFixedLevelValuesList,
                        ANewValuesList):-
AdtDef = [ [AFieldName , AFieldType] | AdtDefQueue],
msrop(AFieldType,create,ValuesList,AValueOUT),
fieldsNumber(AFieldType,ATmpFieldsNumber),
(ATmpFieldsNumber = 0
-> AFieldsNumber = 1
; AFieldsNumber = ATmpFieldsNumber),
(  \+var(ValuesList)
   -> append_length(_ConsumedValues,
              AReducedValuesList,
              ValuesList,
              AFieldsNumber)
    ; true
),
createFixedLevelValues(AdtDefQueue,
                       AReducedValuesList,
                       ANewFixedLevelValuesList,
                       ANewValuesList),
append([[AFieldName,AValueOUT]],ANewFixedLevelValuesList,AFixedLevelValuesList),
!.


createSuperTypesLevelValues( [],
                             AValuesList,
                             [],
                             AValuesList).

createSuperTypesLevelValues( ASuperTypesList,
                             AValuesList,
                             ASuperTypesLevelValuesList,
                             ANewValuesList):-
ASuperTypesList = [ AType | AQueue],
msrop(AType,create,AValuesList,AValueOUT),
fieldsNumber(AType,ATmpFieldsNumber),
(ATmpFieldsNumber = 0
-> AFieldsNumber = 1
; AFieldsNumber = ATmpFieldsNumber),
( (var(AValuesList)
        -> AReducedValuesList = AValuesList
        ; append_length(_ConsumedValues,
              AReducedValuesList,
              AValuesList,
              AFieldsNumber)
  )
),
createSuperTypesLevelValues(AQueue,
                       AReducedValuesList,
                       ANewFixedLevelValuesList,
                       ANewValuesList),
append([AValueOUT],ANewFixedLevelValuesList,ASuperTypesLevelValuesList),
!.

fieldsNumber(ATypeName,0):-
 dataTypes(DataTypesTypesList),
 classTypes(ClassTypesList),
 \+ member([ATypeName,ATypeDef],DataTypesTypesList),
 \+ member([ATypeName,ATypeDef],ClassTypesList).
 
fieldsNumber(ATypeName,AFieldsNumber):-
  dataTypes(DataTypesTypesList),
  classTypes(ClassTypesList),
  if(
   (member([ATypeName,ATypeDef],ClassTypesList);
    member([ATypeName,ATypeDef],DataTypesTypesList))
  ,
  (subTypes(SubTypesList),
  (member([ATypeName,L],SubTypesList)->SuperTypesList = L; SuperTypesList = []),
  fieldsNumberCurrentLevelList(ATypeDef,N),
  fieldsNumberUpperLevelsList(SuperTypesList,P),
  AFieldsNumber is N + P)
  , 
  (msrException([msrexInterface,
                  fieldsNumber,
                  [ATypeName,AFieldsNumber],
                  'Incorrect input parameter(s)'])
    )).

fieldsNumberCurrentLevelList([],0).

fieldsNumberCurrentLevelList(CurrentLevelList,P):-
 CurrentLevelList = [ [_ , FieldType]  | Queue],
 fieldsNumber(FieldType,Q),
 fieldsNumberCurrentLevelList(Queue,R),
 (Q = 0 -> P is 1 + R ; P is Q + R).

fieldsNumberUpperLevelsList([],0).

fieldsNumberUpperLevelsList(SuperTypesList,P):-
 SuperTypesList = [ Head  | Queue],
 fieldsNumber(Head,Q),
 fieldsNumberUpperLevelsList(Queue,R),
 P is Q + R.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Meta Dynamic Creation of Dynamic Predicates
*/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initDynamicPredicate(Predicate,Dimension,InitValue):-
msrFilePath(tmpFilePath,TmpFilePath),
tell(TmpFilePath),
write(':- dynamic '),write(Predicate),write('/'),write(Dimension),write('. \n'),
told,tell(user),
[TmpFilePath],
GoalParam=..[Predicate , _],
Goal=..[retractall,GoalParam],
Goal,

(InitValue = null
 -> true
 ;
        (Goal2Param=..[Predicate | InitValue],
         Goal2=..[assert,Goal2Param],
         Goal2)
),

allDynamicPredicates(AllDynamicPredicatesList),
append([[Predicate,Dimension]],
       AllDynamicPredicatesList,
       AllDynamicPredicatesListNew),
retractall(allDynamicPredicates(_)),
assert(allDynamicPredicates(AllDynamicPredicatesListNew)).

newTypePartitioned(TypeSetIdentifier,NewTypeDefinition):-
        GoalGet=..[TypeSetIdentifier,CurrentList],
        GoalGet,
        append([NewTypeDefinition],CurrentList,NewList),
        RetractAllGoalPartA=..[TypeSetIdentifier,_],
        RetractAllGoal=..[retractall,RetractAllGoalPartA],
        RetractAllGoal,
        SetGoalPartA=..[TypeSetIdentifier,NewList],
        SetGoal=..['assert',SetGoalPartA],
        SetGoal,!.

newType(TypeSetIdentifier,NewTypeDefinition):-
        \+ TypeSetIdentifier = classTypes,
        allTypesDefinition(TypesDefList),
        append([[TypeSetIdentifier,NewTypeDefinition]],
               TypesDefList, 
               NewTypesDefList),
        retractall(allTypesDefinition(_)),
        assert(allTypesDefinition(NewTypesDefList)),
        newTypePartitioned(TypeSetIdentifier,NewTypeDefinition).

newType(TypeSetIdentifier,NewTypeDefinition):-
        TypeSetIdentifier = classTypes,
        allTypesDefinition(TypesDefList),
        NewTypeDefinition = [AClassTypeName , AClassTypeDef],
        append([[oid,dtOID]],AClassTypeDef,ANewClassTypeDef),
        append([[TypeSetIdentifier,[AClassTypeName,ANewClassTypeDef]]],
               TypesDefList, 
               NewTypesDefList),
        retractall(allTypesDefinition(_)),
        assert(allTypesDefinition(NewTypesDefList)),
        newTypePartitioned(TypeSetIdentifier,[AClassTypeName,ANewClassTypeDef]).

newAssociationParts(_AssociationType,_AssociationName,[],[]).

newAssociationParts(AssociationType,
                    AssociationName,
                    PartsList,
                    PartsDefinitionOUT):-
 PartsList = [ [ClasseName,
                 RoleName,
                 RoleType,
                 CardMin,
                 CardMax] 
              | PartsListQueue],
 msrop(rtRelDefPart,create,
        [ClasseName,RoleName,RoleType,CardMin,CardMax],
         DefPart),
 newAssociationParts(AssociationType,
                     AssociationName,
                     PartsListQueue,
                     PartsListQueueDefinitions),
 append([DefPart],PartsListQueueDefinitions,PartsDefinitionOUT).

newAssociation(AssociationType,AssociationName,PartsList):-
 findall([Class,RoleName],
         (member([Class,RoleName,_,_,_],PartsList)),
          AssociatedClasses),
 flatten_list(AssociatedClasses,FlattenIDList),
 (var(AssociationName)
 -> atomic_list_concat([rt | FlattenIDList],AssociationName)
 ; true),
 newAssociationParts(AssociationType,
                     AssociationName,
                     PartsList,
                     PartsDefinitions   ),
 newType(relationTypes,[AssociationType,
                        AssociationName,
                        AssociatedClasses,
                        PartsDefinitions]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* A FAIRE ??   */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%refine([SubClasseName,AttributesDef],SuperClassName):-
%inherit(SubClasseName,SuperClassName),
%newClassType([SubClasseName,AttributesDef]),
%newAttributes([SubClasseName,AttributesDef]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inherit(SubType,SuperTypesList):-
subTypes(L),
(select([SubType,_],L,[SubType,SuperTypesList],NL)
 -> true
; append([[SubType,SuperTypesList]],L,NL)),
retractall(subTypes(_)),
assert(subTypes(NL)). 


inheritedBehaviorsInitialization:- 
 msrFilePath(tmpFilePath,TmpFilePath),
 tell(TmpFilePath),
 write(':- multifile msrop/4.'),
 write('\n'),
 operations(OperationsList),
% trace,
 inheritAllBehaviors(OperationsList),
 told,tell(user),
 [TmpFilePath].

inheritAllBehaviors([]).

inheritAllBehaviors([[AType, AnOperationName,_AParametersList] | Queue]):-
 allSubTypes(AType,ATypeSubTypesList),
 inheritBehavior(AType,ATypeSubTypesList,AnOperationName),
 inheritAllBehaviors(Queue)
 .

inheritBehavior(_AType,[],_AnOperationName).

inheritBehavior(AType,[ASubType  | Queue ],AnOperationName):-
 operations(OperationsList),
% (ASubType = actCoordinator -> trace ; true),
 member([ASubType,AnOperationName,_],OperationsList)
 -> true
 ;
 (
 write('msrop('),write(ASubType),write(','),
 write(AnOperationName),write(','),write('ValuesList,AValueOUT):-'),
 write('\n'),
 write('msrop('),write(AType),write(','),
 write(AnOperationName),write(','),write('ValuesList,AValueOUT).'),
 write('\n')
 ),
 inheritBehavior(AType,Queue,AnOperationName)
. 

allTypesSuperTypes([],[]).
        
allTypesSuperTypes([ASubTypeIN | TypesQueue],SuperTypesList):-
        superTypes(ASubTypeIN,LevelOneSuperTypes),
        append(TypesQueue,LevelOneSuperTypes,RemainingTypes),
        allTypesSuperTypes(RemainingTypes,RemainingSuperTypesList),
        append(LevelOneSuperTypes,RemainingSuperTypesList,SuperTypesList)
.

allSuperTypes(Type,SuperTypesList):-
  allTypesSuperTypes([Type],SuperTypesList).

superTypes(ASubTypeIN,[]):-
        subTypes(L),
        \+member([ASubTypeIN,_ASuperTypesList],L) 
        .

superTypes(ASubTypeIN,ASuperTypesList):-
        subTypes(L),
        member([ASubTypeIN,ASuperTypesList],L)
        .

allSubTypes(ASubTypeIN,ASuperTypesList):-
  findall(T,(isSubType(T,ASubTypeIN)),ASuperTypesList).

isSubType(ASubTypeIN,ASuperTypeIN):-
        subTypes(L),
        ASuperTypeList^member([ASubTypeIN,ASuperTypeList],L),
        ( member(ASuperTypeIN,ASuperTypeList)
          -> true
          ; AtmpSuperType
                ^(member(AtmpSuperType,ASuperTypeList),
                  isSubType(AtmpSuperType,ASuperTypeIN))).

generalize(ATypedValueIN,_AGeneralizedTypeIDIN,AGeneralizedTypeIDValueOUT):-
  ATypedValueIN = [PrimitiveType,_AValueIN],
  primitiveTypes(PrimitiveTypesList),
  member([PrimitiveType,[]],PrimitiveTypesList),!,
  AGeneralizedTypeIDValueOUT = ATypedValueIN
.
      
generalize(ATypedValueIN,AGeneralizedTypeIDIN,AGeneralizedTypeIDValueOUT):-
\+var(ATypedValueIN),\+var(AGeneralizedTypeIDIN),
ATypedValueIN = [AGeneralizedTypeIDIN , FlatLevel , HierarchicalLevels ],!,
(FlatLevel=[] -> (\+HierarchicalLevels=[]) ; true),
AGeneralizedTypeIDValueOUT = ATypedValueIN.

generalize(ATypedValueIN,AGeneralizedTypeIDIN,AGeneralizedTypeIDValueOUT):-
ATypedValueIN = [ATypeName , 
                 Fields , 
                 [ FirstSuperType | OtherSuperTypes ]],
(generalize(FirstSuperType,
            AGeneralizedTypeIDIN,
            AGeneralizedTypeIDValueOUT)
-> (!,true)
; generalize([ATypeName , 
              Fields , 
              OtherSuperTypes],
             AGeneralizedTypeIDIN,
             AGeneralizedTypeIDValueOUT)
)
.

substituteSuperTypeObject(AnObject,ASuperTypeObject,ASubstitutedObject):-
 getType(AnObject,AType),
 getType(ASuperTypeObject,ASuperType),
 (AType = ASuperType
 -> ASubstitutedObject = ASuperTypeObject
 ; (
 AnObject = [AType,FieldsList,SuperObjectsList],
 
 findall(Object,
          (member(SuperObject,SuperObjectsList),
           substituteSuperTypeObject(
                SuperObject,
                ASuperTypeObject,
                Object)),
          SuperObjectsListSubstitute),
   ASubstitutedObject=
    [AType,FieldsList,SuperObjectsListSubstitute]
   )
 )
.

getFieldsListFromTypeDef(ATypeNameIN,AFieldsListOUT):-
        allTypesDefinition(AllTypesDefList),
        member([TypeClass,[ATypeNameIN,AFieldsDef]],AllTypesDefList),
        ( ( (TypeClass = classTypes ; TypeClass = dataTypes)
            ->  (getFirstLevelFields(AFieldsDef , FirstLevelFields),
                superTypes(ATypeNameIN, SuperTypesList),
                getUpperLevelsFields(SuperTypesList , UpperLevelFields),
                append(FirstLevelFields,UpperLevelFields,AFieldsListOUT))
            ; AFieldsListOUT = [])
        ).
        

getFirstLevelFields([],[]).
 
getFirstLevelFields(AFieldsDef , FirstLevelFields):-
AFieldsDef = [ [FieldName , FieldType] | Fields],
getFieldsListFromTypeDef(FieldType,AFieldsList),
buildFieldsPath(FieldName,AFieldsList,FirstLevelFieldsPartOne),
getFirstLevelFields(Fields , FirstLevelFieldsPartTwo),
append(FirstLevelFieldsPartOne,FirstLevelFieldsPartTwo,FirstLevelFields).


getUpperLevelsFields([],[]).

getUpperLevelsFields(SuperTypesList , UpperLevelFields):-
 SuperTypesList = [UpperLevel | UpperLevels],
 getFieldsListFromTypeDef(UpperLevel,AFieldsList),
 getUpperLevelsFields(UpperLevels,AUpperLevelsFieldsList),
 append(AFieldsList,AUpperLevelsFieldsList,UpperLevelFields).


buildFieldsPath(FieldName,[],[[FieldName]]).

buildFieldsPath(FieldName,[FieldPath],[RES]):-
append([FieldName],FieldPath,RES).

buildFieldsPath(FieldName,AFieldsList,FirstLevelFields):-
 AFieldsList = [AnOtherFieldPath | FieldsPaths],
 \+FieldsPaths = [],
 buildFieldsPath(FieldName,FieldsPaths,FirstLevelFieldsPartOne),
 append([FieldName],AnOtherFieldPath,FieldPathCompleted),
 append([FieldPathCompleted],FirstLevelFieldsPartOne,FirstLevelFields)
 .

extractFields(_,[],[]).
extractFields(ATypedValueIN,[AFieldName | AFieldNamesListINQueue],AFieldsValuesListOUT):-
        getField(ATypedValueIN,AFieldName,AField),
        extractFields(ATypedValueIN, AFieldNamesListINQueue, AFieldValuesList),
        append([AField],AFieldValuesList,AFieldsValuesListOUT)
        .

isValidNavigationSource([]).
isValidNavigationSource([Value | Queue]):-
 getType(Value,_Type),
 isValidNavigationSource(Queue)
.
getType(ATypedValueIN,ATypeNameOUT):-
 (var(ATypedValueIN))
 -> (msrException([msrexInterface,
                  getType,
                  [ATypedValueIN,
                   ATypeNameOUT],
                  'Unbounded input parameter'])
    ) 
 ;  (ATypedValueIN = [ATypeNameOUT | _Queue],
     allTypesDefinition(AllTypeDefinitionList),
      member([_ATypeCategory,[ATypeNameOUT,_ATypeDef]],
        AllTypeDefinitionList)
    )
  .

isTypeOf(AetName,AetValue):-
 (var(AetValue);var(AetName))
 -> (msrException([msrexInterface,
                  isTypeOf,
                  [AetName,AetValue],
                  'Unbounded input parameter'])
    ) 
 ;
 (
AetValue = [AetName , Aetmember],
enumerationTypes(EnumerationTypesList),
member([AetName,EnumerationValuesList],EnumerationTypesList),
member(Aetmember,EnumerationValuesList)
 ).

checkTypes([]).
checkTypes([ATypedValue | AParametersList]):-
  var(ATypedValue), !.
checkTypes([ATypedValue | AParametersList]):-
  getType(ATypedValue,AType),
  isTypeOf(AType,ATypedValue),
  checkTypes(AParametersList), !.
             
isTypeOf(AStructuredTypeName,AStructuredTypeValue):- 
((var(AStructuredTypeName);var(AStructuredTypeName))
 -> (isTypeOf([msrexInterface,
                  isTypeOf,
                  [AStructuredTypeName,AStructuredTypeValue],
                  'Incorrect input parameter(s)'])
    ) 
 ; generalize(AStructuredTypeValue,AStructuredTypeName,_)
),!.

isObject(AValue):-
 getType(AValue,AType),
 classTypes(ClassTypesList),
 member([AType,_],ClassTypesList).

checkFieldsTypes(_AStructuredTypeValue,[]).
 
checkFieldsTypes(AStructuredTypeValue,
                 AStructuredTypeFieldPathList):-
 AStructuredTypeFieldPathList = [AFieldPath | Queue],
 getField(AStructuredTypeValue,AFieldPath, 
          [AFieldType | AFieldValue]),
 isTypeOf(AFieldType,[AFieldType | AFieldValue]),
 checkFieldsTypes(AStructuredTypeValue,
                  Queue).
 
checkUpperLevelsTypes(_AStructuredTypeValue,[]).
checkUpperLevelsTypes(AStructuredTypeValue,SuperTypesList):-
 SuperTypesList = [ASuperType | Queue],
 generalize(AStructuredTypeValue,ASuperType,ASuperTypeValue),
 isTypeOf(ASuperType,ASuperTypeValue),
 checkUpperLevelsTypes(ASuperType,Queue).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A Controler 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
objectID(ID):-integer(ID).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*    */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getNextObjectID(CPT):-
nextObjectID(N),
CPT is N + 1,
retractall(nextObjectID(_)),
assert(nextObjectID(CPT)).


boundOIDs([]).
boundOIDs([AClassInstance | Queue ]):-
 (isObject(AClassInstance)
  -> (
      AClassInstance = [_ActType,_Vals,SuperTypesInstances],
      boundOIDs(SuperTypesInstances),
      msrop(dtOID,new,[bound],AnOID),
      setField(AClassInstance,[oid],AnOID,ANewboundOIDClassInstance),
      AClassInstance = ANewboundOIDClassInstance)
 ; true),
 
 boundOIDs(Queue).

resetOIDs([],[]).
resetOIDs([Object | Queue],
          [NewObject | NewQueue]):-
 freecopy([Object],[NewObject]),
 boundOIDs([NewObject]),
 resetOIDs(Queue,NewQueue).


freecopy([],[]).

freecopy(   [AnObject | ObjectQueue],
            [AnObjectCopy | ObjectCopyQueue]):-
 getType(AnObject,AType),
 classTypes(ClassTypesList),
 (member([AType,_],ClassTypesList)
  ->   ( AnObject = [AType , FieldsList, SuperTypesObjects],
         findall([FieldName,FieldValueCopy],
                 (member([FieldName,FieldValue],FieldsList),
                  freecopy([FieldValue],[FieldValueCopy])),
                 FieldsListCopy),
         freecopy(SuperTypesObjects,SuperTypesObjectsCopy),
         AnObjectCopy = [AType , FieldsListCopy, SuperTypesObjectsCopy]
       )
 ;
  (AType = dtOID
   -> msrop(AType,new,[free],AnObjectCopy)
   ;  AnObjectCopy = AnObject)
  ),
  freecopy(ObjectQueue,ObjectCopyQueue)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DT's Getters and Setters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* 
set field in case of a non atomic path list
*/
setField(ATypedDataIN,AfieldPathIN,AValueIN,ATypedDataOUT):-
 (var(ATypedDataIN);var(AfieldPathIN))
 -> (msrException([msrexInterface,
                  setField,
                  [ATypedDataIN,AfieldPathIN,AValueIN,ATypedDataOUT],
                  'Incorrect input parameter(s)'])
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
        setField(PathHeadValue,PathQueue,AValueIN,AnInnerTypedDataOUT),

        select([PathHead,_],
               FixedLevelTypedValueList,
               [PathHead,AnInnerTypedDataOUT],
               AChangedValuesList),

        ATypedDataOUT = [TypeName,
                         AChangedValuesList,
                         HierarchicalTypedValueList]
        )
      )
  )
.

setField(ATypedDataIN,[AfieldNameIN],AValueIN,ATypedDataOUT):-
  (var(ATypedDataIN);\+atomic(AfieldNameIN))
 -> (msrException([msrexInterface,
                  setField,
                  [ATypedDataIN,[AfieldNameIN],AValueIN,ATypedDataOUT],
                  'Incorrect input parameter(s)'])
    )
 ;
      ( ATypedDataIN = [ TypeName,
                         FixedLevelTypedValueList,
                         HierarchicalTypedValueList],
        ( member([AfieldNameIN,_],FixedLevelTypedValueList)
          -> (select([AfieldNameIN,_],
                       FixedLevelTypedValueList,
                       [AfieldNameIN,AValueIN],
                       AChangedValuesList),
               ATypedDataOUT = [TypeName,
                                AChangedValuesList,
                                HierarchicalTypedValueList]
               )
          ; ( HierarchicalTypedValueList = [ Head | Queue] ,
              (setField(Head,
                       [AfieldNameIN],
                       AValueIN,
                       AnUpdatedHead)
               -> ATypedDataOUT = [TypeName,
                                   FixedLevelTypedValueList,
                                   [ AnUpdatedHead | Queue] ]
               ; ( setField([TypeName,[],Queue],
                             [AfieldNameIN],
                             AValueIN,
                             [TypeName,[],ANewQueue]),
                    ATypedDataOUT = [TypeName,
                                     FixedLevelTypedValueList,
                                     [ Head | ANewQueue] ]
                 )
              )
            )
        )
      )
.


getField(ATypedDataIN,AfieldPathIN,AFieldValueOUT):-
 (\+var(ATypedDataIN) , \+var(AfieldPathIN))
 -> ( ATypedDataIN = [ TypeName,
                         FixedLevelTypedValueList,
                         HierarchicalTypedValueList],
        AfieldPathIN = [PathHead | PathQueue],
        member([PathHead,PathHeadValue],FixedLevelTypedValueList),
        getField(PathHeadValue,PathQueue,AFieldValueOUT)
    )
 ; false
.

getField(ATypedDataIN,[AfieldNameIN],AFieldValueOUT):-
 (\+var(ATypedDataIN) , \+var(AfieldNameIN))
  -> (  ATypedDataIN = [ TypeName,
                         FixedLevelTypedValueList,
                         HierarchicalTypedValueList],
        ( member([AfieldNameIN,AFieldValueOUT],FixedLevelTypedValueList)
          -> ! , true
          ;
          (HierarchicalTypedValueList = [ Head | Queue] ,
           (getField(Head,
                     [AfieldNameIN],
                     AFieldValueOUT)
                -> true
                ; getField(     [TypeName,[],Queue],
                                [AfieldNameIN],
                                AFieldValueOUT)
           )
          )
        )
     )
     
  ; false
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Navigation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% replace isTypeOf call in navigation by direct type checking using List structure.

% msrNav 00
%msrNav([],Path,[]):-
%  \+( (Path = [Head | _Queue] ,
%       member(Head,[msrColAdd]))
%     ),!.

msrNav([],[],[]).

/*
% to update with correct key list
msrNav([],[Head | Queue],Result):-
  \+( member(Head,[msrColSubtract,
                   msrIsEmpty,
                   msrSize])),!,
  msrNav([],Queue,Result).
*/


% to update with complete key list + implement exceptions
msrNav([],[Head | Queue],Result):-
  \+( member(Head,[     
                        msrTrue,
                        msrFalse,
                        %msrIsNew, -> exception
                        %msrIsKilled, -> exception
                        msrForAll,
                        msrExists,
%                        msrSelect,
%                        msrReject,
%                        msrClose, -> exception
%                        msrAny,
                        msrIsEmpty,
                        msrSize,
%                        msmAtPre,-> exception
%                        msmAtPost,-> exception
                        msrColEq,
                        msrColSubtract,
                        msrCount,
                        msrExcludes,
                        msrExcludesAll,
                        msrIncludes,
                        msrIncludesAll,
%                        msrSum,-> exception
%                        msrProd,-> exception
                        msrIncluding,
                        msrExcluding,
                        msrIntersection,
                        msrUnion,
                        msrAsSet,
                        msrOne
                  ])),!,
  msrNav([],Queue,Result).



% msrNav 01a
msrNav(Source,[],Result):-
\+var(Source),
is_list(Source),!,
(Result = Source
-> true
; fail).


% msrNav 01b
msrNav(Source,Path,Target):-
 (var(Source);(Source=[Value],var(Value));var(Path)) 
  -> (msrException([navigationImpossible,
                   msrNav,
                   [Source,Path,Target],
                   'unsatisfiable navigation source or path parameters']),
      !)
  ; fail.

% msrNav 02a -- msrTrue
msrNav(Source,Path,Result):-
     Path = [ msrTrue ],!,
     Result = [[ptBoolean,true]]
.

% msrNav 02a -- msrFalse
msrNav(Source,Path,Target):-
Path = [ msrFalse | _ARemainingPath],!,
(var(Source);var(Path)
  -> (msrException([navigationImpossible,
                   msrNav,
                   [Source,Path,Target],
                   'unsatisfiable navigation source or path parameters']),
      !)
  ; Target = []
)
.

% msrNav 02 -- outputEvent
msrNav(Source,Path,[Result]):-
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ ALink | ARemainingPath],
     linkTypeOwner(AType,ALink,outputEvent,TheOwnerInterfaceType),
     getInheritedInterface(AValue,
                           TheOwnerInterfaceType,
                           SuperTypeInterfaceInstance),
     ARemainingPath = [EventParametersList],
     msrSim([[SuperTypeInterfaceInstance,
              ALink,
              EventParametersList]],
            Result),
     (retract(evolution( [_VersionFrom,
                         _VersionTo,
                         _Instruction,
                         _Events,
                          inited]))
       -> true
       ; true)
.

% msrNav 03 -- inputEvent
msrNav(Source,Path,Result):-
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ ALink | ARemainingPath],
     linkTypeOwner(AType,ALink,inputEvent,TheOwnerInterfaceType),
     getInheritedInterface(AValue,
                           TheOwnerInterfaceType,
                           SuperTypeInterfaceInstance),
     ARemainingPath = [EventParametersList],
     append([SuperTypeInterfaceInstance],
            EventParametersList,
            CompletedEventParametersList),
     msrop(TheOwnerInterfaceType,
           ALink,
           CompletedEventParametersList,
           Result)
  .

% msrNav 04 -- internalPredicate
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ ALink | ARemainingPath],
     getPathLinkCategory(AType,ALink,internalPredicate),!,
     getOperationType(AType,ALink,FirstOwningType),
     operations(OperationsList),
     member([FirstOwningType,ALink,[_ParametersTypeList,_OutputType]],OperationsList),
     ARemainingPath = [PredicateParametersList | PathQueue],
     append([AValue],PredicateParametersList,ParametersList),!,
     msrop(FirstOwningType,ALink,ParametersList,Result),!,
     msrNav([Result],PathQueue,Target)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% msrNav 04b -- metaOperation
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     Path = [ ALink | ARemainingPath],
     getPathLinkCategory(_,ALink,metaOperation),!,
     metaOperations(OperationsList),
     member([ALink,[_ParametersTypeList,_OutputType]],OperationsList),
     ARemainingPath = [PredicateParametersList | PathQueue],
     append([AValue],PredicateParametersList,ParametersList),
     getType(AValue,TheType),
     msrop(TheType,ALink,ParametersList,Result),!,
     msrNav([Result],PathQueue,Target)
.

% msrNav 04a -- msrIsNew
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ msrIsNew | ARemainingPath],!,
     classTypes(ClassTypesList),
     member([AType | _],ClassTypesList),
     msmop(msrIsNew,AValue,[]),
     msrNav([AValue],ARemainingPath,Target)
.

% msrNav 04a -- msrIsKilled
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ msrIsKilled | ARemainingPath],!,
     ((classTypes(ClassTypesList),
       member([AType | _],ClassTypesList),
       msmop(getMsmVersionAtPost,[],VersionValue),
       msmop(setMsmCurrentVersion,VersionValue,_),!,
       msmop(msrIsKilled,AValue,[]),
       msmop(getMsmVersionAtPre,[],VersionValueAtPre),
       msmop(setMsmCurrentVersion,VersionValueAtPre,_),!
      )
     -> msrNav([[ptBoolean,true]],ARemainingPath,Target)
     ; msrNav([[ptBoolean,false]],ARemainingPath,Target)
     )
.

% msrNav 04c -- msrForAll
msrNav([],Path,[[ptBoolean,true]]):- 
     Path = [ msrForAll | _PathQueue], !
.

msrNav(Source,Path,Target):- 
     Path = [ msrForAll | PathQueue],
     Source = [ AValue ],!,
     (msrNav([AValue],PathQueue,[[ptBoolean,true]])
      -> Target = [[ptBoolean,true]]
      ; Target = [[ptBoolean,false]]
     )
.

msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],
     Path = [ msrForAll | _PathQueue], ! ,
     ( (msrNav([Node],Path,[[ptBoolean,true]]),
        msrNav(NodesList,Path,[[ptBoolean,true]])
       )
       -> Target = [[ptBoolean,true]]
      ;   Target = [[ptBoolean,false]]
     )
.
% msrNav 04d -- msrExists
msrNav([],Path,[[ptBoolean,false]]):- 
     Path = [ msrExists | _PathQueue], !
.

msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     getType(AValue,_AType),
     Path = [ msrExists | PathQueue],!,
     (msrNav([AValue],PathQueue,[[ptBoolean,true]])
      -> Target = [[ptBoolean,true]]
      ; Target = [[ptBoolean,false]]
     )
.

msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],
     Path = [ msrExists | _PathQueue], ! ,
     (msrNav([Node],Path,[[ptBoolean,true]])
     -> Target = [[ptBoolean,true]]
     ; msrNav(NodesList,Path,Target))
.

% msrNav 04d1 -- msrSelect
%% already in Nav00 - msrNav([],[ msrSelect | _PathQueue],[]).

msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     getType(AValue,_AType),
     Path = [ msrSelect | PathQueue],!,
     (msrNav(Source,PathQueue,[[ptBoolean,true]])
      -> Target = Source
      ; Target = []
     )
.

msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],
     Path = [ msrSelect | _PathQueue], ! ,
     msrNav([Node],Path,TargetPart1),
     msrNav(NodesList,Path,TargetPart2),
     append(TargetPart1,TargetPart2,Target)
.

% msrNav 04d1 -- msrReject
msrNav(Source,Path,Target):-
     Path = [ msrReject | PathQueue], ! ,
     msrNav(Source,[msrSelect | PathQueue],SelectTarget),
     msrNav(Source,[msrColSubtract, [SelectTarget]],Target)
.

% msrNav 04e -- msrClose
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     Path = [ msrClose | PathQueue],!,
     msrClose([AValue]),
     msrNav([AValue],PathQueue,Target),!
.

% msrNav 04e -- msrNew
msrNav(Source,Path,Target):- 
     Source = [ AValue ],
     Path = [ msrNew , ParametersList | PathQueue],!,
     getType(AValue,TheType),
     msrop(TheType,new,ParametersList,AValue),
     msrNav([AValue],PathQueue,Target),!
.

% msrNav 04e -- msrAny
msrNav(Source,Path,Target):- 
     Path = [ msrAny | PathQueue],!,
     msrNav(Source,
            [msrSelect | PathQueue],
            SelectTarget),
     random_member(Choice,
                   SelectTarget),
     Target = [Choice]
.

% msrNav 04e -- msrIsEmpty
msrNav(Source,Path,Target):- 
     Path = [ msrIsEmpty | PathQueue],!,
     (Source = []
      -> msrNav([[ptBoolean,true]],PathQueue,Target)
     ; msrNav([[ptBoolean,false]],PathQueue,Target)
     )
.

% msrNav 04e -- msrSize
msrNav(Source,Path,Target):- 
     Path = [ msrSize | PathQueue],!,
     length(Source,Size),
     msrNav([[ptInteger,Size]],PathQueue,Target)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% msrNav 05 -- relationRole
msrNav(Source,Path,Target):-
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ ALink | ARemainingPath],
     linkTypeOwner(AType,ALink,
              relationRole,
              TheOwnerType),
     generalize(AValue,TheOwnerType,TheOwnerTypeValue),
     (msmIsAtPre
     -> (getRecords(TheOwnerTypeValue,[ALink],ARecordsList),
         msrNav(ARecordsList,ARemainingPath,Target))
     ; (
          %trace,
          getField(TheOwnerTypeValue,[oid],TheOID),
          findObject(TheOID,TheOwnerTypeValueLastVersion),
          setRecords(TheOwnerTypeValueLastVersion,[ALink],Target)
       )),!
.

% msrNav 06 -- field
msrNav(Source,Path,Target):-
     Source = [ AValue ],
     getType(AValue,AType),
     Path = [ ALink | ARemainingPath],
     getPathLinkCategory(AType,ALink,field),!,
     ((msmIsAtPost,isObject(AValue))
      -> ( Target = [NewFieldValue],
            setAtb(AValue,[ALink],NewFieldValue)
         )
      ;  (getField(AValue,[ALink],AFieldValue),!,
          msrNav([AFieldValue],ARemainingPath,Target))
).

% msrNav 07 -- msmAtPre
msrNav(Source,Path,Target):-
     Path = [ msmAtPre | ARemainingPath ] ,
     msmop(getMsmVersionAtPre,[],VersionValueAtPre),
     msmop(setMsmCurrentVersion,VersionValueAtPre,_),!,
     
     msrNav(Source,ARemainingPath,Target)
%XXX
%     msmop(getMsmVersionAtPost,[],VersionValueAtPost),
%     msmop(setMsmCurrentVersion,VersionValueAtPost,_)
%XXX   
.

% msrNav 08 -- msmAtPost
msrNav(Source,Path,Target):-
     Path =[ msmAtPost | ARemainingPath],!,
     msmop(getMsmVersionAtPost,[],VersionValue),
     msmop(setMsmCurrentVersion,VersionValue,_),!,
     msrNav(Source,ARemainingPath,Target),
%XXX
     msmop(getMsmVersionAtPre,[],VersionValueAtPre),
     msmop(setMsmCurrentVersion,VersionValueAtPre,_),!
%XXX
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Collections%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% msrNav col01 -- msrColEq
msrNav(Source,Path,Target):- 
     Path = [ msrColEq , [Col] | PathQueue],!,
     ((samsort(Source,SortedSource),
       samsort(Col,SortedCol),
       SortedSource = SortedCol
      )
      -> msrNav([[ptBoolean,true]],PathQueue,Target)
      ;  msrNav([[ptBoolean,false]],PathQueue,Target)
     )
.

% msrNav col02 -- msrColSubtract
msrNav(Source,Path,Target):- 
     Path = [ msrColSubtract , [Col] | PathQueue],!,
     subtract(Source,Col,NewSource),
     msrNav(NewSource,PathQueue,Target)
.

% msrNav col03 -- msrCount
msrNav(Source,Path,Target):- 
     Path = [ msrCount , [Value] | PathQueue],!,
     msrCountOccurences(Value,Source,OccurencesNumber),
     msrNav([[ptInteger,OccurencesNumber]],PathQueue,Target)
.

% msrNav col04 -- msrExcludes
msrNav(Source,Path,Target):- 
     Path = [ msrExcludes , [Value] | PathQueue],!,
     (member(Value, Source)
      -> msrNav([[ptBoolean,false]],PathQueue,Target)
      ; msrNav([[ptBoolean,true]],PathQueue,Target)
     )
.

% msrNav col04 -- msrExcludesAll
msrNav(Source,Path,Target):- 
     Path = [ msrExcludesAll , [ColExcludedValues] | PathQueue],!,
     ((Value^(member(Value,ColExcludedValues),
              member(Value,Source)
             )
      )
      -> msrNav([[ptBoolean,false]],PathQueue,Target)
      ;  msrNav([[ptBoolean,true]],PathQueue,Target)
     )
.

% msrNav col04 -- msrIncludes
msrNav(Source,Path,Target):- 
     Path = [ msrIncludes , [Value] | PathQueue],!,
     (member(Value, Source)
      -> msrNav([[ptBoolean,true]],PathQueue,Target)
      ; msrNav([[ptBoolean,false]],PathQueue,Target)
     )
.

% msrNav col04 -- msrIncludesAll
msrNav(Source,Path,Target):- 
     Path = [ msrIncludesAll , [ColIncludedValues] | PathQueue],!,
     ((Value^(member(Value,ColIncludedValues),
              \+(member(Value,Source))
             )
      )
      -> msrNav([[ptBoolean,false]],PathQueue,Target)
      ;  msrNav([[ptBoolean,true]],PathQueue,Target)
     )
.

% msrNav col04 -- msrSum
msrNav(Source,Path,Target):- 
     Path = [ msrSum | PathQueue],!,
     msrColArithmetics(Source,add,TheResult),
     msrNav([TheResult],PathQueue,Target)
.

% msrNav col04 -- msrProd
msrNav(Source,Path,Target):- 
     Path = [ msrProd | PathQueue],!,
     msrColArithmetics(Source,mul,TheResult),
     msrNav([TheResult],PathQueue,Target)
.

% msrNav col04 -- msrIncluding
msrNav(Source,Path,Target):- 
     Path = [ msrIncluding , [Value] | PathQueue],!,
     append(Source,[Value],FirstTarget),
     msrNav(FirstTarget,PathQueue,Target)
.

% msrNav col04 -- msrExcluding
msrNav(Source,Path,Target):- 
     Path = [ msrExcluding , [Value] | PathQueue],!,
     replaceInList(Value,msrNull,Source,FirstTarget),
     msrNav(FirstTarget,PathQueue,Target)
.

% msrNav col04 -- msrIntersection
msrNav(Source,Path,Target):- 
     Path = [ msrIntersection , [ColValues] | PathQueue],!,
     findall(Value,
             (member(Value,Source),
              member(Value,ColValues)
             ),
             Intersection),
     msrNav(Intersection,PathQueue,Target)
.

% msrNav col04 -- msrUnion
msrNav(Source,Path,Target):- 
     Path = [ msrUnion , [ColValues] | PathQueue],!,
     append(Source,ColValues,Union),
     msrNav(Union,PathQueue,Target)
.

% msrNav col04 -- msrAsSet
msrNav(Source,Path,Target):- 
     Path = [ msrAsSet | PathQueue],!,
     remove_dups(Source,SourceAsSet),
     msrNav(SourceAsSet,PathQueue,Target)
.

% msrNav col04 -- msrOne
msrNav(Source,Path,Target):- 
     Path = [ msrOne | PathQueue],!,
     msrNav(Source,[msrSelect | PathQueue],SelectTarget),
     msrNav(SelectTarget,[msrSize, eq , [[ptInteger,1]]], Target)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% msrNav 09a -- msrInvalidLink
msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],
     Path = [ ALink | _APath],
     getType(Node,AType),
     getPathLinkCategory(AType,ALink,Category),
     ((Category = msrInvalidLink)
      -> (!,msrException([msrexAbort,
                       getPathLinkCategory,
                       [AType,ALink,Result],
                       'impossible to determine path link type.'])
          )
     ;fail
     )
.

% msrNav 09b -- mslKeyword
msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],
     Path = [ ALink | _APath],
     getType(Node,AType),
     getPathLinkCategory(AType,ALink,mslKeyword),!,
     msrNav([Node],Path,TargetForNode),!,
     msrNav(NodesList,Path,TargetForNodesList),
     append(TargetForNode,TargetForNodesList,Target)
.


% msrNav 09c -- Collection Handling
msrNav(Source,Path,Target):-
     Source=[ Node | NodesList],!,
     ((msrNav([Node],Path,TargetForNode),
       msrNav(NodesList,Path,TargetForNodesList),
       append(TargetForNode,TargetForNodesList,Target)
      )
     -> true
     ; fail)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getPathLinkCategory(AType,PathHead,Result):-
   var(Result), !,
   findall(LinkType, linkType(AType,PathHead,LinkType), LinkTypesList),
   (length(LinkTypesList,1)
   -> [Result] = LinkTypesList
   ; Result = msrInvalidLink
    )
.

getPathLinkCategory(AType,PathHead,Result):-
    linkType(AType,PathHead,Result).

linkType(AType,ALink,internalPredicate):-
 getOperationType(AType,ALink,FirstOwningType),
 operations(OperationsList),
 interfaceTypes(InterfaceTypesList),
 member([FirstOwningType,ALink,_ASignature],OperationsList),
 \+(member([_AnActor,_AnInterfaceCategory,AType],
           InterfaceTypesList)),!.

linkType(AType,ALink,field):-
 getFieldsListFromTypeDef(AType,FieldsPathsList),
 member([ALink | _],FieldsPathsList),!.
 
linkType(AType,ALink,relationRole):-
 relationTypes(RelationDefList),
 member([RelationCategory,
         RelationName,
         RelatedTypesList,
         PartsDefList],
        RelationDefList),
 member([AType,_ARoleName],RelatedTypesList),
 APart^( member(APart,PartsDefList),
         getField(APart,[roleName],[ptString,ALink])
       ),!.

linkType(AType,ALink,outputEvent):-
 interfaceTypes(InterfaceLists),
 member([Actor,ctOutputInterface,AType],InterfaceLists),
 allSuperTypes(Actor,ActorSuperTypesList),
 AllActorTypes = [Actor | ActorSuperTypesList],
 outputEvents(OutputEventsList),
 
 TheActorType^(member(TheActorType,AllActorTypes),
               member([TheActorType,ctOutputInterface,AInterfaceType],
                      InterfaceLists),
               member([AInterfaceType,ALink,_Profile],
                      OutputEventsList)
              )
.

linkType(AType,ALink,inputEvent):-
 interfaceTypes(InterfaceLists),
 member([Actor,ctInputInterface,AType],InterfaceLists),
 allSuperTypes(Actor,ActorSuperTypesList),
 AllActorTypes = [Actor | ActorSuperTypesList],
 inputEvents(InputEventsList),
 
 TheActorType^(member(TheActorType,AllActorTypes),
               member([TheActorType,ctInputInterface,AInterfaceType],
                      InterfaceLists),
               member([AInterfaceType,ALink,_Profile],
                      InputEventsList)
              )
.

linkType(_,ALink,metaOperation):-
 metaOperations(MetaOperationsList),
 member([ALink,_ASignature],MetaOperationsList),!
.

linkType(_AType,ALink,mslKeyword):-
 member(ALink,[msrTrue,
               msrAny,
               msrIsNew,
               msrForAll,
               msrExists,
               msrSelect,
               msrClose,
               msmAtPre,
               msmAtPost]
               ),
!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isOutputEvent(AnOperationName):-
 %Could add the type checking for parameters
 outputEvents(OutputEventsList),
 member([_AnOutputInterfaceName,AnOperationName,_AParametersList],
        OutputEventsList).
                
isInputEvent(AnEventName):-
 %Could add the type checking for parameters
 inputEvents(InputEventsList),
 member([_AnOutputInterfaceName,AnEventName,_AParametersList],
        InputEventsList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relations Getters and Setters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 msrReplaceObjectInAssociations(OldObject,NewObject):-
   getType(OldObject,AType),
   findall(RelationName,
             (getRelationNameAndDimension(
                              AType,
                              ARoleName,
                              RelationName,
                              TargetDimension,
                              SourceRoleName)),
              RelationsList),

 % OK ->  msmop(getMsmVersionAtPost,[],Version),
 currentMessamVersion(Version),
 
 write('msrReplaceObjectInAssociations - '),write('\n'),simpleListListing([OldObject,NewObject]),
 write('version - '),write('\n'),simpleListListing([Version]),
 
  findall([Relation,NewRecords],
           (member(Relation,RelationsList),
            messam(Version,relations,Relation,Records),
            (NewObject=[]
             -> replaceInList([Role,OldObject],msrNull,Records,NewRecords)
             ; replaceInList([Role,OldObject],[Role,NewObject],Records,NewRecords)
            ),
            retract(messam(Version,relations,Relation,Records)),
            assert(messam(Version,relations,Relation,NewRecords))  
           ),
           NewRecordsList)
      .

getRecords(AnObject,[ARoleName],ARecordsList):-
 % Ã  utiliser si seuls les oid sont dans les associations
 % getObjects([AKeyValue],[AnObject]),
 getType(AnObject,SourceDimension),
 getRelationNameAndDimension(SourceDimension,
                              ARoleName,
                              RelationName,
                              TargetDimension,
                              _SourceRoleName),
 msmop(select,[RelationName,
               SourceDimension,
               AnObject,
               TargetDimension],
       ARecordsList).

setRecords(AnObject,[ARoleName],ARecordsList):-
 (var(ARecordsList)
 -> (msrException([msrexInterface,
                  setRecords,
                  [AnObject,
                   [ARoleName],
                   ARecordsList],
                  'ARecordsList is a variable']))
 ;
 (
 getType(AnObject,SourceType),
 getRelationNameAndDimension(SourceType,
                              ARoleName,
                              RelationName,
                              TargetType,
                              ASourceRoleName),
 
findall(CorrectTypeRecord,
        (member(InitialRecord,
                ARecordsList),
         generalize(InitialRecord,TargetType,CorrectTypeRecord)
        ),
        CorrectTypeRecords),

msmop(getMsmVersionAtPost,[],Version),
messam(Version,relations,RelationName,CurrentStatus),

findall([[ASourceRoleName,AnObject],
         [ARoleName,AValue]],
        (member(Record,CorrectTypeRecords),
         member([ASourceRoleName,AnObject],Record)),
        RecordsToDelete),

 subtract(CurrentStatus,RecordsToDelete,ReducedStatus),
                           
 findall([[ASourceRoleName,AnObject],
          [ARoleName,AValue]],
         (member(AValue,CorrectTypeRecords)),
         NewStatus),

 append(NewStatus,ReducedStatus,NewRecordsList),
 
  msmop(updateAll,[relations,
                  RelationName,
                  NewRecordsList],
       [])
 
 )).
        



getRelationNameAndDimensionORIGINAL(
             ASourceType,
             ATargetRoleName,
             RelationName,
             ATargetType,
             ASourceRoleName):-
 relationTypes(RelationTypesList),
 [RelationName,ATargetType]^
         (member([_Category,RelationName,
                  _RelatedTypes,PartsList],
                 RelationTypesList),
          member(Part1,PartsList),
          member(Part2,PartsList),
          \+(Part1=Part2),
          msrNav([Part1],[partEnd],[[ptString, ASourceType]]),
          msrNav([Part1],[roleName],[[ptString, ASourceRoleName]]),
          msrNav([Part2],[roleName],[[ptString, ATargetRoleName]]),
          msrNav([Part2],[partEnd],[[ptString, ATargetType]]))
.

getRelationNameAndDimension(
             ASourceType,
             ATargetRoleName,
             RelationName,
             ATargetType,
             ASourceRoleName):-
 relationTypes(RelationTypesList),
 member([_Category,RelationName,
                   RelatedTypes,_PartsList],
                 RelationTypesList),
 member([ASourceType,ASourceRoleName],RelatedTypes),
 member([ATargetType,ATargetRoleName],RelatedTypes),
 \+(ASourceRoleName = ATargetRoleName).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Object's Getters and Setters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getObjects([],[]).
 
getObjects([ObjectID | ObjectsIDList],
           [ObjectValue |AnObjectsValuesListQueue]):-
 findObject(ObjectID,ObjectValue),
 getObjects(ObjectsIDList,AnObjectsValuesListQueue).

findObject(ObjectID,ExtractedObject):-
 msmop(getMsmCurrentVersion,[],CurrentVersionValue),
 classTypes(ClassTypesList),
 findall(Object,
             ( member([ActName,_],ClassTypesList),
               messam(CurrentVersionValue,
                     classes,
                     ActName,
                     AnObjectsList),
               member(Object,AnObjectsList),
               getField(Object,[oid],TheObjectID),
               TheObjectID = ObjectID
             ),
             ObjectsList),
 
 ((length(ObjectsList,1) ; length(ObjectsList,0))
  -> ObjectsList = [ExtractedObject]
  ; msrException([msrexMessamState,
                  findObject,
                  [ObjectID,
                   ExtractedObject,
                   ObjectsList],
                  'Several Objects with same oid !'])
 )
        
             .

extractObject(ObjectValue,ObjectID,ExtractedObject):-
 getType(ObjectValue,AType),
 ( getField(ObjectValue,[oid],ObjectID)
   % OLD msrNav([ObjectValue],[oid],[ObjectID])
  -> ExtractedObject = ObjectValue
 ; (superTypes(AType,SuperTypesList),
    ExtractedObject
            ^(member(ASuperType,SuperTypesList),
              generalize(ObjectValue,ASuperType,ASuperObjectValue),
              extractObject(ASuperObjectValue,ObjectID,ExtractedObject)))
 ).

% in: Object, AttributeName
getAtb(ObjectID,AttributePath,Value):-
 getObject(ObjectID,ObjectValue),
 getField(ObjectValue,AttributePath,Value).


%TODO
% in: Object, AttributeName
getAtbAtPre(ObjectID,AttributePath,ValueAtPre):-true.

% in: Object, AttributeName
setAtb(ObjectValue,AttributePath,NewValue):-
  (var(ObjectValue);var(AttributePath))
 -> (msrException([msrexInterface,
                  setAtb,
                  [ObjectValue,AttributePath,NewValue],
                  'Incorrect input parameter(s)'])
    )
 ;(
      AttributePath = [PathHead | PathQueue],
      (PathQueue = [] 
       -> fail
       ;
       (ObjectValue = [ TypeName,
                          FixedLevelTypedValueList,
                          HierarchicalTypedValueList],

        member([PathHead,PathHeadValue],FixedLevelTypedValueList),
        setAtb(PathHeadValue,
                PathQueue,
                NewValue)
        )
      )
  )
.

setAtb(ObjectValue,[AfieldNameIN],NewValue):-
  (var(ObjectValue);\+atomic(AfieldNameIN))
 -> (msrException([msrexInterface,
                  setAtb,
                  [ObjectValue,[AfieldNameIN],NewValue],
                  'Incorrect input parameter(s)'])
    )
 ;
      ( ObjectValue = [ AType,
                         FixedLevelTypedValueList,
                         HierarchicalTypedValueList],
        ( member([AfieldNameIN,_CurrentValue],FixedLevelTypedValueList)
          -> ( getField(ObjectValue,[oid],TheOID),
               findObject(TheOID,ObjectValueLastVersion),
                setField(ObjectValueLastVersion,
                         [AfieldNameIN],
                         NewValue,
                         NewObjectValue),

                currentMessamVersion(Version),
                
                findall([Category,Type],
                        (messam(Version,Category,Type,ObjectsList),
                         replaceInList(ObjectValueLastVersion,
                                       NewObjectValue,
                                       ObjectsList,
                                       NewObjectsList),
                         retract(messam(Version,Category,Type,ObjectsList)),
                         assert(messam(Version,Category,Type,NewObjectsList))
                        ),
                        CatTypesList)
             )

                 
          ; ( HierarchicalTypedValueList = [ Head | Queue] ,
              (setAtb(Head,
                       [AfieldNameIN],
                       NewValue)
               -> true
               ; ( setAtb([AType,[],Queue],
                           [AfieldNameIN],
                           NewValue)
                 )
              )
            )
        )
      )
.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exceptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msrException([ExceptionName,
                  Predicate,
                  ParametersList,
                  Comment]):-
 
 write('---------------------------'),write('\n'),
 write('Predicate - '),write(Predicate),write('\n'),
 write('Exception handler name - '),write(ExceptionName),write('\n'),
 write('Comment - '),write(Comment),write('\n'),
 write('Parameters - '),write('\n'),
 simpleListListing(ParametersList),
 write('---------------------------'),write('\n')
% ,trace
% ,fail
 ,abort
 .
 

