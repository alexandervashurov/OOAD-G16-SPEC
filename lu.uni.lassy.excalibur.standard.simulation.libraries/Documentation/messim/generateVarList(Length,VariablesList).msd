@mankey
generateVarList(Length,VariablesList)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"generateVarList"
@mainform
"generateVarList(Length,VariablesList)"
@parameter
"Length
a bound natural number"
@parameter
"VariablesList
A free variable"
@endparameters
@description
"is true if VariablesList is a list containing 'Length' variables identifiers."
@comment
"'-' is used to recursively build the list of variable
thus reusing the Prolog variable handling mechanism."
@example
"?- generateVarList(3,VariablesList).
VariablesList = [_A,_B,_C] ? 
yes
"