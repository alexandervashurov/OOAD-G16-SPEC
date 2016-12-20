%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrFilePath/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Files */
:-dynamic msrFilePath/2.
:-retractall(msrFilePath(_,_)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runtime_entry(start):-
  prolog_flag(argv,PrgInputParameters),

  PrgInputParameters =
  [MessimReferenceProjectBaseFolderPath,
   MessimMakeFilePath,
   StandardLibrariesSimulationProjectPath,
   ProjectIdentifier,
   ProjectBaseFolderPath,
   LatexProjectFolder],

%-----------------------------------------------
%for console output
%-----------------------------------------------
  write('\n'),
  write('MessimReferenceProjectBaseFolderPath = '),write(MessimReferenceProjectBaseFolderPath),write('\n'),
  write('MessimMakeFilePath = '),write(MessimMakeFilePath),write('\n'),
  write('StandardLibrariesSimulationProjectPath = '),write(StandardLibrariesSimulationProjectPath),write('\n'),
  write('ProjectIdentifier = '),write(ProjectIdentifier),write('\n'),
  write('ProjectBaseFolderPath = '),write(ProjectBaseFolderPath),write('\n'),
  write('LatexProjectFolder = '),write(LatexProjectFolder),write('\n'),
  write('\n'),

%-----------------------------------------------
%for Excalibur Standard Libraries Simulation Project
%-----------------------------------------------
   assert(msrFilePath(standardLibrariesSimulationProjectPath,
                     StandardLibrariesSimulationProjectPath)),

%-----------------------------------------------
%for Messim reference Project
%-----------------------------------------------
  assert(msrFilePath(messimReferenceProjectBaseFolderPath,
                     MessimReferenceProjectBaseFolderPath)),
  assert(msrFilePath(messimMakeFilePath,
                     MessimMakeFilePath)),
%-----------------------------------------------
%for Project Base Directories
%-----------------------------------------------
  assert(msrFilePath(projectIdentifier,
                     ProjectIdentifier)),
  assert(msrFilePath(projectBaseFolderPath,
                     ProjectBaseFolderPath)),
  assert(msrFilePath(latexProjectFolder,
                     LatexProjectFolder)),

  msrFilePath(messimMakeFilePath, MessimMakeFilePath),
   [MessimMakeFilePath],
      do(doc),
  write('\n')

.
