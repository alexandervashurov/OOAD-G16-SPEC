@mankey
msrop(ATypeName,new,bound,AValue)
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
"msrop(ATypeName,new,[bound],AValue)"
@parameter
"ATypeName
a name of a declared data type or class type"
@parameter
"new
the constant name of the messam operation"
@parameter
"[bound]
an indicator for the kind of new operation"
@parameter
"AValue
the newly created value"
@endparameters
@description
"is true if AValue is a list expression of type ATypeName that is built accordingly
to the Messim typed value representation (c.f. Messim chapter) and such that
a automatically synthesized bound value is provided for each field of ATypeName."
@comment
"make use of the Messim operation 'create' (cf. msrop(ATypeName,create,_,AValue)).
Fails is the new operation is declared as a protected operation for the type ATypeName."
@example
"In the context of iCrashMini we would have:
1) 
?- msrop(dtString,new,[bound],AValue).
AValue = [dtString,[[value,[ptString,'O5']]],[]] ? 
yes
2)
?- msrop(dtSMS,new,[bound],AValue).
AValue = [dtSMS,[],[[dtString,[[value,[ptString,'4sG5Y8Dp1CvIazc3Wj']]],[]]]] ? 
3)
?- msrop(ctState,new,[bound],AValue), write(AValue).
AValue = 
[ctState,
 [[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,-8592]]],[]]]]],
  [nextValueForAlertID,[ptInteger,4993]],
  [vpStarted,[ptBoolean,true]]],[]]
"