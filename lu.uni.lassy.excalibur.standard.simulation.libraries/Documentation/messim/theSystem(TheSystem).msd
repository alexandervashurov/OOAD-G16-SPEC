@mankey
theSystem(TheSystem)
@arity
1
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"theSystem"
@mainform
"theSystem(TheSystem)"
@parameter
"TheSystem
A free variable"
@endparameters
@description
"Is true if TheSystem can be bound to the an object value that should be the only instance
of the class ctState in the state of the current version of the Messam abstract machine."
@comment
"N.A."
@example
"In the context of iCrashMini we would have after initialisation:
?- theSystem(TheSystem).
TheSystem = 
[ctState,
 [ [oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,1]]],[]]]]],
   [nextValueForAlertID,[ptInteger,1]],
   [vpStarted,[ptBoolean,true]]],[]] ? 
yes"