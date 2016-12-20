@mankey
msrop(ATypeName,new,free,AValue)
@arity
4
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrop"
@mainform
"msrop(ATypeName,new,[free],AValue)"
@parameter
"ATypeName
a name of a declared data type or class type"
@parameter
"new
the constant name of the messam operation"
@parameter
"[free]
an indicator for the kind of new operation"
@parameter
"AValue
the newly created value"
@endparameters
@description
"is true if AValue is a list expression of type ATypeName that is built accordingly
to the Messim typed value representation (c.f. Messim chapter) and such that
a Prolog variable identifier is provided for each field of ATypeName."
@comment
"make use of the Messim operation 'create' (cf. msrop(ATypeName,create,VariablesList,AValue))."
@example
"In the context of iCrashMini we would have:
1) 
?- msrop(dtString,new,[free],AValue).
AValue = [dtString,[[value,[ptString,_A]]],[]] ? 
yes
2)
?- msrop(dtSMS,new,[free],AValue), write(AValue).
AValue = [dtSMS,[],[[dtString,[[value,[ptString,_A]]],[]]]] ? 
yes
3)
?- msrop(ctState,new,[free],AValue).
AValue = 
[ctState,
[[oid,[dtOID,[],
[[dtInteger,[[value,[ptInteger,_A]]],[]]]]],
 [nextValueForAlertID,[ptInteger,_B]],
 [vpStarted,[ptBoolean,_C]]],[]]
"
