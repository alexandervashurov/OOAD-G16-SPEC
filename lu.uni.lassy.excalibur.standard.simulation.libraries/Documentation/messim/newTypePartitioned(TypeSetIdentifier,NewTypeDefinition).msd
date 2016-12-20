@mankey
newTypePartitioned(TypeSetIdentifier,NewTypeDefinition)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newTypePartitioned"
@mainform
"newTypePartitioned(TypeSetIdentifier, NewTypeDefinition)"
@parameter
"TypeSetIdentifier
a category of types"
@parameter
"NewTypeDefinition
a definition of all the primary fields made of a field name and a field type name."
@endparameters
@description
"for each category of types handled by Messim, there exist 
a predicate that declares the type names of this category
together with its definition. Thus this predicate is true if its 
satisfaction changes the list of types of category 'TypeSetIdentifier'
by adding 'NewTypeDefinition' to the existing list of types."
@comment
"Messim categories of types are: interfaceTypes,actorTypes,
classTypes,subTypes,relationTypes,dataTypes,
enumerationTypes and primitiveTypes.
The newTypePartitioned predicate is asked for resolution by the newType predicate.
A type definition does not included the fields of the declared supertypes."
@example
"In the context of iCrashMini we would have the following lists resulting
from the resolution of newTypePartitioned:
1)
?- classTypes(L).
L would be a list containing:
[inactComCompany,[[oid,dtOID]]],
[ctAlert,[[oid,dtOID],[kind,etHumanKind], [id,dtAlertID], [phoneNumber,dtPhoneNumber], [comment,dtComment]]],
[ctState,[[oid,dtOID],[nextValueForAlertID,ptInteger],[vpStarted,ptBoolean]]]
2) ?- dataTypes(L).
L would be a list containing:
[dtPhoneNumber,[]],
[dtComment,[]],
[dtAlertID,[[value,ptInteger]]],
[dtString,[[value,ptString]]],
[dtOID,[]]
3) ?- actorTypes(L).
L = [[actMsrCreator,[[oid,dtOID]]],[actComCompany,[[oid,dtOID]]]] ? 
yes
"