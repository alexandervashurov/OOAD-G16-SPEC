@mankey
initializeMsrActorRelations(ActorTypeName,ActorRoleName)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"initializeMsrActorRelations"
@mainform
"initializeMsrActorRelations(ActorTypeName, ActorRoleName)"
@parameter
"ActorTypeName
the name of the actor class type"
@parameter
"ActorRoleName
a name for the actor role name"
@endparameters
@description
"a new association is declared between the actor type ActorTypeName and the 
ctState class since all actors are composing the system's environment.
Thus the association is a composition with ctState as composite with 'rnSystem'
as role name and the actor ActorTypeName as part with the given ActorRoleName
as role name and (1,*) as cardinality."
@comment
"the association name is automatically generated using the ActorTypeName
and 'rtctState' as atoms."
@example
"N.A.
"