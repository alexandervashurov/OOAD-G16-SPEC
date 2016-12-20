@mankey
buildFieldsPath(FieldName,AFieldsList,FirstLevelFields)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"buildFieldsPath"
@mainform
"buildFieldsPath(FieldName, AFieldsList, FirstLevelFields)"
@parameter
"FieldName
an atom"
@parameter
"AFieldsList
a list of lists of atoms"
@parameter
"FirstLevelFields
a list of a list of atoms"
@endparameters
@description
"is true if FirstLevelFields is a flat list starting by FieldName and followed by 
all the atoms in the lists of AFieldsList. "
@comment
"FirstLevelFields corresponds to a Messim field path."
@example
"In the context of iCrashMini we would have:
?- buildFieldsPath(comment, [[value]],P).
P = [[comment,value]] ? 

"