@mankey
freecopy(ValuesList,NewValuesList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"freecopy"
@mainform
"freecopy(ValuesList, NewValuesList)"
@parameter
"ValuesList
a list of typed values defined according to the Messim representation "
@parameter
"NewValuesList
a list of typed values defined according to the Messim representation "
@endparameters
@description
"is true if NewValuesList is equal to ValuesList in which each object value 
has its oid field being a variable."
@comment
"an object might be at inner level in a typed value."
@example
"In the context of iCrashMini we would have:
?- msrop(ctMsrActor,new,[bound],O1),msrop(ctMsrActor,new,[bound],O2),
freecopy([O1,O2],L),write([O1,O2]),write(L).

O1 = [[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,51321]]],[]]]]]],[]],
O2 = [ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,18004]]],[]]]]]],[]]]

L = [
[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,_15354]]],[]]]]]],[]],
[ctMsrActor,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,_15791]]],[]]]]]],[]]
]

yes
"