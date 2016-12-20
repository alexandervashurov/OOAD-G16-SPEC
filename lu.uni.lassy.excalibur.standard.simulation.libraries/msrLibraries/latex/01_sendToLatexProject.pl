send_to_latex:-
msrFilePath(latexMessimUnitTestResultsFailure,PathFailure),
msrFilePath(latexMessimUnitTestResultsSuccess,PathSuccess),
msrFilePath(messimUnitTestResultsSuccess,SuccessFile),
msrFilePath(messimUnitTestResultsFailure,FailureFile),
file_copy(SuccessFile,PathSuccess,write),
file_copy(FailureFile,PathFailure,write).

%***************************************

man2latex(systemPredicate):-
 findall(Predicate,
          (
                 commentHeader(systemPredicate,
                       [Author,
                        Date,
                        FileName,
                        Predicate,
                        PredicateManKey,
                        Arity,
                        Signature
                       ]),
                msrFilePath(projectBaseFolderPath,ProjectPath),
                atom_concat(ProjectPath,'/',ProjectPath2),
                atom_concat(ProjectPath2,FileName,PrologFilePath),
                msrFilePath(systemPredicatesLatexTables,LatexPath),
                atom_concat(LatexPath,FileName,LatexPath2),
                atom_concat(LatexPath2,'.tex',LatexFilePath),
                systemMan2latex(PredicateManKey,
                                PrologFilePath,
                                LatexFilePath)
          ),
        _PredicatesBag),
 true.
            
 systemMan2latex(
       PrologPredicateManKey,
       PrologPredicateFilePath,
       PrologPredicateLatexFilePath):-
  
  telling(OldOutputStream),
  open(PrologPredicateLatexFilePath,write,OutStream,[type(text)]),
  tell(OutStream),
  write('\\normalsize\n'),
  write('\\lstset{'),write('\n'),
  write('float,'),write('\n'),
  write('basicstyle=\\scriptsize,'),write('\n'),
  write('language=Prolog,'),write('\n'),
  write('breakatwhitespace=false,'),write('\n'),
  write('tabsize=2,'),write('\n'),
  write('breaklines=true,'),write('\n'),
  write('numbers=left,'),write('\n'),
  write('emptylines=1,'),write('\n'),
  write('numbersep=5pt,'),write('\n'),
  write('showspaces=false,'),write('\n'),
  write('keepspaces=true,'),write('\n'),
  write('showstringspaces=false,'),write('\n'),
  write('columns=flexible,'),write('\n'),
  write('showtabs=false'),write('\n'),
  write('}'), write('\n'),
  write('\\normalsize\n'),
  
commentHeader(systemPredicate,
       [Author,
        Date,
        FileName,
        Predicate,
        PrologPredicateManKey,
        Arity,
        Signature
       ]),
 
  generateLatexTableforPredicate(systemPredicate,PrologPredicateManKey),
  generateLatexTableforPredicateSubSectionFooter(PrologPredicateManKey),
  write('\\begin{lstlisting}\n'),
 
  file_read(PrologPredicateFilePath),

  write('\\end{lstlisting}\n'),
  generateLatexListingforPredicateSubSectionFooter(PrologPredicateManKey),
 told,
 tell(OldOutputStream).

%****************************************************
man2latex(messimPredicate):-

