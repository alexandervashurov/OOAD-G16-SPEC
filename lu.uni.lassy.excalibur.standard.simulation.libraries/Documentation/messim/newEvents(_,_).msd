@mankey
newEvents(_,_)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newEvents"
@mainform
"newEvents(AnEventCategory,[AClassType,AnEventName,ASignature])"
@parameter
"AnEventCategory
must be either inputEvents or outputEvents."
@parameter
"AClassType
the name of an input or output interface class."
@parameter
"AnEventName
the event name."
@parameter
"AClassType
the name of an input or output interface class."
@parameter
"ASignature
a list made of a list of parameters names and types and
a list containing the type of the returned parameter if any."
@endparameters
@description
"is true if, a there exist a new class operation associated to
the event name AnEventName for the class AClassType.
the new list of events for the category Category contains the event 
whose profile is indicated in the predicate's parameters."
@comment
"existing events are the ones in the only list that satisfies
the dynamic unary predicate 'outputEvents(EventsList) or
inputEvents(EventsList).' depending of the event category."
@example
"newEvents(outputEvents,
       [ outactMsrCreator,
         oeCreateSystemAndEnvironment,
        [ [[qtyComCompanies,ptInteger]],
          []]])
   
  a call to satisfy outputEvents(L) will get
  L = [[outactMsrCreator,
       oeCreateSystemAndEnvironment,
       [[[qtyComCompanies,ptInteger]],[]]]
     ]
     
newEvents(outputEvents,[outactComCompany,
                           oeAlert,
                           [ [[kind,dtHumanKind],
                              [aPhoneNumber,dtPhoneNumber],
                              [aComment,dtComment]],
                           []]
                       ]).
    ]]).

newEvents(inputEvents, [inactComCompany,
                           ieSmsSend,
                           [ [[aPhoneNumber,dtPhoneNumber],
                              [aSMS,dtSMS]],
                             []]
                        ]).
    ]]).
"