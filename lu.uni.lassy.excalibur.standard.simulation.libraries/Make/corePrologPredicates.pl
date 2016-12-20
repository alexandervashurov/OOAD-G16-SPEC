%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- dynamic testNG/1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-assert(testNG(false)).

%-----------------------------------------------
msrmember(X,[X]).
msrmember(X,[X|_]).
msrmember(X,[_|L]):-msrmember(X,L).
%-----------------------------------------------

     flatten([], List0,  List) :- !,
        List0 = List.
     flatten([H|T], List0, List) :- !,
         flatten(H, List0, List1),
         flatten(T, List1, List).
     flatten(Other, [Other|List], List). 

flatten_list(List,Flat):-
 flatten(List,Flat,[]).

flatten_list2([], []) :- !.

flatten_list2([Content], [Content]) :- 
 atomic(Content),!.

flatten_list2([Content], FlatContent) :- 
 flatten_list2(Content,FlatContent),!.

flatten_list2(Atom, [Atom]) :- 
      atomic(Atom),\+(Atom=[]),!.

flatten_list2([H|T], List) :- !,
 flatten_list2(H, List0),
 flatten_list2(T, List1),
 append(List0,List1,List).
%-----------------------------------------------
atomic_list_concat([],'').
atomic_list_concat([AHead|Q],Atom):-
 name(AHead,AHeadCodeList),atom_codes(AHeadAtom,AHeadCodeList),
 atomic_list_concat(Q,NewAtom),
 atom_concat(AHeadAtom,NewAtom,Atom).
%-----------------------------------------------

file_add_line(FileOUT,Line):-
 ( \+(file_exists(FileOUT)),
        open(FileOUT,write,OutStream,[type(text)])
)
; (     open(FileOUT,append,OutStream,[type(text)])
),
        tell(OutStream),
        write(Line),
        write('\n'),
        close(OutStream),
        told,
        tell(user),
!.

openFile(FilePath,Mode,Stream):-
( \+(file_exists(FilePath))
  -> open(FilePath,write,Stream,[type(Mode)])
  ;  open(FilePath,append,Stream,[type(Mode)])
).

file_read(FileIN):-
        open(FileIN,read,InStream,[type(text)]),
        see(InStream),        /* open this file */ 
        repeat, 
               read_line(InStream,Data),       /* read from File */ 
               process(Data),
        close(InStream),
        seen,!             /* close File */ 
.


file_copy(FileIN,FileOUT,Mode):-
( \+(file_exists(FileIN)),
        open(FileOUT,Mode,OutStream,[type(text)]),
        tell(OutStream),
        write('- Empty File IN'),
        close(OutStream),
        told,
        tell(user)
)
; (     open(FileIN,read,InStream,[type(text)]),
        open(FileOUT,Mode,OutStream,[type(text)]),
        see(InStream),        /* open this file */ 
        tell(OutStream),
        repeat, 
               read_line(InStream,Data),       /* read from File */ 
               process(Data),
        close(InStream),
        close(OutStream),
        seen,             /* close File */ 
        told,
        see(user),          /*  previous read source */ 
        tell(user)
),!.

process(end_of_file) :- ! . 
process(Data) :-  atom_codes(AValue,Data),write(AValue), nl ,fail. 
%-----------------------------------------------
random_atom(AValue):-
 % 48,57: digits
 % 65-90:uppercase
 % 97-122: lowercase

random_numlist(0.5,48,57,Digits),
random_numlist(0.5,65,90,Lower),
random_numlist(0.5,97,122,Upper),
append(Digits,Lower,RES),
append(RES,Upper,AtomCodesOrdered),
random_permutation(AtomCodesOrdered,AtomCodesMax),
length(AtomCodesMax,ActualLength),
random(1,ActualLength,AValueLength),
prefix_length(AtomCodesMax,AtomCodes,AValueLength),
atom_codes(AValue,AtomCodes).
%-----------------------------------------------

%-----------------------------------------------

%-----------------------------------------------

