/* -*- Mode:Prolog; coding:iso-8859-1; -*- */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Global  Listings  */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outputListings(system):- 
 documentationTextListings(system).

outputListings(messim):- 
 allPredicatesListing,
 documentationTextListings(messim).

allPredicatesListing:-
msrFilePath(allPredicatesListing,Path),
telling(OldOutputStream),
tell(Path),
listing,
told,
tell(OldOutputStream).

messirListing:-
msrFilePath(messirSystemListing,Path),
telling(OldOutputStream),
tell(Path),
write('\n'),
msrprint(allDynamicPredicates,'allDynamicPredicates'),
msrprint(primitiveTypes,'Primitive Types '),
msrprint(enumerationTypes,'Enumeration Types '),
msrprint(dataTypes,'DataTypes Types '),
msrprint(classTypes,'Class Types '),
msrprint(subTypes,'Inheritance Relations '),
msrprintRelations('Relation Types '),
msrprint(actorTypes,'Actor Types '),
msrprint(interfaceTypes,'Interface Types '),
msrprint(inputEvents,'Actor''s Input Events'),
msrprint(outputEvents,'Actor''s Output Events'),
msrprint(operations,'Operations'),
msrprint(operationsWithInheritance,'all operations accessible using navigation by type with inheritance'),
msrprint(allTypesDefinition,'All Types by Category'),
told,
tell(OldOutputStream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Messam Listing Predicates  */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

messamListingRaw(TestCaseNumber):-
msrFilePath([messamListingRaw,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
listing(messam),
told,
tell(OldOutputStream).


messamListing2(TestCaseNumber):-
msrFilePath([messamListing,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
findall([Version,Category,Type,Values],
        messam(Version,Category,Type,Values),
        MessamList),
samsort(MessamList,SortedMessamList),
findall([Version,Category,Type,Values],
        (member([Version,Category,Type,Values],
               SortedMessamList),
         msmListing(Version,Category,Type,Values)),
        _),
told,
tell(OldOutputStream)
.

messamListing(TestCaseNumber):-
integer(TestCaseNumber),
msrFilePath([messamListing,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
findall(Version,
        messam(Version,Category,Type,Values),
        VersionsBag),
remove_dups(VersionsBag, VersionsList),
samsort(VersionsList,SortedVersionsList),
findall([Category,Type],
        messam(Version,Category,Type,Values),
        CatTypeBag),
remove_dups(CatTypeBag, CatTypeList),
samsort(CatTypeList,SortedCatTypeList),
findall(Type,
        (member([Category,Type],SortedCatTypeList),
         write('-----------------------------------------'),write('\n'),
         findall(Values,
                 (member(Version,SortedVersionsList),
                 messam(Version,Category,Type,Values),
                 samsort(Values,SortedValues),
                msmListing(Version,Category,Type,SortedValues)),
                _)
        ),_),
told,
tell(OldOutputStream)
.

messamListing([TestCaseNumber,Version]):-
msrFilePath(projectBaseFolderPath,ProjectPath),
Version = [[Axis,Dim]],
atomic_list_concat([ProjectPath,
                    '/out/tests/',
                    'case-',TestCaseNumber,'-',
                    'messamListing','-',
                    Axis,'-',
                    Dim,'.txt'
                   ],
                   Path),

 ( file_exists(Path) 
   -> delete_file(Path)
   ; true
 ),

telling(OldOutputStream),
tell(Path),
findall([Category,Type],
        messam(Version,Category,Type,Values),
        CatTypeBag),
remove_dups(CatTypeBag, CatTypeList),
samsort(CatTypeList,SortedCatTypeList),
findall(Type,
        (member([Category,Type],SortedCatTypeList),
         write('-----------------------------------------'),write('\n'),
         findall(Values,
                 (messam(Version,Category,Type,Values),
                  samsort(Values,SortedValues),
                  msmListing(Version,Category,Type,SortedValues)),
                _)
        ),_),
told,
tell(OldOutputStream)
.

msmListing(Version,classes,Type,Values):-
%write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),write('\n'),
 write('%%%%% '),
 write(Version),write('-'),
 write(classes), write('-'), write(Type), write('\n'),
 Values = [Value | _],
 getType(Value,Type),
 msmTypeFieldsListing(Type), write('\n'),
 msmValuesListing(structuredTypes,Values).

msmListing(Version,relations,Type,Values):-
%write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),write('\n'),
 write('%%%%% '),
 write(Version),write('-'),
 write(relations), write('-'), write(Type), write('\n'),
 msmValuesListing(relations,Values).

 msmTypeFieldsListing(Type):-
 allTypesDefinition(AllTypesDefinitionList),
 member([_,[Type,FieldsList]],AllTypesDefinitionList),
 msmFieldsListListing(FieldsList),
 findall(Y,
   (if(isSubType(Type,Y),
       (msmTypeFieldsListing(Y)
       ),
     fail)
   ),
   _L2).
 
msmValuesListing(_,[]).

msmValuesListing(structuredTypes,[Value | Queue]):-
 msmValueListing(Value),write('\n'),
 msmValuesListing(structuredTypes,Queue)
.

msmValuesListing(inputEvents,
                 [[AnInputInterfaceInstance,
                   AnInputEvent,
                   AnInputEventParametersList] 
                 | Queue]):-
 write('InterfaceIN instance: '),
 getType(AnInputInterfaceInstance,InterfaceType),write(InterfaceType),write(' - '),
 msmValuesListing(structuredTypes,[AnInputInterfaceInstance]),
 write('Input Event'), write(': '), write(AnInputEvent), write('\n'),
 write('Parameters:'),write('\n'),
 msmValuesListing(structuredTypes,AnInputEventParametersList),write('\n'),
 msmValuesListing(inputEvents,Queue).

 
msmValuesListing(relations,[[[_Role1,Value1],
                             [_Role2,Value2]] | Queue]):-
 msmValueListing(Value1),write('\n'),write('<--> '), msmValueListing(Value2), write('\n'),
 msmValuesListing(relations,Queue)
.

msmFieldsListListing([]).
msmFieldsListListing([Field | Queue]):-
 write(Field),write(' - '),
 msmFieldsListListing(Queue).
 
msmValueListing(Value):-
 getType(Value,Type),
 primitiveTypes(PT),
 enumerationTypes(ET),
 append(PT,ET,LeafTypes),
 (member([Type,_],LeafTypes)
 -> (Value = [Type,AValueToPrint],
     write(AValueToPrint),write('  -  '))
 ; (Value = [Type,FieldsValuesList,_],
    findall(FieldValue,
             (member([_FieldName,FieldValue],FieldsValuesList),
             msmValueListing(FieldValue)),
             _),
    findall(Y,
           ((isSubType(Type,Y),
               (generalize(Value,Y,YV),
                msmValueListing(YV)
               )
            -> true
            ; fail)
           ),
           _L2)
   )
 )
.

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Histories Listing Predicates  */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evolutionHistoriesListingRaw(TestCaseNumber):-
msrFilePath([evolutionHistoriesListingRaw,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
listing(evolution),
told,
tell(OldOutputStream).

evolutionHistoriesListing(TestCaseNumber):-
msrFilePath([evolutionHistoriesListing,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
findall([VersionSource,
         VersionTarget,
         EventName,
         InterfaceOUTInstance,
         EventsSentList,
         EventParametersList,
         Result],
        (evolution(   [  VersionSource,
                         VersionTarget,
                         [InterfaceOUTInstance,
                         EventName,
                         EventParametersList],
                         EventsSentList,
                         Result])),
        EvolutionsList),
samsort(EvolutionsList,SortedEvolutionsList),

findall([VersionSource,
         VersionTarget,
         EventName,
         InterfaceOUTInstance,
         EventsSentList,
         EventParametersList],
        (member([VersionSource,
                 VersionTarget,
                 EventName,
                 InterfaceOUTInstance,
                 EventsSentList,
                 EventParametersList,
                 Result],
                SortedEvolutionsList),
         getType(InterfaceOUTInstance,InterfaceOUTType),
         write(VersionSource),write(' ---> '),
         write(VersionTarget),write('\n'),
         write(InterfaceOUTType),write(' : '),
         write(EventName),write('\n'),
         write('InterfaceOUT instance: '),
         msmValuesListing(structuredTypes,[InterfaceOUTInstance]),
         write('Parameters:'),write('\n'),
         write('Result: '),write(Result),write('\n'),
         msmValuesListing(structuredTypes,EventParametersList),
         write('Sent Events:'),write('\n'),
         msmValuesListing(inputEvents,EventsSentList),write('\n'),
         write('-------------------------------------------'),
         write('\n')),
        _),
told,
tell(OldOutputStream).


/*********************************************************************/
/******** Generation of Test Instance Messir specifications **********/
/*********************************************************************/

testInstanceMsrListing(TestCaseNumber):-
msrFilePath([testInstanceMsrListing,TestCaseNumber],Path),
telling(OldOutputStream),
tell(Path),
findall([VersionSource,
         VersionTarget,
         EventName,
         InterfaceOUTInstance,
         EventsSentList,
         EventParametersList,
         Result],
        (evolution(   [  VersionSource,
                         VersionTarget,
                         [InterfaceOUTInstance,
                         EventName,
                         EventParametersList],
                         EventsSentList,
                         Result])),
        EvolutionsList),
samsort(EvolutionsList,SortedEvolutionsList),

findall([VersionSource,
         VersionTarget,
         EventName,
         InterfaceOUTInstance,
         EventsSentList,
         EventParametersList],
        (member([VersionSource,
                 VersionTarget,
                 EventName,
                 InterfaceOUTInstance,
                 EventsSentList,
                 EventParametersList,
                 Result],
                SortedEvolutionsList),
         getType(InterfaceOUTInstance,InterfaceOUTType),
         write(VersionSource),write(' ---> '),
         write(VersionTarget),write('\n'),
         write(InterfaceOUTType),write(' : '),
         write(EventName),write('\n'),
         write('InterfaceOUT instance: '),
         msmValuesListing(structuredTypes,[InterfaceOUTInstance]),
         write('Parameters:'),write('\n'),
         write('Result: '),write(Result),write('\n'),
         msmValuesListing(structuredTypes,EventParametersList),
         write('Sent Events:'),write('\n'),
         msmValuesListing(inputEvents,EventsSentList),write('\n'),
         write('-------------------------------------------'),
         write('\n')),
        _),
told,
tell(OldOutputStream).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Generic Listing Predicates  */ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header(Type):-
 write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),write('\n'),
 write('%%%%% '),write(Type),write(' %%%%%%'),write('\n'),
 write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),write('\n').

body(L):-
 samsort(L,SortedL),
 simpleListListing(SortedL).

footer:-
 write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), write('\n').

allTypesListing:-
header('All Types'),
allTypesDefinition(L),body(L),
footer.

msrprint(operationsWithInheritance,Title):-
 header(Title),
 findall([Z,X,Y],
         getOperationType(Z,X,Y),L),
 samsort(L,SL),simpleListListing(SL),
 footer.

msrprint(Predicate,Title):-
 Goal=..[Predicate,L],
 Goal,
 header(Title),
 body(L),
 footer.

simpleListListingWrite([]).
simpleListListingWrite([H|Q]):-write(H),write('\n'),simpleListListingWrite(Q).

simpleListListing(L):- 
  samsort(L,SL),
  simpleListListingWrite(SL).

sll(L):-simpleListListing(L).

%structuredValueListing(AValue):-
% true.
% 
%classInstanceListing(AValue):-
% structuredValueListing(AValue).
%
%dataTypeValueListing(AValue):-
% structuredValueListing(AValue).

%%%%%% Relations
 
msrprintRelations(Title):-
 header(Title),
 relationTypes(RTList),
 findall(REL,
         (member(REL,RTList),
          msrprintRelation(REL)),
         _),
 footer.
 
msrprintRelation([Category,Name,RelatedTypes,PartsList]):-
write(Category),write(' - '),write(Name),
 write(' - '),write(RelatedTypes),write('\n'),
findall(Part,
        (member(Part,PartsList),
         msmValuesListing(structuredTypes,[Part])),
        _),
 write('------------------------------------------------------'), 
 write('\n').
 
%%%%%% Textual Documentation
documentationTextListing(PathKey,CommentType):-
msrFilePath(PathKey,Path),
telling(OldOutputStream),
tell(Path),
findall(P,(commentHeader(CommentType,[_,_,_,_,P,_,_])),L),
samsort(L,SortedL),
findall(Q,(member(Q,SortedL),msrdoc(CommentType,Q)),_M),
told,
tell(OldOutputStream).

documentationTextListings(system):-
 documentationTextListing(systemTextDocumentationPath,systemPredicate)
 .

documentationTextListings(messim):-
 documentationTextListing(messimTextDocumentationPath,messimPredicate)
 .

