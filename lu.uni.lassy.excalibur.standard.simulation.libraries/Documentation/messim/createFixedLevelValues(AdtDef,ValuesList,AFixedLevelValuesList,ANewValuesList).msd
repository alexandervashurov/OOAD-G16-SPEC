@mankey
createFixedLevelValues(AdtDef,ValuesList,AFixedLevelValuesList,ANewValuesList)
@arity
4
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"createFixedLevelValues"
@mainform
"createFixedLevelValues(AdtDef, ValuesList, AFixedLevelValuesList, ANewValuesList)"
@parameter
"AdtDef
a list of couples [AFieldName,AFieldType] made of a field name and a field type name."
@parameter
"ValuesList
a list of typed values."
@parameter
"AFixedLevelValuesList
a list of created typed values."
@parameter
"ANewValuesList
the list of typed values of ValuesList not used."
@endparameters
@description
"is true if AFixedLevelValuesList is a list of couples [AFieldName,AValueOUT] 
for each couple [AFieldName,AFieldType] of AdtDef such that AValueOUT is a value 
of type AFieldType created using the msrop predicate with the fields values
of ValuesList and such that if not all values are consumed then ANewValuesList
contains the remaining values."
@comment
"- uses msrop(AFieldType,create,ValuesList,AValueOUT).
- needs to compute the number of fields at each recursion step using 
fieldsNumber(AFieldType,ATmpFieldsNumber) such that if ATmpFieldsNumber is equal to 0 it means
that it is primitive type. This is why, in this case, the number of consumed values must be one."
@example
"createFixedLevelValues([[name,dtString],[state,ctState],[actor,ctMsrActor]],
[1,2,3,4,5,6,7,8,9],L,P).
L = 
[[name,[dtString,[[value,[ptString,1]]],[]]],
 [state,[ctState,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,2]]],[]]]]],
                  [nextValueForAlertID,[ptInteger,3]],
                  [vpStarted,[ptBoolean,4]]],[]]],
 [actor,[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,5]]],[]]]]]],[]]]],
P = [6,7,8,9] ? 
"