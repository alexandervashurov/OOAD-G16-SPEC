@mankey
fieldsNumberUpperLevelsList(SuperTypesList,P)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"fieldsNumberUpperLevelsList"
@mainform
"fieldsNumberUpperLevelsList(SuperTypesList,P)"
@parameter
"SuperTypesList
a list of type names."
@parameter
"P
a natural number"
@endparameters
@description
"is true if P equals the number of all the fields that are declared 
in the type definition for all the types of SuperTypesList."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- fieldsNumberUpperLevelsList([ctMsrActor,dtString],P).
P = 2 ? 
yes
"