@mankey
superTypes(ASubTypeIN,ASuperTypesList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"superTypes"
@mainform
"superTypes(ASubTypeIN, ASuperTypesList)"
@parameter
"ASubTypeIN
a type name"
@parameter
"ASuperTypesList
a type names list"
@endparameters
@description
"is true if ASuperTypesList is the list of types names declared as super types of 
ASubTypeIN."
@comment
"In case no supertypes have been declared this list should be the empty list."
@example
"In the context of iCrashMini we would have:
?- superTypes(dtPhoneNumber,ASuperTypesList).
ASuperTypesList = [dtString] ? 
yes"