msrFilePath(messimPredicatesLatexTables,Path),
 telling(OldOutputStream),
 tell(Path),
 
  write('\\normalsize\n'),
  write('\\lstset{'),write('\n'),
  write('float,'),write('\n'),
  write('basicstyle=\\scriptsize,'),write('\n'),
  write('language=Prolog,'),write('\n'),
  write('breakatwhitespace=false,'),write('\n'),
  write('tabsize=2,'),write('\n'),
  write('breaklines=true,'),write('\n'),
  write('numbers=left,'),write('\n'),
  write('emptylines=1,'),write('\n'),
  write('numbersep=5pt,'),write('\n'),
  write('showspaces=false,'),write('\n'),
  write('keepspaces=true,'),write('\n'),
  write('showstringspaces=false,'),write('\n'),
  write('columns=flexible,'),write('\n'),
  write('showtabs=false'),write('\n'),
  write('}'), write('\n'),

 write('\\normalsize\n'),
 findall(Predicate,
         commentHeader(messimPredicate,
               [Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                Arity,
                Signature
               ]),
        PredicatesBag),
 remove_dups(PredicatesBag,PredicatesList),
 samsort(PredicatesList,SortedPredicatesList),

  findall([Predicate,PredicateManKey],
         commentHeader(messimPredicate,
               [Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                Arity,
                Signature
               ]),
        PredicatesKeysBag),
 remove_dups(PredicatesKeysBag,PredicatesKeysList),
 samsort(PredicatesKeysList,SortedPredicatesKeysList),
  
 findall(Predicate,
         (member(Predicate,SortedPredicatesList),
          generateLatexTableforPredicateSectionHeader(subsection,Predicate),
          findall(PredicateManKey,
                  (member([Predicate,PredicateManKey],
                          SortedPredicatesKeysList),
                   generateLatexTableforPredicate(messimPredicate,PredicateManKey),
                   generateLatexTableforPredicateSubSectionFooter(PredicateManKey)),
                  _L),
          generateLatexListingforPredicateSectionHeader(Predicate),
          write('\\begin{lstlisting}\n'),
          listing(Predicate),
          write('\\end{lstlisting}\n'),
          generateLatexListingforPredicateSubSectionFooter(Predicate)),
          _M),
 told,
 tell(OldOutputStream).

prolog2latex(systemPredicate).

prolog2latex(messimPredicate):-
 msrFilePath(messimPredicatesLatexListings,Path),
 telling(OldOutputStream),
 tell(Path),
  write('\\normalsize\n'),
  write('\\lstset{'),write('\n'),
  write('float,'),write('\n'),
  write('basicstyle=\\scriptsize,'),write('\n'),
  write('language=Prolog,'),write('\n'),
  write('breakatwhitespace=false,'),write('\n'),
  write('tabsize=2,'),write('\n'),
  write('breaklines=true,'),write('\n'),
  write('numbers=left,'),write('\n'),
  write('emptylines=1,'),write('\n'),
  write('numbersep=5pt,'),write('\n'),
  write('showspaces=false,'),write('\n'),
  write('keepspaces=true,'),write('\n'),
  write('showstringspaces=false,'),write('\n'),
  write('columns=flexible,'),write('\n'),
  write('showtabs=false'),write('\n'),
  write('}'), write('\n'),

 findall(Predicate,
         commentHeader(messimPredicate,
               [Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                Arity,
                Signature
               ]),
        PredicatesBag),
 remove_dups(PredicatesBag,PredicatesList),
 samsort(PredicatesList,SortedPredicatesList),

 findall(Predicate,
         (member(Predicate,SortedPredicatesList),
          generateLatexListingforPredicateSectionHeader(Predicate),
          write('\\begin{lstlisting}\n'),
          listing(Predicate),
          write('\\end{lstlisting}\n'),
          generateLatexListingforPredicateSubSectionFooter(Predicate)),
          _M),
 told,
 tell(OldOutputStream).


generateLatexTableforPredicate(CommentType,PredicateManKey):-
 findall([Number,Comments],
         commentData(CommentType,[PredicateManKey,'Parameter',Number,Comments]),
         ParametersList),
 samsort(ParametersList, SortedParametersList),
 findall([Number,Comments],
         commentData(CommentType,[PredicateManKey,'Thedescription',Number,Comments]),
         MainCommentsList),
 samsort(MainCommentsList, SortedMainCommentsList), 
 findall([Number,Comments],
         commentData(CommentType,[PredicateManKey,'Thecomment',Number,Comments]),
         DetailledCommentsList),
 samsort(DetailledCommentsList, SortedDetailledCommentsList),
 findall([Number,Comments],
         commentData(CommentType,[PredicateManKey,'Theexample',Number,Comments]),
         ExamplesList),
 samsort(ExamplesList, SortedExamplesList),

 generateLatexTableforPredicateSubSectionHeader(subsubsection,CommentType,PredicateManKey),
 
 write('\\addmulrow{Parameters}{1.}'),write('\n'),write('{'),
 (SortedParametersList = []
 -> (write('\\item N.A.'),write('\n'))
 ; findall([Number,Comments],
         (member([Number,Comments],SortedParametersList),
          commentData(CommentType,[PredicateManKey,'Parameter',Number,[ParameterName,CommentLines]]),
          write('\\item {\\scriptsize \\msrcode{'),
          addBreakableCharsLatexWrite(ParameterName,BreakableParameterName),
          write(BreakableParameterName),write('}} - '),
          writePrologCommentLines(CommentLines)
          ),
         _ParNumbersComments)),
 write('}'),write('\n'),

 write('\\addmulrow{Description}{1.}'),write('\n'),write('{'),
 (SortedMainCommentsList = []
 -> (write('\\item N.A.'),write('\n'))
 ; findall([Number,Comments],
         (member([Number,Comments],SortedMainCommentsList),
          commentData(CommentType,[PredicateManKey,'Thedescription',Number,CommentLines]),
          write('\\item '),writePrologCommentLines(CommentLines)
          ),
         _MainNumbersComments)),
 write('}'),write('\n'),

 write('\\addmulrow{Remark(s)}{1.}'),write('\n'),write('{'),
 (SortedDetailledCommentsList = []
 -> (write('\\item N.A.'),write('\n'))
 ; findall([Number,Comments],
         (member([Number,Comments],SortedDetailledCommentsList),
          commentData(CommentType,[PredicateManKey,'Thecomment',Number,CommentLines]),
          write('\\item '),writePrologCommentLines(CommentLines)
          ),
         _Comments)),
 write('}'),write('\n'),
 
 write('\\addmulrow{Example(s)}{}'),write('\n'),write('{'),
 (SortedExamplesList = []
 -> (write('\\item N.A.'),write('\n'))
 ; findall([Number,Comments],
         (member([Number,Comments],SortedExamplesList),
          commentData(CommentType,[PredicateManKey,'Theexample',Number,CommentLines]),
          %write('\\item '),
          writePrologCommentLinesWithLineBreaks(CommentLines)
          ),
         _Examples)),
 write('}'),write('\n')
