@mankey
getAssociationName(AType,ARoleNameAtom,AnAssociationName)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getAssociationName"
@mainform
"getAssociationName(AType, ARoleNameAtom, AnAssociationName)"
@parameter
"AType
a type name"
@parameter
"ARoleNameAtom
a role name for an association"
@parameter
"AnAssociationName
a name of an existing association in the Messir concept model."
@endparameters
@description
"is true if there exist a unique association having AnAssociationName for name
and such that it has an end having for role name ARoleNameAtom and another end
having AType for related type.
type at this end."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
?- getAssociationName(inactComCompany,rnActor,X).
X = rtactComCompanyinactComCompany ? 
or,
| ?- getAssociationName(ctAlert,rnSystem,Z).
Z = rtctStatectAlert ? 
or since there is only one association with rnctAlert as role name,
| ?- getAssociationName(X,rnctAlert,Z).
Z = rtctStatectAlert ? 
or since there are many association having a part end with rnActor as role name,
we would have:
| ?- getAssociationName(X,rnActor,Z).
no

"