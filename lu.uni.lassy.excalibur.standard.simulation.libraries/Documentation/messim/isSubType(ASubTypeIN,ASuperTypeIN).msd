@mankey
isSubType(ASubTypeIN,ASuperTypeIN)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"isSubType"
@mainform
"isSubType(ASubTypeIN, ASuperTypeIN)"
@parameter
"ASubTypeIN
a type name"
@parameter
"ASuperTypeIN
a type name"
@endparameters
@description
"is true if either ASubTypeIN has been declared as a direct or 
indirect sub type of ASuperTypeIN."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- isSubType(dtSMS,dtString).
yes
or
?- isSubType(X,dtString).
X = dtSMS ? ;
X = dtPhoneNumber ? ;
X = dtComment ? ;
no
"