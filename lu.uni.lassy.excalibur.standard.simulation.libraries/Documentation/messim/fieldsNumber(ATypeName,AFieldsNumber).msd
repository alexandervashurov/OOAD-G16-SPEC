@mankey
fieldsNumber(ATypeName,AFieldsNumber)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"fieldsNumber"
@mainform
"fieldsNumber(ATypeName,AFieldsNumber)"
@parameter
"ATypeName
An atom representing a type name"
@parameter
"AFieldsNumber
An integer representing a quantity of fields"
@endparameters
@description
"is true if AFieldsNumber is the number of fields of ATypeName. If ATypeName
is a primitive type identifier then AFieldsNumber should be 0. If ATypeName
is a data type or a class type, AFieldsNumber should be equal to the number
of declared fields including the supertypes fields and the oid fields."
@comment
"there is no verification that ATypeName corresponds to an existing type
of the abstract machine for the current system."
@example
"1) 
?- fieldsNumber(notATypeName,N).
N = 0 ? 
yes
2) 
?- fieldsNumber(ptInteger,N).
N = 0 ? 
yes
3)
?- findall([T,N],fieldsNumber(T,N),L),samsort(L,SL),write(SL).
[[ctAlert,5],
[actComCompany,2],
[inactComCompany,2],
[outactComCompany,2],
[ctInputInterface,1],[ctMsrActor,1],
[actMsrCreator,2],
[inactMsrCreator,2],
[outactMsrCreator,2],
[ctOutputInterface,1],
[ctState,3],
[dtAlertID,1],
[dtComment,1],
[dtInteger,1],
[dtString,1],
[dtOID,1],
[dtPhoneNumber,1],
[dtSMS,1],
[rtRelDefPart,5]]
"