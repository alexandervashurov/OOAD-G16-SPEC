@mankey
getNextObjectID(CPT)
@arity
1
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getNextObjectID"
@mainform
"getNextObjectID(CPT)"
@parameter
"CPT
a free variable"
@endparameters
@description
"is true if CPT is bound to an integer equal to the successor of the one
satisfying the nextObjectID predicate and if the dynamic nextObjectID
is redefined to be satisfied with only CPT."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- getNextObjectID(CPT).
CPT = 14 ? 
yes
"