
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrop/4.
:- multifile isTypeOf/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic allDynamicPredicates/1.
:- assert(allDynamicPredicates([])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

messamInitialization:-

  initDynamicPredicate(nextObjectID,1,[0]),
  
  initDynamicPredicate(currentMessamVersion,1,[[[sim,1]]]),

  initDynamicPredicate(lastMessamVersion,1,[[[sim,1]]]),

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  initDynamicPredicate(messam,4,null),
  initDynamicPredicate(primitiveTypes,1,[[]]),
  initDynamicPredicate(enumerationTypes,1,[[]]),
  initDynamicPredicate(dataTypes,1,[[]]),
  initDynamicPredicate(relationTypes,1,[[]]),
  initDynamicPredicate(subTypes,1,[[]]),
  initDynamicPredicate(classTypes,1,[[]]),
  initDynamicPredicate(actorTypes,1,[[]]),
  initDynamicPredicate(interfaceTypes,1,[[]]),

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  initDynamicPredicate(inputEvents,1,[[]]),
  initDynamicPredicate(outputEvents,1,[[]]),
  initDynamicPredicate(operations,1,[[]]),
  initDynamicPredicate(metaOperations,1,[[]]),
  initDynamicPredicate(protectedOperations,1,[[]]),
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  initDynamicPredicate(evolution,1,null),
  initDynamicPredicate(commentHeader,2,[]),
  initDynamicPredicate(commentData,2,[]),
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  initDynamicPredicate(testCases,1,[[]])

    .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Messam State Space Creation
%Relations
messaminit(relations):-
 findall(ArtName,
         (relationTypes(RelationTypesList),
          member([_ARelationNature,
                  ArtName,
                  _ArtRelatedTypes,
                  _ArtPartsList],
                 RelationTypesList),
         msmop(define,[relations,ArtName,[]],_)),L).

%Classes
messaminit(classes):-
 findall(ActName,
         (classTypes(ClassTypesList),
          member([ActName,_ActDef],ClassTypesList),
         msmop(define,[classes,ActName,[]],_)),L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Meta Environnement Types
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
messamInitTypes:-
  newType(dataTypes,[rtRelDefPart,
                               [ [partEnd,ptString],
                                 [roleName,ptString],
                                 [roleType,ptString],
                                 [cardMin,ptString],
                                 [cardMax,ptString]
                               ]]),
  
  newType(classTypes,[ctMsrActor,[]]),
  newType(classTypes,[ctInputInterface,[]]),
  newType(classTypes,[ctOutputInterface,[]])
.

messamReset:-
  initDynamicPredicate(nextObjectID,1,[0]),
  initDynamicPredicate(currentMessamVersion,1,[[[sim,1]]]),
  initDynamicPredicate(lastMessamVersion,1,[[[sim,1]]]),
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  initDynamicPredicate(messam,4,null),
  initDynamicPredicate(evolution,1,null)
  .
  
:- messamInitialization.
:- messamInitTypes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
