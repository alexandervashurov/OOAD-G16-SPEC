@mankey
setField(ATypedDataIN,AfieldPathIN,AValueIN,ATypedDataOUT)
@arity
4
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"setField"
@mainform
"setField(ATypedDataIN, AfieldPathIN, AValueIN, ATypedDataOUT)"
@parameter
"ATypedDataIN
a typed value defined according to the Messim representation"
@parameter
"AfieldPathIN
a list representing a path expression."
@parameter
"AValueIN
a typed value "
@parameter
"ATypedDataOUT
a typed value "
@endparameters
@description
"is true if a ATypedDataOUT is equal to ATypedDataIN in which the typed value for the field 
accessible following the path AfieldPathIN is equal to AValueIN."
@comment
"ATypedDataIN and AfieldPathIN cannot be variables.
the predicate is called recursively based on the field path definition and the value ATypedDataIN
definition. "
@example
"In the context of iCrashMini we would have:
?- msrop(dtSMS,new,[bound],V),msrop(dtString,new,[bound],S),
write(V),write(S),setField(V, [value], S, ATypedDataOUT), write(ATypedDataOUT).

V = [dtSMS,[],[[dtString,[[value,[ptString,hwisoCyfj]]],[]]]]
S = [dtString,[[value,[ptString,0OmAxdI7]]],[]]
ATypedDataOUT = [dtSMS,[],[[dtString,[[value,[dtString,[[value,[ptString,0OmAxdI7]]],[]]]],[]]]]
 ? 
yes"