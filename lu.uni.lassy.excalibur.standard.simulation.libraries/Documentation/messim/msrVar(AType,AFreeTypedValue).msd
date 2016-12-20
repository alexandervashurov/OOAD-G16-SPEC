@mankey
msrVar(AType,AFreeTypedValue)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrVar"
@mainform
"msrVar(AType,AFreeTypedValue)"
@parameter
"AType
a type name"
@parameter
"AFreeTypedValue
a typed value"
@endparameters
@description
"is true if AFreeTypedValue is a typed value having a Prolog variable 
term for each of its attribute."
@comment
"not supposed to be called with AType not being a variable term."
@example
"In the context of iCrashMini we would have:
1)
?- msrVar(dtString,AFreeTypedValue).
AFreeTypedValue = [dtString,[[value,[ptString,_A]]],[]] ? 
yes
2)
?- msrVar(dtString,[dtString,[[value,[ptString,_A]]],[]]).
yes
"