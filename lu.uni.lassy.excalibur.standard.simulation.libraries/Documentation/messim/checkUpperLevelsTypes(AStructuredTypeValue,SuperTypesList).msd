@mankey
checkUpperLevelsTypes(AStructuredTypeValue,SuperTypesList)
@arity
2
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"checkUpperLevelsTypes"
@mainform
"checkUpperLevelsTypes(AStructuredTypeValue, SuperTypesList)"
@parameter
"AStructuredTypeValue
a typed value Messim representation"
@parameter
"SuperTypesList
A list of type names"
@endparameters
@description
"is true if AStructuredTypeValue is a subtype of each type in SuperTypesList."
@comment
"for each super type of SuperTypesList, AStructuredTypeValue is generalyzed 
and the corresponding value should be of the correct type."
@example
"In the context of iCrashMini we would have:
?- msrop(dtSMS,new,[bound],V), checkUpperLevelsTypes(V,[dtString]).
V = [dtSMS,[],[[dtString,[[value,[ptString,'5WL3DTK6']]],[]]]] ? 
yes
"