@mankey
inherit(SubType,SuperTypesList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"inherit"
@mainform
"inherit(SubType,SuperTypesList)"
@parameter
"SubType
an atom"
@parameter
"SuperTypesList
a list of atoms"
@endparameters
@description
"is true if the dynamic predicate subTypes is updated with a 
value containing all the previous subTypes elements plus the new one
as a list [SubType,SuperTypesList]."
@comment
"is is supposed that SubType was not already known as a 
subtype (i.e. not in the existing list). 
It is supposed that this predicate will not be called with a super types 
list containing the value 'SubType'."
@example
"In the context of iCrashMini we would have to ask for satisfying :
:-inherit(dtComment,[dtString]).
"