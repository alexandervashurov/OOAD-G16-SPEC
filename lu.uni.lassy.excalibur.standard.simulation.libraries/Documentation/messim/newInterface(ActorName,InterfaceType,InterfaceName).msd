@mankey
newInterface(ActorName,InterfaceType,InterfaceName)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newInterface"
@mainform
"newInterface(ActorName,InterfaceType,InterfaceName)"
@parameter
"ActorName
the name for the actor class type"
@parameter
"InterfaceType
either ctOutputInterface or ctInputInterface"
@parameter
"InterfaceName
the name of the class type for the interface"
@endparameters
@description
"predicate used to create the class type for the actor interface 
as a subtype of InterfaceType using the newType predicate, 
to ensure that this new type is in the list of interface types and
to initialize the association that must exist between the actor type 
ActorName and the interface InterfaceName."
@comment
"N.A."
@example
"In the context of the iCrashMini case study we would have:
newInterface(
    actComCompany,
    ctOutputInterface,
    outactComCompany).
and
newInterface(
    actComCompany,
    ctInputInterface,
    inactComCompany)
"