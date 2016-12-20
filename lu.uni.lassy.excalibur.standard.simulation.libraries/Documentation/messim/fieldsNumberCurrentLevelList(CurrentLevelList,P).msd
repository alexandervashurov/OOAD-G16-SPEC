@mankey
fieldsNumberCurrentLevelList(CurrentLevelList,P)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"fieldsNumberCurrentLevelList"
@mainform
"fieldsNumberCurrentLevelList(CurrentLevelList,P)"
@parameter
"CurrentLevelList
a list of couples made of a field name and a field type"
@parameter
"P
a natural number"
@endparameters
@description
"is true if P equals the number of all the fields that are declared 
in the type definition for all the types of CurrentLevelList."
@comment
"remember that the predicate fieldsNumber(FieldType,Q) is true when Q is 0 and
FieldType a primitive type, thus we increment by 1. "
@example
"In the context of iCrashMini we would have:
?- fieldsNumberCurrentLevelList([[_,ctAlert],[phone,dtPhoneNumber]],P).
P = 6 ? 
"