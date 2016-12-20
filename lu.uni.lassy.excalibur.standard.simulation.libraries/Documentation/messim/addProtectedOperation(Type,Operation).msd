@mankey
addProtectedOperation(Type,Operation)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"addProtectedOperation"
@mainform
"addProtectedOperation(Type,Operation)"
@parameter
"Type
a type name"
@parameter
"Operation
an operation name"
@endparameters
@description
"declares the operation 'Operation' as a protected operation for the 
type 'Type'."
@comment
"fails if Type or Operation is a variable term.
Protected operations are handled using the dynamic predicate protectedOperations/1."
@example
"In the context of iCrashMini we would have:
?- addProtectedOperation(dtOID,new).
yes
"