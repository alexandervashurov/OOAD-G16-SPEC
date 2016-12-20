%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msmop/3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Messam Relations Management
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


msmop(define,[ADimension,ActName,AValuesList],[]):-
 currentMessamVersion(Version),
 SetGoalOnePartA=..[messam,
                 Version,
                 ADimension,
                 ActName,
                 AValuesList],
 SetGoalOne=..['assert',SetGoalOnePartA],
 SetGoalOne,!.

msmop(add,[ADimension,ATypeName,AValuesList],[]):-
 currentMessamVersion(Version),
 (messam(Version,ADimension,ATypeName,CurrentStatus)
 -> ( retract(messam(Version,ADimension,ATypeName,CurrentStatus)),
      append(AValuesList,CurrentStatus,NewStatus),
      assert(messam(Version,ADimension,ATypeName,NewStatus))
    )
 ; assert(messam(Version,ADimension,ATypeName,AValuesList))
 ).
 
msmop(updateValue,[ADimension,ATypeName,AValue,AnUpdatedValue],[]):-
 currentMessamVersion(Version),
% messam(Version,ADimension,ATypeName,CurrentStatus),
 retract(messam(Version,ADimension,ATypeName,CurrentStatus)),
 select(AValue,CurrentStatus,AnUpdatedValue,NewStatus)
 -> assert(messam(Version,ADimension,ATypeName,NewStatus))
 ; true.

msmop(updateAll,[ADimension,ATypeName,AnUpdatedValuesList],[]):-
 currentMessamVersion(Version),
 retract(messam(Version,ADimension,ATypeName,_CurrentStatus)),
 assert(messam(Version,ADimension,ATypeName,AnUpdatedValuesList))
.

 msmop(remove,[ADimension,ATypeName,AValuesList],[]):-
 currentMessamVersion(Version),
 messam(Version,ADimension,ATypeName,CurrentStatus),
 retract(messam(Version,ADimension,ATypeName,CurrentStatus)),
 subtract(CurrentStatus,AValuesList,NewStatus),
 assert(messam(Version,ADimension,ATypeName,NewStatus)).


 msmop(msrIsNew,AClassInstance,[]):-
 ((var(AClassInstance)
  ;(getField(AClassInstance,[oid,value],[ptInteger,TheVal]),
    \+var(TheVal))
  ;(\+isObject(AClassInstance))
 -> fail 
 ; (getType(AClassInstance,ActType),
    boundOIDs([AClassInstance]),!,

    msrSolve(consistentMessamExpansion,
             [classes,ActType],[AClassInstance]),
   
    allSuperTypes(ActType,SuperTypesList),
    
    write('new -> '),write(AClassInstance),write('\n'),

    findall([ASuperType,ASuperTypeClassInstance],
            (member(ASuperType,SuperTypesList),
             generalize(AClassInstance,
                        ASuperType,
                        ASuperTypeClassInstance),
             msrSolve(consistentMessamExpansion,
                      [classes,ASuperType],[ASuperTypeClassInstance])
            ),
            AddedInstancesList)
   )
  )
 )
.

msmop(updateComposition,
      [ACompositeInstance,APartNameRole,APartInstancesList],[]):-
(var(APartInstancesList) ; var(ACompositeInstance))
-> fail
;(
ACompositeInstance = [[ACompositeTypeName | _] | _ ],
APartInstancesList = [[APartTypeName | _ ] | _ ],
relationTypes(RelationTypesList),
findall([CompositionName,ACompositeRole,APartNameRole],
        (member([composition,CompositionName,
                 [[ACompositeTypeName,ACompositeRole],
                  [APartTypeName,APartNameRole]],_],
                RelationTypesList)),
        CompositionNamesList),
( CompositionNamesList = []
  -> true
  ; (  % Should have only one composition found
       CompositionNamesList =
         [[[ACompositeInstance,ACompositeRole],
           [Instance,APartNameRole]]],
       findall([[ACompositeInstance,ACompositeRole],
                 [Instance,APartNameRole]],
                member(Instance,APartInstancesList),
                NewRelationInstancesList),
       msmop(updateAll,[relations,CompositionName,NewRelationInstancesList],[]))
    )
)
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Messam Relations Management
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msmop(select,[RelationName,
               SourceDimension,
               AnObject,
               TargetDimension],
       ARecordsList):-
 msmop(getMsmCurrentVersion,[],CurrentVersionValue),
 messam(CurrentVersionValue,relations,RelationName,RelatedValuesList),

 findall(RelatedValues,
         (member(RelatedValues,RelatedValuesList),
          member([ARole,AnObject],RelatedValues)
         ),
          ATargetsList),
 findall(Record,
         (member(Target,ATargetsList),
          member([_Arole,Record],Target),
          getType(Record,TargetDimension)),
         ARecordsList)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Messam Versions Management
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msmWriteVersions:-
 msmop(getMsmVersionAtPre,[],VPre),
 msmop(getMsmVersionAtPost,[],VPost),
 msmop(getMsmLastVersion,[],VL),
msmop(getMsmCurrentVersion,[],VC),

write('\n'),
write('Current Version:' ),write(VC),write('\n'),
write('Last Version:' ),write(VL),write('\n'),
write('Pre Version:' ),write(VPre),write('\n'),
write('Post Version:' ),write(VPost),write('\n').

msmIsAtPre:- 
 msmop(getMsmVersionAtPre,[],VersionValue),
 msmop(getMsmCurrentVersion,[],VersionValue)
