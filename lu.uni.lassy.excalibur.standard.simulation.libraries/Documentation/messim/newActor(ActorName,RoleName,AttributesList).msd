@mankey
newActor(ActorName,RoleName,AttributesList)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newActor"
@mainform
"newActor(ActorName,RoleName,AttributesList)"
@parameter
"ActorName
the name for the actor class type"
@parameter
"RoleName
the name for the role of the actor in its association with the ctState class."
@parameter
"AttributesList
the list of attribute names and types for the actor"
@endparameters
@description
"predicate used to create the class type for the actor ActorName 
as a subtype of ctMsrActor using the newType predicate, 
to ensure that this new type is in the list of actor types and
to initialize the composite association that must exist with the 
ctState class."
@comment
"AttributesList is expected to be the empty list 
(see the semantics chapter for details)."
@example
"In the contexte of the iCrashMini case study we would have:
newActor(actComCompany,rnactComCompany,[])
"