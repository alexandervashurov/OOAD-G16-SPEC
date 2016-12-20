@mankey
isProtectedOperation(Type,Operation)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"isProtectedOperation"
@mainform
"isProtectedOperation(Type,Operation)"
@parameter
"Type
a type name"
@parameter
"Operation
an operation name"
@endparameters
@description
"is true if the operation 'Operation' is in the list of protected operation for the 
type 'Type'."
@comment
"fails if Type or Operation is a variable term.
Protected operations are handled using the dynamic predicate protectedOperations/1."
@example
"In the context of iCrashMini we would have:
?- isProtectedOperation(dtOID,new).
yes
"