@mankey
getUpperLevelsFields(SuperTypesList,UpperLevelFields)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getUpperLevelsFields"
@mainform
"getUpperLevelsFields(SuperTypesList , UpperLevelFields)"
@parameter
"SuperTypesList
a list atoms"
@parameter
"UpperLevelFields
a list of lists of atoms"
@endparameters
@description
"is true if UpperLevelFields is the flattened list of all fields paths
for each field of each type provided in the list SuperTypesList according 
to its type definition."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- getUpperLevelsFields([dtString] , UpperLevelFields).
UpperLevelFields = [[value]] ? 

? getUpperLevelsFields([ctAlert] , UpperLevelFields).
UpperLevelFields = 
[[oid,value],[kind],[id,value],[phoneNumber,value],[comment,value]] ? 

"