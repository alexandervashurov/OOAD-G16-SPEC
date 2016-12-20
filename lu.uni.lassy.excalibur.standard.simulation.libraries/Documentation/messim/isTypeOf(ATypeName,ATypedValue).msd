@mankey
isTypeOf(ATypeName,ATypedValue)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"isTypeOf"
@mainform
"isTypeOf(ATypeName,ATypedValue)"
@parameter
"ATypeName
a bound name of a type."
@parameter
"ATypedValue
a bound typed value."
@endparameters
@description
"is true if ATypedValue respects the type definition of ATypeName."
@comment
"N.A."
@example
"?- msrop(dtSMS,new,[bound],ASMS),isTypeOf(dtSMS,ASMS).
 ASMS = [dtSMS,[],
 [[dtString,[[value,[ptString,pN3MuF9xRgfeCPtw6sTlSXEmYVkZO]]],[]]]] ?
 'yes'
 
?- msrop(dtSMS,new,[free],ASMS),isTypeOf(dtSMS,ASMS).
 'no'
"
