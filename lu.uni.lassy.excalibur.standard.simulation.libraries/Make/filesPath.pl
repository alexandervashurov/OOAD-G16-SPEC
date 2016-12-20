%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrFilePath/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------
% for the temporary file for runtime predicates loading
%-----------------------------------------------

msrFilePath(
     tmpFilePath,
     Path):-
 msrFilePath(projectBaseFolderPath,ProjectPath),
 Part1='tmp',
 Part2 = '.pl',
 atomic_list_concat([ProjectPath,'/runtime_files/',Part1,Part2],Path),
 ( file_exists(Path) 
   -> delete_file(Path)
   ; true
 ).

msrFilePath(
     tmp2FilePath,
     Path):-
 msrFilePath(projectBaseFolderPath,ProjectPath),
 Q = '/runtime_files/tmp2FilePath.pl',
 atom_concat(ProjectPath,Q,Path),
 ( file_exists(Path) 
   -> delete_file(Path)
   ; true
 ).

%-----------------------------------------------
% for the Libraries Directories
%-----------------------------------------------
msrFilePath(
     kernelLibrariesPath,
     Path):-
 msrFilePath(messimReferenceProjectBaseFolderPath,ProjectPath),
 Q = '/msrLibraries/kernel',
 atom_concat(ProjectPath,Q,Path).

msrFilePath(
     variousLibrariesPath,
     Path):-
 msrFilePath(messimReferenceProjectBaseFolderPath,ProjectPath),
 Q = '/msrLibraries/various',
 atom_concat(ProjectPath,Q,Path).

 msrFilePath(latexLibrariesPath,
             Path):-
   msrFilePath(messimReferenceProjectBaseFolderPath,ProjectPath),
 Q = '/msrLibraries/latex',
 atom_concat(ProjectPath,Q,Path).

%-----------------------------------------------
% for the the Loading Predicates
%-----------------------------------------------
msrFilePath(
     loadLibrary,
     Path):-
 msrFilePath(messimReferenceProjectBaseFolderPath,KLPath),
 Q = '/Make/loadLibrary.pl',
 atom_concat(KLPath,Q,Path).

%-----------------------------------------------
%for Listings
%-----------------------------------------------

msrFilePath(allPredicatesListing,Path):-
        msrFilePath(projectBaseFolderPath,ProjectPath),
        Q = '/out/system/allPredicatesListing.txt',
        atom_concat(ProjectPath,Q,Path).

msrFilePath(messirSystemListing,Path):-
        msrFilePath(projectBaseFolderPath,ProjectPath),
        Q = '/out/system/messirSystemListing.txt',
        atom_concat(ProjectPath,Q,Path).

msrFilePath([messamListing,TestCaseNumber],Path):-
       getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([TestCaseFolder,'case-',
                          FormattedTestCaseNumber,'-',
                          'messamListing.txt'],
                          Path)
.

msrFilePath([messamListingRaw,TestCaseNumber],Path):-
       getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([TestCaseFolder,'case-',
                          FormattedTestCaseNumber,'-',
                          'messamListingRaw.txt'],
                          Path)
.

msrFilePath([evolutionHistoriesListing,TestCaseNumber],Path):-
       getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([TestCaseFolder,'case-',
                          FormattedTestCaseNumber,'-',
                          'evolutionHistoriesListing.txt'],
                          Path)
.

msrFilePath([evolutionHistoriesListingRaw,TestCaseNumber],Path):-
       getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([TestCaseFolder,'case-',
                          FormattedTestCaseNumber,'-',
                          'evolutionHistoriesListingRaw.txt'],
                          Path)
.

%-----------------------------------------------
%for tests
%-----------------------------------------------
msrFilePath([makeSystemTestsPath,TestCaseNumber],Path):-
       getTestCaseOutputFolderPath([TestCaseNumber,TestCaseFolder]),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([TestCaseFolder,'case-',
                          FormattedTestCaseNumber,'-',
                          'makeSystemTests.txt'],
                          Path)