.
msmIsAtPost:- 
 msmop(getMsmVersionAtPost,[],VersionValue),
 msmop(getMsmCurrentVersion,[],VersionValue)
.

msmop(getMsmVersionAtPre,[],Version):-
 lastMessamVersion(AllVersionsDefs),
 (member([sim,LastIndexValue],AllVersionsDefs)
 -> (VersionNumberAtPre is LastIndexValue - 1,
     SimVersionValue = [sim,VersionNumberAtPre],
     select([sim,LastIndexValue],AllVersionsDefs,SimVersionValue,Version))
 ; fail).

msmop(getMsmVersionAtPost,[],VersionValue):-
 lastMessamVersion(VersionValue),
 (member([sim,_LastIndexValue],VersionValue)
 -> true
 ; fail).
 
msmop(getMsmLastVersion,[],CurrentVersionValue):-
 lastMessamVersion(CurrentVersionValue).

msmop(getMsmLastVersion,[Axis],CurrentVersionValue):-
 lastMessamVersion(AllVersionsDefs),
 member([Axis,LastIndexValue],AllVersionsDefs),
 CurrentVersionValue = [Axis,LastIndexValue].

 msmop(setMsmLastVersion,Version,_):-
 retractall(lastMessamVersion(_)),
 assert(lastMessamVersion(Version)).

msmop(getMsmCurrentVersion,[],CurrentVersionValue):-
 currentMessamVersion(CurrentVersionValue).

msmop(getMsmCurrentVersion,[Axis],CurrentVersionValue):-
 currentMessamVersion(AllVersionsDefs),
 member([Axis,LastIndexValue],AllVersionsDefs),
 CurrentVersionValue = [Axis,LastIndexValue].

 msmop(setMsmCurrentVersion,Version,_):-
 retractall(currentMessamVersion(_)),
 assert(currentMessamVersion(Version)).

msmop(evolve,[Axis],_):-
 msmop(getMsmVersionAtPost,[],Version),
 findall([Dimension,ATypeName,CurrentStatus],
         messam(Version,Dimension,ATypeName,CurrentStatus),
         AllMessamParameters),
 member([Axis,Index],Version),
 NewIndex is Index + 1,
 NewIndexVersion = [Axis,NewIndex],
 select([Axis,Index],Version,NewIndexVersion,NewVersion),
 msmop(setMsmCurrentVersion,NewVersion,_),
 msmop(setMsmLastVersion,NewVersion,_),
 msmop(createNewMessam,AllMessamParameters,_),
 msmop(setMsmCurrentVersion,Version,_)
 .
 
msmop(createNewMessam,[],_).
msmop(createNewMessam,AllMessamParameters,_):-
 AllMessamParameters = [ [Dimension,ATypeName,CurrentStatus] 
                         | AllMessamParametersQueue ],

 msmop(add,[Dimension,ATypeName,CurrentStatus],_),
 msmop(createNewMessam,AllMessamParametersQueue,_).

/* -----------------------------------------------
Instruction Simulation Histories Management
-----------------------------------------------*/
msmop(addEvolutionStep,[Axis,Instruction],Result):-
 msmop(getMsmLastVersion,[],Version),
 member([Axis,Index],Version),
 IndexFrom is Index-1,
 IndexTo is Index,
 NewIndexVersionFrom = [Axis,IndexFrom],
 NewIndexVersionTo = [Axis,IndexTo],
 select([Axis,Index],Version,NewIndexVersionTo,VersionTo),
 select([Axis,Index],Version,NewIndexVersionFrom,VersionFrom),
%  write('\n'),findall(L,evolution(L),LNG1),simpleListListing(LNG1),write('\n'),
 (retract(evolution( [VersionFrom,
                      VersionTo,
                      _OldInstruction,
                      SentEvents,
                      _OldResult]))
  -> true
 ; true),
 (var(SentEvents) -> SentEvents = [] ; true),
 assert(evolution([VersionFrom,
                  VersionTo,
                  Instruction,
                  SentEvents,
                  Result]))
%, write('\n'),findall(L,evolution(L),EVL),simpleListListing(EVL),write('\n')
.

msmop(addSentEvent,[Axis,Event],[]):-
 msmop(getMsmLastVersion,[],Version),
 member([Axis,Index],Version),
 IndexFrom is Index - 1,
 IndexTo is Index - 0,
 NewIndexVersionFrom = [Axis,IndexFrom],
 NewIndexVersionTo = [Axis,IndexTo],
 select([Axis,Index],Version,NewIndexVersionTo,VersionTo),
 select([Axis,Index],Version,NewIndexVersionFrom,VersionFrom),

( evolution(      [VersionFrom,
                  VersionTo,
                  Instruction,
                  PreviousSentEvents,
                  Result])
-> retract(
    evolution(   [VersionFrom,
                  VersionTo,
                  Instruction,
                  PreviousSentEvents,
                  Result]))
; PreviousSentEvents =[] ),
  
 append([Event],PreviousSentEvents,SentEvents),
 assert(evolution([VersionFrom,
                  VersionTo,
                  Instruction,
                  SentEvents,
                  Result])).

msmop(initEvolutionStep,[Axis,Event],Result):-
 msmop(getMsmLastVersion,[],VersionTo),
 member([Axis,Index],VersionTo),
 IndexFrom is Index - 1,
 NewIndexVersionFrom = [Axis,IndexFrom],
 select([Axis,Index],VersionTo,NewIndexVersionFrom,VersionFrom),
 assert(evolution([VersionFrom,
                  VersionTo,
                  '',
                  [],
                  Result])).
