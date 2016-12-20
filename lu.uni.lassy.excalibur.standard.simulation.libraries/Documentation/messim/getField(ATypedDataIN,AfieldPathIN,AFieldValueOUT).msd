@mankey
getField(ATypedDataIN,AfieldPathIN,AFieldValueOUT)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getField"
@mainform
"getField(ATypedDataIN, AfieldPathIN, AFieldValueOUT)"
@parameter
"ATypedDataIN
a typed value defined according to the Messim representation"
@parameter
"AfieldPathIN
a list representing a path expression."
@parameter
"AFieldValueOUT
a typed value"
@endparameters
@description
"is true if a AFieldValueOUT is equal to the typed value for the field 
accessible following the path AfieldPathIN in the definition of ATypedDataIN."
@comment
"ATypedDataIN and AfieldPathIN cannot be variables.
the predicate is called recursively based on the field path definition and the value ATypedDataIN
definition. "
@example
"In the context of iCrashMini we would have:
msrop(dtSMS,new,[bound],V),getField(V, [value], AFieldValueOUT).

V = [dtSMS,[],[[dtString,[[value,[ptString,'Gk51bgnodVeQWmBU']]],[]]]],
AFieldValueOUT = [ptString,'Gk51bgnodVeQWmBU'] ? 
"