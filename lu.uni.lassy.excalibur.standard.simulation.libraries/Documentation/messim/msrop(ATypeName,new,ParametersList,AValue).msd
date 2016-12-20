@mankey
msrop(ATypeName,new,ParametersList,AValue)
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
"msrop(ATypeName,new,ParametersList,AValue)"
@parameter
"ATypeName
a name of a declared data type or class type"
@parameter
"new
the constant name of the messam operation"
@parameter
"ParametersList
a list of parameters to be used for the value creation"
@parameter
"AValue
the newly created value"
@endparameters
@description
"is true if AValue is a list expression of type ATypeName that is built accordingly
to the Messim typed value representation (c.f. Messim chapter) and such that
to each field of ATypeName, a value is substituted taken from ParametersList."
@comment
"Makes use of the Messim operation 'create' (cf. msrop(ATypeName,create,ParametersList,AValue)).
Fails is the new operation is declared as a protected operation for the type ATypeName.
The list of parameters is either free or must contain enough values that will be consumed 
accordingly to the orders induced recursively by the attributes list and the supertypes lists
No type checking is made for the provide values in the list w.r.t. primitive types definitions."
@example
"In the context of iCrashMini we would have:
1) 
?- msrop(dtString,new,[hello],AValue).
AValue = [dtString,[[value,[ptString,hello]]],[]] ? 
yes
2)
?- msrop(dtPhoneNumber,new,['+3524666445251'],AValue).
AValue = [dtPhoneNumber,[],[[dtString,[[value,[ptString,'+3524666445251']]],[]]]] ? 
3) In this example, notice the length of the values list and the non type checking for the boolean value.
?- msrop(ctState,new,[1,11,111,false],AValue).
AValue = 
[ctState,
[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,1]]],[]]]]],
[nextValueForAlertID,[ptInteger,11]],
[vpStarted,[ptBoolean,111]]],[]]
4) in this example, we show that having a free parameters list is equivalent to [free]:
?- msrop(dtString,new,_,AValue).
AValue = [dtString,[[value,[ptString,_A]]],[]] ? 
yes
?- msrop(dtString,new,[free],AValue).
AValue = [dtString,[[value,[ptString,_A]]],[]] ? 
yes
"