@mankey
resetOIDs(ObjectsList,NewObjectsList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"resetOIDs"
@mainform
"resetOIDs(ObjectsList, NewObjectsList)"
@parameter
"ObjectsList
a list of value of a class type defined according to the Messim representation "
@parameter
"NewObjectsList
a list of value of a class type defined according to the Messim representation "
@endparameters
@description
"is true if NewObjectsList is equal to ObjectsList except that each oid field of 
each object value in NewObjectsList have their value defined according the 
nextObjectID predicate (i.e. the first object of the list has its value satisfying 
the predicate, the successive ones have their oid value that incrementally follow the 
first one."
@comment
"the dynamic predicate nextObjectID is redefined using the last used value for the 
NewObjectsList objects."
@example
"1) In the context of iCrashMini we would have:

?- msrop(ctAlert,new,[bound],V),resetOIDs([V],L),write(V),write(L).

[ctAlert,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,84336]]],[]]]]],
[kind,[etHumanKind,witness]],
[id,[dtAlertID,[[value,[ptInteger,34275]]],[]]],
[phoneNumber,[dtPhoneNumber,[],[[dtString,[[value,[ptString,J3ev5tzsNd8YOm]]],[]]]]],
[comment,[dtComment,[],[[dtString,[[value,[ptString,BId6mJENMvnk7yD]]],[]]]]]],[]]

[[ctAlert,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,17]]],[]]]]],
[kind,[etHumanKind,witness]],
[id,[dtAlertID,[[value,[ptInteger,34275]]],[]]],
[phoneNumber,[dtPhoneNumber,[],[[dtString,[[value,[ptString,J3ev5tzsNd8YOm]]],[]]]]],
[comment,[dtComment,[],[[dtString,[[value,[ptString,BId6mJENMvnk7yD]]],[]]]]]],[]]]

2) ?- msrop(ctMsrActor,new,[bound],O1),msrop(ctMsrActor,new,[bound],O2),
nextObjectID(OIDatPre),resetOIDs([O1,O2],L),write([O1,O2]),write(L), 
nextObjectID(OIDatPost).

O1 = [ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,44030]]],[]]]]]],[]],
O2 = [ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,7708]]],[]]]]]],[]]]

L = [
[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,24]]],[]]]]]],[]],
[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,25]]],[]]]]]],[]]
]

OIDatPre = 23, 
OIDatPost = 25 ?

yes"