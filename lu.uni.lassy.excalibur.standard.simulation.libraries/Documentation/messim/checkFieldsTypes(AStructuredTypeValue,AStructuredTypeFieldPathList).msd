@mankey
checkFieldsTypes(AStructuredTypeValue,AStructuredTypeFieldPathList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"checkFieldsTypes"
@mainform
"checkFieldsTypes(AStructuredTypeValue, AStructuredTypeFieldPathList)"
@parameter
"AStructuredTypeValue
a typed value Messim representation"
@endparameters
@description
"is true if for each path of AStructuredTypeFieldPathList then 
when accessing the field in AStructuredTypeValue using the path 
then the value returned is structurally of the type returned."
@comment
"to check the type it uses the predicate isTypeOf."
@example
"In the context of iCrashMini we would have:
?- msrop(dtSMS,new,[bound],V), checkFieldsTypes(V,[[value]]).
V = 
[dtSMS,[],[[dtString,[[value,[ptString,'4sG5Y8Dp1CvIazc3Wj']]],[]]]] ? 
yes
"