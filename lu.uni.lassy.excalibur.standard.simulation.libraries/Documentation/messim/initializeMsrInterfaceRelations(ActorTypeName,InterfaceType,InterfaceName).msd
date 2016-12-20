@mankey
initializeMsrInterfaceRelations(ActorTypeName,InterfaceType,InterfaceName)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"initializeMsrInterfaceRelations"
@mainform
"initializeMsrInterfaceRelations(ActorTypeName, InterfaceType, InterfaceName)"
@parameter
"ActorTypeName
the name of the actor class type"
@parameter
"InterfaceType
either ctOutputInterface or ctInputInterface"
@parameter
"InterfaceName
the type name of the interface"
@endparameters
@description
"a new association is declared between the actor type ActorTypeName and its 
interface of type InterfaceType. The association end cardinalities are (1,1).
The role names are 'rnActor' and 'rnInterfaceIN' or 'rnInterfaceOUT' depending
on the type of the interface."
@comment
"the association name is automatically generated using the ActorTypeName
and InterfaceName as atoms."
@example
"N.A.
"