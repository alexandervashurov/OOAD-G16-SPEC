%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  DISCONTIGUOUS PREDICATES  */
:- multifile msrFilePath/2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Files */
:-dynamic msrFilePath/2.
:-retractall(msrFilePath(_,_)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:-use_module(library(random)).
:-use_module(library(system)).
:-use_module(library(clpfd)).
:-set_prolog_flag(source_info,on).

user:runtime_entry(start):-
write('hello world'),nl,
write('Getting random value:'),nl,
random(1,10,R),
write(R),nl,
%write('Getting date:'),nl,
%datetime(Date),
%write(Date),nl,
( all_different([3,9]) ->
        write('3 != 9'),nl
; otherwise ->
  write('3 = 9!?'),nl)
.
