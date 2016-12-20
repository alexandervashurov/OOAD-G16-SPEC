%-----------------------------------------------
getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]):-
msrFilePath(projectBaseFolderPath,ProjectPath),
msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
atomic_list_concat([ProjectPath,'/out/tests/',
                    FormattedTestCaseNumber,'/'],
                   TestCaseFolder)
.

getTestOutputFilePath([Level,Category,TestCaseNumber,TestResult,FilePath]):-
atomic_list_concat(TestResult,TestResultKey),
msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
atomic_list_concat(['case-',FormattedTestCaseNumber,'-',
                    Level,'-',
                    Category,'-',
                    TestResultKey],
                   FileKey),

getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),

atomic_list_concat([TestCaseFolder,'/',
                    FileKey,
                    '.txt'
                   ],
                   FilePath).
%-----------------------------------------------
writeTestFied([]):-write('\n').
writeTestFied([ Head | Queue]):-
write('%****** '),write(Head),write('\n'),
writeTestFied(Queue).
%-----------------------------------------------
writeTests(_Level,_Category,[]).
writeTests(Level,Category,[TestOutput | Queue]):-
  writeTest(TestOutput),
  writeTests(Level,Category,Queue).
%-----------------------------------------------
 writeTestCases(Level,
                Category,
                SortedTestCasesResultsOutputsList):-
 findall(CaseNumber,
         (member([CaseNumber,CaseNumberResults],
                 SortedTestCasesResultsOutputsList),
          writeTests(Level,Category,CaseNumberResults)
         ),
         List)
 .
%-----------------------------------------------
writeTest([[Level,Category,CaseNumber,StepNumber],
           [[target,Target],
            [context,Context],
            [inputParameters,InputParameters],
            [outputParameters,OutputParameters],
            [comments,Comments],
            TestResult]
          ]):-
getTestOutputFilePath([Level,Category,CaseNumber,TestResult,FilePath]),
( \+(file_exists(FilePath))
  -> open(FilePath,write,Stream,[type(text)])
  ;  open(FilePath,append,Stream,[type(text)])
),
tell(Stream),
write('%******* Test *******'),write('\n'),
datime(R),R = datime(Year,Month,Day,Hours,Minutes,Seconds),
atomic_list_concat([Year,'-',
                    Month,'-',
                    Day,'-',
                    Hours,'-',
                    Minutes,'-',
                    Seconds
                   ],
                   TimeStamp),
write('%******* Time Stamp - '),write(TimeStamp),write('\n'),
write('%*** Target//Case//Step: '),
        write(Target),write(' - '),
        write(CaseNumber),write(' - '),
        write(StepNumber),write(' - '),
        write('\n'),
write('%*** Description: '),write(Comments),write('\n'),
write('%*** Context: '),write('\n'),
writeTestFied(Context),
write('%*** Input Parameters: '),write('\n'),
writeTestFied(InputParameters),
write('%*** Output Parameters: '),write('\n'),
writeTestFied(OutputParameters),
write('%*** Result: '),write(TestResult),write('\n'),
write('%************************'),write('\n'),
told,tell(user).
%-----------------------------------------------


%%% XXXX

msrTestAddStep([Level,Category,CaseNumber,StepNumber]):-
  testCases(CurrentTestsList),
  append(CurrentTestsList,
         [[Level,Category,CaseNumber,StepNumber]],
         NewTestsList),
  retractall(testCases(_)),
  assert(testCases(NewTestsList))
  .

msrTestsStepsList([Level,Category,CaseNumber],StepsNumberList):-
 testCases(CurrentTestsList),
 findall(StepNumber,
         member([Level,Category,CaseNumber,StepNumber],
                 CurrentTestsList),
         DupsStepsNumberList),
 remove_dups(DupsStepsNumberList,UnsortedStepsNumberList),
 samsort(UnsortedStepsNumberList,StepsNumberList)
 .
          
