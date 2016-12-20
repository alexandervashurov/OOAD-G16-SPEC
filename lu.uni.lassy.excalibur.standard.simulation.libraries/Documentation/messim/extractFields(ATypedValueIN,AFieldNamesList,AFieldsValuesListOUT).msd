@mankey
extractFields(ATypedValueIN,AFieldNamesList,AFieldsValuesListOUT)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"extractFields"
@mainform
"extractFields(ATypedValueIN, AFieldNamesList, AFieldsValuesListOUT)"
@parameter
"ATypedValueIN
a typed value Messim representation"
@parameter
"AFieldNamesList
a list of lists of atoms"
@parameter
"AFieldsValuesListOUT
a list of typed value Messim representation"
@endparameters
@description
"is true if AFieldsValuesListOUT is a list of all the typed values for each
of the fields whose path is in AFieldNamesList and such that the value 
corresponds to the one extracted from ATypedValueIN."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
1) ?- extractFields([dtInteger,[[value,[ptInteger,34275]]],[]],
[value],L).
L = [dtInteger,[[value,[ptInteger,34275]]],[]] ? 
yes

2) ?- msrop(ctAlert,new,[bound],V),write(V),
extractFields(V,[[id,value]],L).

[ctAlert,
[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,44771]]],[]]]]],
[kind,[etHumanKind,anonym]],
[id,[dtAlertID,[[value,[ptInteger,64743]]],[]]],
[phoneNumber,[dtPhoneNumber,[],[[dtString,[[value,[ptString,F]]],[]]]]],
[comment,[dtComment,[],[[dtString,[[value,[ptString,XBhNdCGWmwqfLclKMEOSjTb]]],[]]]]]],[]]

L = [[ptInteger,64743]] ?
yes

"