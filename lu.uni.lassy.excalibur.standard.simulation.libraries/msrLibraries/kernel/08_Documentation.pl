
msrWriteKeysList([],_N):- write('\n').
msrWriteKeysList([H|Q],N):-
 N = 1
 ->  (write('\n'),msrWriteKeysList([H|Q],0))
 ; (P is N+1,
    write('  -  '),write(H),
    msrWriteKeysList(Q,P)
    ).

man(CommentType,Key):-
  (Key = ''
  -> findall(X,commentHeader(CommentType,[_,_,_,_,X,_,_]),L)
  ; (msrKeysList(CommentType,Key,CompleteList),
     remove_dups(CompleteList, L))),
 (length(L,1)
 -> (L = [TheKey],msrdoc(CommentType,TheKey))
 ; (samsort(L,SortedL),
    msrWriteKeysList(SortedL,0),
    write('Enter a unique substring followed by dot and then press enter (\'quit.\' to quit):'),
    write('\n'),read(TheKey),
    (TheKey='quit'
    -> true
    ; (member(TheKey,L)
       -> msrdoc(CommentType,TheKey)
       ; man(CommentType,TheKey)))
   )
 ).
       
msrKeysList(CommentType,SubKey,L):-
findall(Key,commentHeader(CommentType,[_,_,_,_,Key,_,_]),KeysList),
atom_codes(SubKey,List),
findall(X,(member(X,KeysList),
            atom_codes(X,SuperList),
            sublist(SuperList,List,N,P,Q)),
            L).
                              
          

msrdoc(CommentType,PredicateManKey):-
commentHeader(CommentType,
        [       Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                Arity,
                Signature
        ])
-> 
(
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
 write('------------------------------------------'), write('\n'),
 write(Author),write(' - '),write(Date),write(' - '),write(FileName),write('\n'),
 write(PredicateManKey),write(' - '),write(Predicate),write(' / '),write(Arity),write('\n'),
 write(Signature),write('\n'),
 write('------------------------------------------'), write('\n'),
 write('Parameter(s):'),write('\n'),
 displayParameters(SortedParametersList),
 write('------------------------------------------'), write('\n'),
 write('Main Goal(s):'),write('\n'),
 displayComments(SortedMainCommentsList),
 write('------------------------------------------'), write('\n'),
 write('Remark(s):'),write('\n'),
 displayComments(SortedDetailledCommentsList),
 write('------------------------------------------'), write('\n'),
 write('Example(s):'),write('\n'),
 displayComments(SortedExamplesList)
)
; (write('Unknown Predicate !'),write('\n'))
.


displayParameters([]).
displayParameters([[_Number,[Parameter,CommentsList]] | Queue]):-
 write(Parameter),write(' - '),
 simpleListListing(CommentsList),
 displayParameters(Queue).

displayComments([]).
displayComments([[Number,LinesList] | Queue]):-
 write(Number),write(' - '),
 simpleListListing(LinesList),
 displayComments(Queue).
 

createComment(CommentType,
[       Author,
        Date,
        FileName,
        Predicate,
        PredicateManKey,
        PredicateDimension,
        PredicateMainSignature
]):-
        assert(commentHeader(CommentType,
        [       Author,
                Date,
                FileName,
                Predicate,
                PredicateManKey,
                PredicateDimension,
                PredicateMainSignature
        ])).

addCommentRecord(CommentType,[APredicate,AField,AComment]):-
 findall(N,commentData(CommentType,[APredicate,AField,N,_Comment]),IntList),
 (IntList = [] 
 -> Max is 1
 ; (maximum(CMax,IntList),Max is CMax+1)),
assert(commentData(CommentType,[APredicate,AField,Max,AComment])).


readcmt(CommentType,FileIN):- 
  \+(file_exists(FileIN)) 
  ->  write('% Empty File')
  ; (   open(FileIN,read,InStream,[type(text)]),
        see(InStream),        /* open this file */ 
               %read_line(InStream,Data),       /* read from File */ 
               write('mandata('),
               write(CommentType),
               write('):-\n'),
               processcmt(CommentType,InStream,'@mankey',1,_),
               processcmt(CommentType,InStream,'@arity',1,ArityAtom),
               processcmt(CommentType,InStream,'@author',1,_),
               processcmt(CommentType,InStream,'@date',1,_),
               processcmt(CommentType,InStream,'@file',1,_),
               processcmt(CommentType,InStream,'@predicate',1,_),
               processcmt(CommentType,InStream,'@mainform',1,_),
               write('createComment('),
               write(CommentType),
               write(',[Theauthor,Thedate,Thefile,Thepredicate,Themankey,Thearity,Themainform]),\n'),
               atom_codes(ArityAtom,Codes),number_codes(Arity,Codes),
               (Arity>0
               -> repeat,
                   (processcmt(CommentType,InStream,'@parameter',3,_)
                   -> fail
                   ; true)
               ; true),
               processcmt(CommentType,InStream,'@description',2,_),
               processcmt(CommentType,InStream,'@comment',2,_),
               processcmt(CommentType,InStream,'@example',2,_),
               write('\ntrue.\n'),
               close(InStream),
               seen,             /* close File */ 
               see(user)          /*  previous read source */ 
),!.

processcmt(_CommentType,InStream,Field,1,FieldValue):-
 atom_codes(Field,Data),
 read_line(InStream,Data),
 read_line(InStream,DataNext),
 atom_codes(FieldValue,DataNext),
 removeAt(Field,FieldWithoutAt),
 protectQuotesInAtomForProlog(FieldValue,CleanedFieldValue),
 write('The'),write(FieldWithoutAt),write(' = \''),write(CleanedFieldValue),write('\',\n').


processcmt(CommentType,InStream,Field,2,FieldWithoutAt):-
          atom_codes(Field,Data3),
          read_line(InStream,Data3),
          removeAt(Field,FieldWithoutAt),
          write('addCommentRecord('),
          write(CommentType),
          write(',[Themankey,\'The'),
          write(FieldWithoutAt),
          write('\',\n['),
          repeat,
           peek_char(InStream,Data4),
           (Data4 = @
           -> true
           ;(
           read_line(InStream,DataNext),
           (DataNext = end_of_file
            -> true
            ;(
               atom_codes(NextLine,DataNext),
               protectQuotesInAtomForProlog(NextLine,CleanedNextLine),
               write('\''),write(CleanedNextLine),write('\',\n'),
             fail)))),
           
           write('\'\']]),\n').

processcmt(CommentType,InStream,Field,3,ParamName):-
          atom_codes(Field,Data3),
          read_line(InStream,Data3),
          read_line(InStream,ParamNameCodes),
          atom_codes(ParamName,ParamNameCodes),
          protectQuotesInAtomForProlog(ParamName,CleanedParamName),
          write('addCommentRecord('),
          write(CommentType),
          write(',[Themankey,\'Parameter\',\n[\''),
          write(CleanedParamName),write('\',\n['),
          repeat,
           peek_char(InStream,Data4),
           (Data4 = @
           -> true
           ;(
           read_line(InStream,DataNext),
           atom_codes(NextLine,DataNext),
           protectQuotesInAtomForProlog(NextLine,CleanedNextLine),
           write('\''),write(CleanedNextLine),write('\',\n'),
           fail)),
           write('\'\']]]),\n')
.

removeAt(Atom,AtomWithoutAt):-
          atom_codes(Atom,AtomCodes),
          delete(AtomCodes,64, AtomCodesWithoutAt),
          atom_codes(AtomWithoutAt,AtomCodesWithoutAt).
