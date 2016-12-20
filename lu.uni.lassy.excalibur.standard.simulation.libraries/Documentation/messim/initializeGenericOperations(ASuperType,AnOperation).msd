@mankey
initializeGenericOperations(ASuperType,AnOperation)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"initializeGenericOperations"
@mainform
"initializeGenericOperations(ASuperType,AnOperation)"
@parameter
"ASuperType
a name of a class type."
@parameter
"AnOperation
an operation name that must be either 'init' or 'destroy'."
@endparameters
@description
"for each subtype of ASuperType an init or destroy operation 
is dynamically declared as associated to the subtype that reuse the
supertype corresponding operation."
@comment
"(TBC) only subtypes having no attribute are considered."
@example
"N.A.+
"