@mankey
getFieldsListFromTypeDef(ATypeNameIN,AFieldsListOUT)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getFieldsListFromTypeDef"
@mainform
"getFieldsListFromTypeDef(ATypeNameIN, AFieldsListOUT)"
@parameter
"ATypeNameIN
an atom"
@parameter
"AFieldsListOUT
a list of lists of atoms"
@endparameters
@description
"is true if AFieldsListOUT is the flattened list of all fields paths
for each field defined in the definition of the type ATypeNameIN."
@comment
"The flattened list of fields names should be correspond to their declaration order.
A field path is a complete list of fields names that is built according to the 
type hierarchy until the leaf."
@example
"In the context of iCrashMini we would have:
1) ?- getFieldsListFromTypeDef(ctAlert,List).
List = 
[[oid,value],
[kind],
[id,value],
[phoneNumber,value],
[comment,value]] ? 
yes
2) ? - getFieldsListFromTypeDef(dtSMS,List).
List = [[value]] ? 
yes
3) ?- getFieldsListFromTypeDef(actComCompany,List).
List = [[oid,value],[oid,value]] ? 

"