.

writeMsrCode(Atom):-
  write('\\msrcode{'),protectedLatexWrite(Atom),write('}').
           

protectedLatexWrite(Atom):-
  protectUnderscoresForLatex(Atom,ProtectedAtom),
  write(ProtectedAtom)
   .

addBreakableCharsLatexWrite(Atom,BreakableAtom):-
  protectUnderscoresForLatex(Atom,ProtectedAtom),
  atom_concat('{\\scriptsize \\AddBreakableChars{',ProtectedAtom,Part1),
  atom_concat(Part1,'}}',BreakableAtom)
   .

writePrologCommentLines([]).
writePrologCommentLines(['']):-!.

writePrologCommentLines([Line]):-
           protectUnderscoresForLatex(Line,ProtectedLine),
           write(ProtectedLine),write(' ').

writePrologCommentLines([Line | RemainingLines]):-
           protectUnderscoresForLatex(Line,ProtectedLine),
           write(ProtectedLine),write(' '),
           write('\n'),
           writePrologCommentLines(RemainingLines).

writePrologCommentLinesWithLineBreaks([]).
writePrologCommentLinesWithLineBreaks(['']):-!.
writePrologCommentLinesWithLineBreaks([Line]):-
           protectUnderscoresForLatex(Line,ProtectedLine),
           write('\\item {\\scriptsize '),write(ProtectedLine),
           write('}').

writePrologCommentLinesWithLineBreaks([Line | RemainingLines]):-
           protectUnderscoresForLatex(Line,ProtectedLine),
           write('\\item {\\scriptsize '),write(ProtectedLine),
           write('}'),
           write('\n'),
           writePrologCommentLinesWithLineBreaks(RemainingLines).


/*
writePrologCommentLines(LineList):-
 findall(Line,
          (member(Line,LineList),
           protectUnderscoresForLatex(Line,ProtectedLine),
           write(ProtectedLine),write(' '),
           write('\n')),
          _Lines).

writePrologCommentLinesWithLineBreaks(LineList):-
 findall(Line,
          (member(Line,LineList),
           protectUnderscoresForLatex(Line,ProtectedLine),
           write('\\item {\\scriptsize '),write(ProtectedLine),
           write('}'),write('\n')),
          _Lines)
.
*/


generateLatexTableforPredicateSectionHeader(SectionLevel,Predicate):-
 addBreakableCharsLatexWrite(Predicate,BreakablePredicate),
 write('%-------------------------------------------------------'),write('\n'),
 write('\\'),write(SectionLevel),
 write('['),
 %protectedLatexWrite(Predicate),
 write(']'),
 write('{\\texorpdfstring{'),write(BreakablePredicate),write('}}'),
 write('\n'),
 write('\\label{PL-DOC-MESSIM-'),protectedLatexWrite(Predicate),write('}'),write('\n'),
 write('The following tables provide the descriptions for the predicate:'),
 write('\\\\'), 
 write('\\msrcode{'),
 write(BreakablePredicate),write('}'),
 write('\n').

