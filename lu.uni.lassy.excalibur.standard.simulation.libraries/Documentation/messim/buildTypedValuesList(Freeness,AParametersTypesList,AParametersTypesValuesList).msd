@mankey
buildTypedValuesList(Freeness,ATypesList,AValuesList)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"buildTypedValuesList"
@mainform
"buildTypedValuesList(Freeness, ATypesList, AValuesList)"
@parameter
"Freeness
indication of the way to create new typed values"
@parameter
"ATypesList
a list of types"
@parameter
"AValuesList
A list of typed values"
@endparameters
@description
"is true if AValuesList is a list of values typed accordingly to the 
list of types existing in ATypesList and such that each value can 
be obtained using the new operation defined for its type following
the Freeness indicator."
@comment
"Makes use of the Messim operation 'new' for each type.
If Freeness contains values then they will be used for all types in the ATypesList and
No type checking is made for the provide values in the list w.r.t. the type definition."
@example
"In the context of iCrashMini we would have:
1) 
?- buildTypedValuesList([bound],[dtString,dtSMS],AValuesList).
AValuesList = 
[[dtString,[[value,[ptString,'J3ev5tzsNd8YOm']]],[]],
 [dtSMS,[],[[dtString,[[value,[ptString,'BId6mJENMvnk7yD']]],[]]]]] ? 
;
no
2)
?- buildTypedValuesList(Freeness,[dtString,dtSMS],AValuesList).
Freeness = [free],
AValuesList = 
[[dtString,[[value,[ptString,_A]]],[]],
 [dtSMS,[],[[dtString,[[value,[ptString,_B]]],[]]]]] ? ;
no
3) 
?- buildTypedValuesList(['hello world'],[dtString,dtString],AValuesList).
AValuesList = 
[[dtString,[[value,[ptString,'hello world']]],[]],
 [dtString,[[value,[ptString,'hello world']]],[]]] ? ;
no
"