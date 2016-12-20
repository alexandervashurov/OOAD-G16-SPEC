
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading All Operations Prolog files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getCurrentLevelPrologFiles(Directory,FilesSpecList):-
 file_members_of_directory(Directory,'*.pl',PlFiles),
 file_members_of_directory(Directory,'*.pro',ProFiles),
 append(PlFiles,ProFiles,AllPrologFiles),
 findall(Path,
         member(_FileName-Path,AllPrologFiles),
         FilesSpecList).

genericPrologFilesLoader(ASourceDirPath):-
 getPrologFiles([ASourceDirPath],FilesList),
 findall(File,(member(File,FilesList),[File]),_).

getPrologFiles([],[]).
getPrologFiles([DirPath | DirPathQueue],FilesList):-
directory_members_of_directory(DirPath,DirList),
findall(InnerDirPath,(member(Name-InnerDirPath,DirList),\+(Name='Make')),DirPathList),
getCurrentLevelPrologFiles(DirPath,CurrentLevelFilesList),
getPrologFiles(DirPathList,DeeperLevelFilesList),
getPrologFiles(DirPathQueue,RemainingDirFilesList),
append(CurrentLevelFilesList,DeeperLevelFilesList,IntermediateFilesList),
append(IntermediateFilesList,RemainingDirFilesList,FilesList).

deleteFilesInDirectory(DirectoryPath):-
findall(FullName,
        file_member_of_directory(DirectoryPath, '*.*', _Name, FullName),
        FilesList),
 findall(File,(member(File,FilesList),
               delete_file(File)),_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting All files by extension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getTXTFiles(Directory,FilesSpecList):-
 file_members_of_directory(Directory,'*.txt',TXTFiles),
 findall(Path,
         member(_FileName-Path,TXTFiles),
         FilesSpecList).

getMSDFiles(Directory,FilesSpecList):-
 file_members_of_directory(Directory,'*.msd',MSDFiles),
 findall(Path,
         member(_FileName-Path,MSDFiles),
         FilesSpecList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading Messir Project Source Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadMessirProjectSource(ProjectPath):-
  SRCGEN = '/src-gen',
  atom_concat(ProjectPath,
              SRCGEN,
              SourceGenPath),
  genericPrologFilesLoader(SourceGenPath),
  SRC = '/src',
  atom_concat(ProjectPath,
             SRC,
             SourcePath),
  genericPrologFilesLoader(SourcePath)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading Main Project Specific Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadProjectSourceFiles:-
  msrFilePath(projectBaseFolderPath,ProjectPath),
  loadMessirProjectSource(ProjectPath).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading Libraries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kernel Libraries
%--------------------------------------------------------------
loadProlog(libraries,kernel):-
 msrFilePath(kernelLibrariesPath,
             KernelLibrariesPath),
 genericPrologFilesLoader(KernelLibrariesPath).

% Bundled Libraries
%--------------------------------------------------------------
loadProlog(libraries,bundled):-
  msrFilePath(standardLibrariesSimulationProjectPath,
             StandardLibrariesSimulationProjectPath),
  loadMessirProjectSource(StandardLibrariesSimulationProjectPath).

% Various Libraries
%--------------------------------------------------------------
loadProlog(libraries,various):-
  msrFilePath(messimReferenceProjectBaseFolderPath,
              ProjectPath),
  Q = '/msrLibraries/various',
  atom_concat(ProjectPath,Q,Path),
  genericPrologFilesLoader(Path).

% Tests 
%--------------------------------------------------------------
loadTests(messim):-
  msrFilePath(messimTestsPath,Path),
  genericPrologFilesLoader(Path).

%--------------------------------------------------------------
% Latex Libraries
%--------------------------------------------------------------
loadProlog(libraries,latex):-
 msrFilePath(messimReferenceProjectBaseFolderPath,ProjectPath),
 Q = '/msrLibraries/latex',
 atom_concat(ProjectPath,Q,Path),
 genericPrologFilesLoader(Path).


% Documentation
%--------------------------------------------------------------
 writeManDataHeader(FileOUT):- 
open(FileOUT,write,OutStream,[type(text)]),
 tell(OutStream),
 write(':- multifile mandata/1.'),write('\n'),
 close(OutStream),
 told,
 tell(user)
.

loadMSDFiles(CommentType,FolderPath,FileOUT):-
 getMSDFiles(FolderPath,FilesList),
 open(FileOUT,append,OutStream,[type(text)]),
 tell(OutStream),
 findall(File,(member(File,FilesList),readcmt(CommentType,File)),_),
 close(OutStream),
 told,
 tell(user)
.

loadMessimDocumentation:-
msrFilePath(messimTextDocumentationPathIN,FolderPath),
 msrFilePath(messimTextDocumentationPathOUT,FileOUT),
 writeManDataHeader(FileOUT),
 loadMSDFiles(messimPredicate,FolderPath,FileOUT),
 [FileOUT],
 findall(_,mandata(messimPredicate),_),
 man2latex(messimPredicate),
 prolog2latex(messimPredicate).

loadSystemDocumentation:-
 msrFilePath(systemTextDocumentationPathIN,FolderPath),
 msrFilePath(systemTextDocumentationPathOUT,FileOUT),
  writeManDataHeader(FileOUT),
 loadMSDFiles(systemPredicate,FolderPath,FileOUT),
 msrFilePath(systemTextDocumentationPathOUT,Path),
 [Path],
 findall(_,mandata(systemPredicate),_),
 man2latex(systemPredicate).



