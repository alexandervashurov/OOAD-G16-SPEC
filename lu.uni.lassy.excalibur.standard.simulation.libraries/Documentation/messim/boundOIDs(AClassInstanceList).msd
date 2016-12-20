@mankey
boundOIDs(AClassInstanceList)
@arity
1
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"boundOIDs"
@mainform
"boundOIDs(AClassInstanceList)"
@parameter
"AClassInstanceList
a list of typed values defined according to the Messim representation."
@endparameters
@description
"is true if for each value in AClassInstanceList that is an object 
(whose type is in the class types) then the oid fields can be bound to
a valid dtOID value."
@comment
"1) there might be several oid fields in case of hierarchy of class types.
2) AnOID is a valid dtOID value if it satisfies the predicate 
msrop(dtOID,new,[bound],AnOID)."
@example
"In the context of iCrashMini we would have:
?- msrop(ctAlert,new,[free],V), 
getField(V,[oid],OID),write(OID),write('\n'),boundOIDs([V]),
getField(V,[oid],OID),write(OID).

[dtOID,[],[[dtInteger,[[value,[ptInteger,_11216]]],[]]]]
[dtOID,[],[[dtInteger,[[value,[ptInteger,22]]],[]]]]

V = [ctAlert,
[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,22]]],[]]]]],
[kind,[etHumanKind,witness]],
[id,[dtAlertID,[[value,[ptInteger,_11356]]],[]]],
[phoneNumber,[dtPhoneNumber,[],[[dtString,[[value,[ptString,_11393]]],[]]]]],
[comment,[dtComment,[],[[dtString,[[value,[ptString,_11430]]],[]]]]]],[]]

OID = [dtOID,[],[[dtInteger,[[value,[ptInteger,22]]],[]]]] ? 

yes
"