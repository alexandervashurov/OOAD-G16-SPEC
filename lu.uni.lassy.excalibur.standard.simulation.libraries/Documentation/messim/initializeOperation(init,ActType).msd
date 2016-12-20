@mankey
initializeOperation(init,ActType)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"initializeOperation"
@mainform
"initializeOperation(init,ActType)"
@parameter
"init
the bound name of the operation to initialize"
@parameter
"ActType
a class type name"
@endparameters
@description
"generate in the current stream the Prolog code necessary to ensure the
existence at interpretation time of an init operation for the type ActType."
@comment
"This init operation is declared using the generic predicate msrop for the type
ActType by creating a free object of this type and then binding it and 
adding it to the abstract machine state using the msmop predicate with msrIsNew."
@example
":-newOperation(ctExampleClass,init,[[],[ctExampleClass]]).

msrop(ctExampleClass,init,[],ThectType):-
msrop(ctExampleClass,new,[free],ThectType),!,
msmop(msrIsNew,ThectType,[]).
"
