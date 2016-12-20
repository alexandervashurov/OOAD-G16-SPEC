% Author: Nicolas Guelfi
% Date: 12/01/2012

/* -----------------------------------------*/

launchCreateSystemAndEnvironment(ParametersList,Result):-

        messaminit(relations),
        messaminit(classes),
        
%         messamListing,
         msmop(evolve,[sim],_),
%         messamListing,

        msrsat(outactMsrCreator,
                  oeCreateSystemAndEnvironment,
                  [_ | ParametersList],Result),
        
%        messamListing,
        
        msmop(getMsmVersionAtPost,[],Version),
        messam(Version,classes,outactMsrCreator,[TheCreatorOUT]),
        
        member([Axis,Index],Version),
        IndexFrom is Index-1,
        IndexTo is Index,
        NewIndexVersionFrom = [Axis,IndexFrom],
        NewIndexVersionTo = [Axis,IndexTo],
        select([Axis,Index],Version,NewIndexVersionTo,VersionTo),
        select([Axis,Index],Version,NewIndexVersionFrom,VersionFrom),
        assert(evolution([VersionFrom,
                  VersionTo,
                  [TheCreatorOUT,
                   oeCreateSystemAndEnvironment,
                   ParametersList],
                  [],
                  Result])),

%         messamListing,
         msmop(evolve,[sim],_),
%         messamListing,

        msmop(getMsmLastVersion,[],VersionS),
        member([Axis,IndexS],VersionS),
        IndexFromS is IndexS-1,
        IndexToS is IndexS,
        NewIndexVersionFromS = [Axis,IndexFromS],
        NewIndexVersionToS = [Axis,IndexToS],
        select([Axis,IndexS],VersionS,NewIndexVersionToS,VersionToS),
        select([Axis,IndexS],VersionS,NewIndexVersionFromS,VersionFromS),
        assert(evolution([VersionFromS,
                  VersionToS,
                  [TheCreatorOUT,
                   silent,
                   []],
                  [],
                  [satisfied]])).


/* -----------------------------------------*/

msrSim([Instruction],Result):-
msmop(initEvolutionStep,[sim,Instruction],'inited'),
execute(Instruction,Result),
msmop(addEvolutionStep,[sim,Instruction],Result)
.

execute([AnInterfaceInstance,
         OperationName,
         OperationParametersInstances],
        Result):-
msmop(evolve,[sim],_), 
getType(AnInterfaceInstance,AType),
%needs to declare the inherited output events in output events list of the subtype interface
%getOperationType(AType,OperationName,AnOperationOwningInterfaceType),
%msrop(AType,as,[[AnOperationOwningInterfaceType]],AnOwningInterfaceInstance),

Instruction = [msrsat,
               AType,
               OperationName,
%               [AnOwningInterfaceInstance | OperationParametersInstances],
               [AnInterfaceInstance | OperationParametersInstances],
               Result],
Goal =.. Instruction,
Goal.

/* -----------------------------------------*/

msrSent([AnInputInterfaceInstance,
         AnInputEvent,
         AnInputEventParametersList]):-
 msmop(addSentEvent,
      [sim,
        [AnInputInterfaceInstance,
         AnInputEvent,
         AnInputEventParametersList]],
      []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generic Output Interface Operation
% satisfiability semantics scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msrsat(AnOutputInterfaceClassName,
      AnOperationName,
      AParametersLists,
      Result):-
isOutputEvent(AnOperationName),!,
(    (  ( checkTypes(AParametersLists),
          msrop(AnOutputInterfaceClassName,
              AnOperationName,
              [preProtocol | AParametersLists],
              _)
         )
          -> (append([satisfiedAtPreProtocol],[],TempRes1),
              (msrop(AnOutputInterfaceClassName,
                      AnOperationName,
                      [preFunctional | AParametersLists],
                      _)
               -> (append(TempRes1,[satisfiedAtPreFunctional],TempRes2),
                   (msrop(AnOutputInterfaceClassName,
                          AnOperationName,
                          [post | AParametersLists],
                          _)
                   -> append(TempRes2,[satisfiedAtPostFunctional],Result)
                   ; append(TempRes2,[failureAtPost],Result)
                   )
                  )
                ; append(TempRes1,[failureAtPreFunctional],Result)
              )
             )
            ; append([rejectedAtPreProtocol],[],Result)
     )
).

