%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrFilePath/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- write('\n'),write('Make - simulation reference !'),write('\n').

%:- set_prolog_flag(profiling, off).
%:- set_prolog_flag(source_info, off).

:- use_module(library(system)).
:- use_module(library(process)).
:- use_module(library(file_systems)).
:- use_module(library(lists)).
:- use_module(library(bags)).
:- use_module(library(sets)).
:- use_module(library(samsort)).
:- use_module(library(random)).
:- use_module(library(clpr)).
:- use_module(library(clpfd)).
:- use_module(library(between)).

/* ---------------------------------- */
:-['../Make/corePrologPredicates.pl'].
:-['../Make/filesPath.pl'].
:-['../Make/loadLibrary.pl'].

:- ensure_loaded('../Make/corePrologPredicates.pl').
:- ensure_loaded('../Make/filesPath.pl').
:- ensure_loaded('../Make/loadLibrary.pl').

/* ---------------------------------- */
:- loadProlog(libraries,kernel).
:- loadProlog(libraries,bundled).
:- loadProlog(libraries,various).
:- loadProlog(libraries,latex).

/* ---------------------------------- */


:- loadProjectSourceFiles.

:- initializeGenericAllOperations.
:- inheritedBehaviorsInitialization.
/* ---------------------------------- */
:- loadTests(messim).
%/* ---------------------------------- */
%:- prepareForSimulation.
%:- send_to_latex.
%/* ---------------------------------- */

purge(DirectoryPath):-
   (directory_exists(DirectoryPath)
    -> (delete_directory(DirectoryPath,[if_nonempty(delete)]),
        make_directory(DirectoryPath)
       )
   ; make_directory(DirectoryPath)
   )
   .

purgeout:-
  msrFilePath(projectBaseFolderPath,ProjectPath),
   T = '/out/tests',
   atom_concat(ProjectPath,T,OutTestDirectoryPath),
   purge(OutTestDirectoryPath),
   
   S = '/out/system',
   atom_concat(ProjectPath,S,SystemTestDirectoryPath),
   purge(SystemTestDirectoryPath)
   .

:-purgeout.

do(su) :- 
  do(all),
  do(messimtests),
  do(messimdoc)
.

do(sim) :- do(tests).

do([sim,TestCaseNumber]) :- do([tests,TestCaseNumber]).

do(all):- 
  do(tests),
  do(doc).

do(tests) :- 
  makeTests([system,sim],_SystemSimResults)
% ,makeTests([system,integration],_),
%  makeTests([system,unit],_)
.

do([tests,TestCaseNumber]) :- 
  makeTests([system,sim,TestCaseNumber],_SystemSimResults)
% ,makeTests([system,integration],_),
%  makeTests([system,unit],_)
.

do(messimtests):-
  makeTests([messimMetaModel,unit],_),
  makeTests([messimSimulator,unit],_)
.

do(doc):-
  loadSystemDocumentation,
  outputListings(system).

do(messimdoc):-
  loadMessimDocumentation,
  outputListings(messim)
.
/* ---------------------------------- */