generateLatexTableforPredicateSubSectionHeader(SectionLevel,CommentType,PredicateManKey):-
   commentHeader(CommentType,
        [       Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                Arity,
                Signature
        ]),
  
 addBreakableCharsLatexWrite(Predicate,BreakablePredicate),
 addBreakableCharsLatexWrite(PredicateManKey,BreakablePredicateManKey),
 addBreakableCharsLatexWrite(Signature,BreakableSignature),
 addBreakableCharsLatexWrite(FileName,BreakableFileName),

 write('\\'),write(SectionLevel),write('['),
 %write(BreakablePredicateManKey),
 write(']'),
 write('{\\texorpdfstring{'),write(BreakablePredicateManKey),write('}}'),
 write('\n'),
 write('\\label{PL-DOC-MESSIM-'),protectedLatexWrite(PredicateManKey),write('}'),write('\n'),
 write('The following table provides the description for the predicate:'),
 write('\\\\'),write('\n'),
 write('\\msrcode{'),
 write(BreakablePredicateManKey),write('}'),
 write('\n'),
 
 write('\\begin{operationmodel}'),write('\n'),
 write('\\addheading{Predicate\\\\Instance\\\\}{'),write(BreakablePredicateManKey),write('}'),write('\n'),
 write('\\addheading{Main Predicate}{'),write(BreakablePredicate),write('/'),write(Arity),write('}'),write('\n'),
 write('\\addheading{Signature}{'),write(BreakableSignature),write('}'),write('\n'),
 write('\\addheading{File name}{'),write(BreakableFileName),write('}'),write('\n')
 .

generateLatexTableforPredicateSubSectionFooter(PredicateManKey):-
 addBreakableCharsLatexWrite(PredicateManKey,BreakablePredicateManKey),
 write('\\end{operationmodel}'),write('\n'),
 write('The Prolog code listing for the predicate '),
 write('\\\\'),write('\\msrcode{'),
 write(BreakablePredicateManKey),write('}'),
 %writeMsrCode(BreakablePredicateManKey),
 write(' is provided below.'),write('\n'),
 write('\n')
 .
  
generateLatexListingforPredicateSectionHeader(Predicate):-
 addBreakableCharsLatexWrite(Predicate,BreakablePredicate),
 write('%-------------------------------------------------------'),write('\n'),
 write('\\subsubsection{'),protectedLatexWrite(Predicate),write(' predicate(s) listing}'),write('\n'),
 write('\\label{PL-COD-MESSIM-'),
 protectedLatexWrite(Predicate),write('}'),write('\n'),
 write('The following listing provides theProlog code for the '),
 write('\\\\'),
 write('\\msrcode{'),
 write(BreakablePredicate),write('}'),
 %writeMsrCode(BreakablePredicate), 
 write(' predicate.'),write('\n').

generateLatexListingforPredicateSubSectionFooter(_Predicate):-
 write('\n')
 .

protectQuotesInAtomForProlog(Atom,ProtectedAtom):-
 atom_codes(Atom,List),
 (member(34,List)
  -> recursiveSubstitution(34,List,[92,39],TempProtectedList)
 ; TempProtectedList = List),
 (member(39,List)
  -> recursiveSubstitution(39,TempProtectedList,[92,39],ProtectedList)
 ; ProtectedList = TempProtectedList),
 flatten_list(ProtectedList,FlattenProtectedList),
 atom_codes(ProtectedAtom,FlattenProtectedList).

protectUnderscoresForLatex(Atom,ProtectedAtom):-
 atom_codes(Atom,List),
 atom_codes('\\textunderscore ',UnderscoreList),
 (member(95,List)
  -> recursiveSubstitution(95,List,UnderscoreList,ProtectedList)
 ; ProtectedList = List),
 flatten_list(ProtectedList,FlattenProtectedList),
 atom_codes(ProtectedAtom,FlattenProtectedList).

recursiveSubstitution(Val,[],NewVal,[]).

recursiveSubstitution(Val,[Current | Queue],NewVal,[NewCurrent | NewQueue]):-
(Current = Val
-> NewCurrent = NewVal
; NewCurrent = Current),
 recursiveSubstitution(Val,Queue,NewVal,NewQueue).
 