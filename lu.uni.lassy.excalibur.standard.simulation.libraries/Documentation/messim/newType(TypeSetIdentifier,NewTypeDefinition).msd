@mankey
newType(TypeSetIdentifier,NewTypeDefinition)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newType"
@mainform
"newType(TypeSetIdentifier,NewTypeDefinition)"
@parameter
"TypeSetIdentifier
a category of types"
@parameter
"NewTypeDefinition
a definition of all the primary fields made of a field name and a field type name."
@endparameters
@description
"for each category of types handled by Messim, there exist 
two predicates: one that contains the list of all types definition
and one that declares the type names of this category
together with its definition. Thus this predicate is true if its 
satisfaction those two lists knowing the category 'TypeSetIdentifier'
and the definition'NewTypeDefinition'."
@comment
"Makes use of newTypePartitioned predicate.
If the category is 'classTypes' thus the oid field is added to the given 
type definition."
@example
"In the context of iCrashMini we would have:
?- allTypesDefinition(L),samsort(L,NL),simpleListListing(NL).
[classTypes,[ctAlert,[[oid,dtOID],[kind,etHumanKind],[id,dtAlertID],[phoneNumber,dtPhoneNumber],[comment,dtComment]]]]
[classTypes,[actComCompany,[[oid,dtOID]]]]
...
[classTypes,[ctOutputInterface,[[oid,dtOID]]]]
[classTypes,[ctState,[[oid,dtOID],[nextValueForAlertID,ptInteger],[vpStarted,ptBoolean]]]]
[dataTypes,[dtAlertID,[[value,ptInteger]]]]
[dataTypes,[dtComment,[]]]
...
[dataTypes,[rtRelDefPart,[[partEnd,ptString],[roleName,ptString],
[roleType,ptString],[cardMin,ptString],[cardMax,ptString]]]]
[enumerationTypes,[etHumanKind,[witness,victim,anonym]]]
[primitiveTypes,[ptBoolean,[]]]
[primitiveTypes,[ptInteger,[]]]
[primitiveTypes,[ptReal,[]]]
[primitiveTypes,[ptString,[]]]
[relationTypes,[composition,rtctStatectAlert,[[ctState,rnSystem],[ctAlert,rnctAlert]],
[[rtRelDefPart,[[partEnd,[ptString,ctState]],[roleName,[ptString,rnSystem]],
[roleType,[ptString,composite]],[cardMin,[ptString,1]],
[cardMax,[ptString,1]]],[]],[rtRelDefPart,[[partEnd,[ptString,ctAlert]],
[roleName,[ptString,rnctAlert]],[roleType,[ptString,part]],[cardMin,[ptString,0]],
[cardMax,[ptString,*]]],[]]]]]
... ? 

newAssociationParts(AssociationType, AssociationName, PartsList, PartsDefinitionOUT)"