/* -*- Mode:Prolog; coding:iso-8859-1; -*- */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* msrSolvePredicates  */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



msrSolve(consistentboundMessamExpansion,
         [Dimension,ATypeName,[ptInteger,N]],
         ExpansionList):-
(classTypes(ClassTypesList),
member([ATypeName,_],ClassTypesList))
->
(
 msrSolve(freeboundMessamExpansion,
          [Dimension,ATypeName,[ptInteger,N]],
          ExpansionList),!,
 %msmValuesListing(structuredTypes,ExpansionList),
 resetOIDs(ExpansionList,NewExpansionList),
 msrSolve(consistentMessamExpansion,
         [Dimension,ATypeName],
         NewExpansionList)
)
; fail
.

msrSolve(freeboundMessamExpansion,
         [_Dimension,_Type,[ptInteger,0]],[]):-!.

msrSolve(freeboundMessamExpansion,
         [Dimension,ATypeName,[ptInteger,N]],
         ExpansionList):-
 msrop(ATypeName,new,[bound],ANewValue),
 %msmop(add,[Dimension,ATypeName,[ANewValue]],_),
 NewN is N-1,
 msrSolve(freeboundMessamExpansion,
          [Dimension,
           ATypeName,
           [ptInteger,NewN]]
         ,ExpansionListQueue),
 append([ANewValue],ExpansionListQueue,ExpansionList),!.


msrSolve(consistentMessamExpansion,
         [_Dimension,_ATypeName],
         []):-!.

msrSolve(consistentMessamExpansion,
         [Dimension,ATypeName],
         [AValue | AValuesList]):-

 msmop(getMsmVersionAtPost,[],VersionValue),
 msmop(setMsmCurrentVersion,VersionValue,_),

 msmop(add,[Dimension,ATypeName,[AValue]],_),

( Dimension = classes
  -> (theSystem(TheSystem),
     getType(AValue,AValueType),
     (getRelationNameAndDimension(
             AValueType,
             rnSystem,
             AssociationName,
             _ATargetType,
             ASourceRoleName)
      -> (
          msrSolve(consistentMessamExpansion,
                [relations,AssociationName],
                [[[rnSystem,TheSystem],
                  [ASourceRoleName,AValue]]])
         )
      ; true),
      
         isSubType(AValueType,ctMsrActor)
         -> (interfaceTypes(AllInterfaceTypesList),
             member([AValueType, ctInputInterface, InputInterfaceTypeName],
                    AllInterfaceTypesList),
             msrop(InputInterfaceTypeName,init,[TheInputInterfaceInstance],[ptBoolean,true]),
             getAssociationName(AValueType,
                                rnInterfaceIN,
                                InputInterfaceAssociationName),

             msrSolve(consistentMessamExpansion,
                      [relations,InputInterfaceAssociationName],
                      [[[rnActor,AValue],
                        [rnInterfaceIN,TheInputInterfaceInstance]]]),

             member([AValueType, ctOutputInterface, OutputInterfaceTypeName],
                     AllInterfaceTypesList),
             msrop(OutputInterfaceTypeName,init,[TheOutputInterfaceInstance],[ptBoolean,true]),
             getAssociationName(AValueType,
                                rnInterfaceOUT,
                                OutputInterfaceAssociationName),

             msrSolve(consistentMessamExpansion,
                      [relations,OutputInterfaceAssociationName],
                      [[[rnActor,AValue],
                        [rnInterfaceOUT,TheOutputInterfaceInstance]]])

            )
        ; true
    )
; true ,

 msrSolve(consistentMessamExpansion,
      [Dimension,ATypeName],
      AValuesList)
 
),!,

         msmop(getMsmVersionAtPre,[],VersionValueAtPre),
         msmop(setMsmCurrentVersion,VersionValueAtPre,_)
         .




