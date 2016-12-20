@mankey
msrop(_,AnInputEvent,_,_)
@arity
4
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrop"
@mainform
"msrop(_ActInputInterface,AnInputEvent,Parameters,[])"
@parameter
"AnInputEvent
a name of an event that must be in the list of input
events declared with the actors input interfaces."
@parameter
"Parameters
a list of the form [InterfaceIN | EventParametersList] where
InterfaceIN is an instance of the input interface of the class that
must contain an event named AnInputEvent.
EventParametersList must be a list of typed values consistent
w.r.t. the declared profile of the input event of the actor that
is supposed to receive the event sent through his input interface."
@endparameters
@description
"declares a msrop predicate instance for message sending to
external actors that reuse the msrSent predicate with the
correct parameters InterfaceIN,AnInputEvent and EventParametersList."
@comment
"N.A."
@example
"In the iCrashMini example we would have:
InterfaceIN = 
 [inactComCompany,
    [[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,11]]],[]]]]]],
    [[ctInputInterface,[[oid,[dtOID,[],
      [[dtInteger,[[value,[ptInteger,10]]],[]]]]]],[]]]]
AnInputEvent = ieSmsSend
EventParametersList =
  [[dtPhoneNumber,[],
    [[dtString,[[value,[ptString,+33660688877]]],[]]]],
   [dtSMS,[],
    [[dtString,[[value,[ptString,Alert registered]]],[]]]]]
]])
"
