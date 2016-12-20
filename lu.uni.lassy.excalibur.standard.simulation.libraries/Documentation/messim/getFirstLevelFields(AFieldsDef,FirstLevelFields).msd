@mankey
getFirstLevelFields(AFieldsDef,FirstLevelFields)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getFirstLevelFields"
@mainform
"getFirstLevelFields(AFieldsDef , FirstLevelFields)"
@parameter
"AFieldsDef
a list of lists of two atoms [FieldName, FieldType]."
@parameter
"FirstLevelFields
a list of lists of atoms"
@endparameters
@description
"is true if FirstLevelFields is the flattened list of all fields paths
for each field provided in the list AFieldsDef according to its declared type."
@comment
"The flattened list of fields names should be correspond to their declaration order.
A field path is a complete list of fields names that is built according to the 
type hierarchy until the leaf."
@example
"?- getFirstLevelFields([[phone , dtPhoneNumber]],L).
L = [[phone,value]] ? 
yes
"