.

msrFilePath([makeSystemUnitTestsPath,TestCaseNumber],Path):-
       msrFilePath(projectBaseFolderPath,ProjectPath),
       msrFormatInteger(TestCaseNumber,FormattedTestCaseNumber),
       atomic_list_concat([ProjectPath,'/out/tests/','case-',
                          FormattedTestCaseNumber,'-',
                          'makeSystemUnitTests.txt'],
                          Path)
.

%-----------------------------------------------
%for Latex
%-----------------------------------------------

msrFilePath(latexProjectPrologOutFolder,Path):-
 msrFilePath(latexProjectFolder,BasePath),
 Q = '/src-gen',
 atom_concat(BasePath,Q,Path).

msrFilePath(latexMessimUnitTestResultsFailure,Path):-
        msrFilePath(latexProjectPrologOutFolder,ProjectPath),
        Q = '/messimUnitTestResultsFailure.txt',
        atom_concat(ProjectPath,Q,Path).

msrFilePath(latexMessimUnitTestResultsSuccess,Path):-
        msrFilePath(latexProjectPrologOutFolder,ProjectPath),
        Q = '/messimUnitTestResultsSuccess.txt',
        atom_concat(ProjectPath,Q,Path).

msrFilePath(messimPredicatesLatexTables,Path):-
   msrFilePath(latexProjectPrologOutFolder,BasePath),
   Q = '/messim-documentation/allMessimPredicateTables.tex',
   atom_concat(BasePath,Q,Path).

msrFilePath(messimPredicatesLatexListings,Path):-
   msrFilePath(latexProjectPrologOutFolder,BasePath),
   Q = '/messim-documentation/allMessimPredicateListings.tex',
   atom_concat(BasePath,Q,Path).

msrFilePath(systemPredicatesLatexTables,Path):-
   msrFilePath(latexProjectPrologOutFolder,ProjectPath),
   Q = '/system-documentation/src-templates/',
   atom_concat(ProjectPath,Q,Path).

%-----------------------------------------------
%for Messim Tests
%-----------------------------------------------
msrFilePath(messimTestsPath,Path):-
        msrFilePath(messimReferenceProjectBaseFolderPath,ProjectPath),
        Q = '/Tests/Messim',
        atom_concat(ProjectPath,Q,Path).

%-----------------------------------------------
%for Documentation
%-----------------------------------------------

msrFilePath(documentationPath,Path):-
        msrFilePath(projectBaseFolderPath,BasePath),
        Q = '/Documentation',
        atom_concat(BasePath,Q,Path).

msrFilePath(messimTextDocumentationPathIN,Path):-
        msrFilePath(messimReferenceProjectBaseFolderPath,BasePath),
        Q = '/Documentation/messim',
        atom_concat(BasePath,Q,Path).

msrFilePath(messimTextDocumentationPathOUT,Path):-
        msrFilePath(messimReferenceProjectBaseFolderPath,BasePath),
        Q = '/Documentation/messimDocumentation.pl',
        atom_concat(BasePath,Q,Path).

msrFilePath(messimTextDocumentationPath,Path):-
        msrFilePath(messimReferenceProjectBaseFolderPath,BasePath),
        Q = '/Documentation/manMessim.txt',
        atom_concat(BasePath,Q,Path).

msrFilePath(systemTextDocumentationPathIN,Path):-
        msrFilePath(projectBaseFolderPath,BasePath),
        Q = '/Documentation/system',
        atom_concat(BasePath,Q,Path).

msrFilePath(systemTextDocumentationPathOUT,Path):-
        msrFilePath(projectBaseFolderPath,BasePath),
        Q = '/Documentation/systemDocumentation.pl',
        atom_concat(BasePath,Q,Path).

msrFilePath(systemTextDocumentationPath,Path):-
        msrFilePath(projectBaseFolderPath,BasePath),
        Q = '/Documentation/manSystem.txt',
        atom_concat(BasePath,Q,Path).

