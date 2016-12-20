@mankey
msrop(AetName,create,ValuesList,AValueOUT)
@arity
4
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrop"
@mainform
"msrop(AetName,create,ValuesList,AValueOUT)"
@parameter
"AetName
a bounded name of a declared enumeration type"
@parameter
"create
the name of the Messir operation for creating an enumerated type value"
@parameter
"ValuesList
a list of parameters to be used for the value creation"
@parameter
"AValueOUT
the newly created value"
@endparameters
@description
"is true if AValue is a list expression of type AetName that is built accordingly
to the Messim typed value representation (c.f. Messim chapter) and such that
to the enumerated value belongs to the declared enumeration."
@comment
"the bound property of AetName is not checked.
if ValuesList is an empty list then a free value is returned."
@example
"In the context of iCrashMini we would have:
1) 
?- msrop(etHumanKind,create,ValuesList,AValueOUT).
AValueOUT = [etHumanKind,anonym] ? 
yes
2)
?- msrop(etHumanKind,create,[victim],AValueOUT).
AValueOUT = [etHumanKind,victim] ? 
yes
3) 
?- msrop(etHumanKind,create,[valuenotchecked],AValueOUT).
no
4) msrop(AetName,create,[],AValueOUT).
AetName = etHumanKind,
AValueOUT = [etHumanKind,_A] ? 
yes
"