msrTestsCasesNumberList([Level,Category],CasesNumberList):-
 testCases(CurrentTestsList),
 findall(CaseNumber,
         member([Level,Category,CaseNumber,_StepNumber],
                 CurrentTestsList),
         DupsCasesNumberList),
 remove_dups(DupsCasesNumberList,UnsortedCasesNumberList),
 samsort(UnsortedCasesNumberList,CasesNumberList).

%makeTestsOriginal([Level,Category],SortedTestsOutputsList):-
% findall([[Level,Category,CaseNumber,StepNumber] , StructuredResult],
%         msrTest([[Level,Category,CaseNumber,StepNumber] , StructuredResult]),
%         TestsOutputsList),
% samsort(TestsOutputsList,SortedTestsOutputsList),
% writeTests(Level,Category,SortedTestsOutputsList)
% .

makeTests([Level,Category],SortedTestCasesResultsOutputsList):-
 
 msrTestsCasesNumberList([Level,Category],CasesNumberList),

 findall([CaseNumber,SortedTestCaseOutputsList],
         (member(CaseNumber,CasesNumberList),
          makeTests([Level,Category,CaseNumber],SortedTestCaseOutputsList)
         ),
         SortedTestCasesResultsOutputsList),
 writeTestCases(Level,Category,SortedTestCasesResultsOutputsList)
 .

makeTests([Level,Category,CaseNumber],SortedTestCaseOutputsList):-
  write('\n'),
  atomic_list_concat([Level,'-',Category,'-',CaseNumber,'-'],Header),
  write('**************** Doing Test Case: '),
  write(Header),write('****************'),write('\n'),
 
  getTestCaseOutputFolderPath([CaseNumber,TestCaseFolder]),
  purge(TestCaseFolder),
  messamReset,
  
  msrTestsStepsList([Level,Category,CaseNumber],StepsNumberList),
  findall([[Level,Category,CaseNumber,StepNumber] , StructuredResult],
          (member(StepNumber,StepsNumberList),
           msrTest([[Level,Category,CaseNumber,StepNumber] , StructuredResult])
          ),
          UnsortedTestCaseOutputsList),
  samsort(UnsortedTestCaseOutputsList,SortedTestCaseOutputsList),
  writeTests(Level,Category,SortedTestCaseOutputsList),
  messamListing(CaseNumber), 
  messamListingRaw(CaseNumber), 
  messirListing, 
  evolutionHistoriesListing(CaseNumber),
  evolutionHistoriesListingRaw(CaseNumber),
  forExcaliburTestModule([CaseNumber,SortedTestCaseOutputsList]),!
  .

forExcaliburTestModule([CaseNumber,SortedTestsOutputsList]):-
 findall([CaseNumber,StepNumber,TestResult],
         member([[Level,Category,CaseNumber,StepNumber] ,
                 [[target,Target],
                  [context,Context],
                  [inputParameters,InputParameters],
                  [outputParameters,OutputParameters],
                  [comments,Comments],
                  TestResult]
                ],
                SortedTestsOutputsList),
         FlatResultsList),
 samsort(FlatResultsList,SortedFlatResultsList),
 findall(N,
         member([N,_,_],SortedFlatResultsList),
         TestsNumbers),
 remove_dups(TestsNumbers,TestsNumbersSet),
 findall([N,L],
         (member(N,TestsNumbersSet),
          findall([StepNumber,StepResult],
                  member([N,StepNumber,StepResult],SortedFlatResultsList),
                  L)
         ),
          ResultsList),

msrFilePath([makeSystemTestsPath,CaseNumber],Path),
telling(OldOutputStream),
tell(Path),
write(ResultsList),
write('\n'),
write('------------------------------------------------------'),write('\n'),
write(SortedTestsOutputsList),
write('\n'),
write('------------------------------------------------------'),write('\n'),
told,
tell(OldOutputStream)
.







