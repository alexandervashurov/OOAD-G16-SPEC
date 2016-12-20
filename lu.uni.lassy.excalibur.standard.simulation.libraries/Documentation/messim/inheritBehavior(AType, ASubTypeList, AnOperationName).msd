@mankey
inheritBehavior(AType,ASubTypeList,AnOperationName)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"inheritBehavior"
@mainform
"inheritBehavior(AType, ASubTypeList, AnOperationName)"
@parameter
"AType
a type name"
@parameter
"ASubTypeList
a list of type names as subtypes of AType "
@parameter
"AnOperationName
an operation name "
@endparameters
@description
"for each subtype in ASubTypeList if the operation AnOperationName 
is not already declared for this subtype (thus having already a corresponding msrop associated predicate)
then a msrop predicate declaration for this operation is generated to the 
output file for consultation such that this predicate is a redirection to the 
super type msrop predicate for operation AnOperationName."
@comment
"N.A."
@example
"In the context of iCrashMini we would have 
inheritBehavior(dtString, [dtSMS,dtPhoneNumber,dtComment], length).
"