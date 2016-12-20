@mankey
allSubTypes(ASubTypeIN,ASuperTypesList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"allSubTypes"
@mainform
"allSubTypes(ASubTypeIN, ASuperTypesList)"
@parameter
"ASubTypeIN
a type name"
@parameter
"ASuperTypesList
a list of type names"
@endparameters
@description
"is true if ASuperTypesList is made of all the type names declared as super types 
for ASubTypeIN."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- allSubTypes(dtString,ASuperTypesList).
ASuperTypesList = [dtSMS,dtPhoneNumber,dtComment] ? 
yes
"