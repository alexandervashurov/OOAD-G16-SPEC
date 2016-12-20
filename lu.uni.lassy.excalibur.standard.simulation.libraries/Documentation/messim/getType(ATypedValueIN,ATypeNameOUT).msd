@mankey
getType(ATypedValueIN,ATypeNameOUT)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"getType"
@mainform
"getType(ATypedValueIN, ATypeNameOUT)"
@parameter
"ATypedValueIN
a bound typed value Messim representation"
@parameter
"ATypeNameOUT
an atom"
@endparameters
@description
"is true if ATypeNameOUT is the atom indicating the type of 
the value ATypedValueIN."
@comment
"ATypedValueIN can be a data type or a class type expression."
@example
"In the context of iCrashMini we would have:
?- getType([dtInteger,[[value,[ptInteger,34275]]],[]],Type).
Type = dtInteger ? 
yes
"