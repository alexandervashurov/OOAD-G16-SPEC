@mankey
newOperation(AType,AnOperationName,AParametersList)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newOperation"
@mainform
"newOperation(AType,AnOperationName, AParametersList)"
@parameter
"AType
a type name"
@parameter
"AnOperationName
an operation name"
@parameter
"AParametersList
a list if parameter's types"
@endparameters
@description
"declares a new operation AnOperationName associated to the type AType and having
AParametersList as parameters signature."
@comment
"the dynamic predicate that is used to store the declared operations is 'operations/1'."
@example
"In the context of iCrashMini we would have operation(List) true with a list that
would contain, as an illustration, the following operations:
[ctAlert,init,[[dtAlertID,dtPhoneNumber,dtComment],[ctAlert]]]
[actComCompany,init,[[],[actComCompany]]]
[inactComCompany,ieSmsSend,[[[aPhoneNumber,dtPhoneNumber],[aSMS,dtSMS]],[]]]
[inactComCompany,init,[[],[inactComCompany]]]
[outactComCompany,init,[[],[outactComCompany]]]
[outactComCompany,oeAlert,[[[kind,dtHumanKind],[aPhoneNumber,dtPhoneNumber],[aComment,dtComment]],[]]]
[actMsrCreator,init,[[],[actMsrCreator]]]
[inactMsrCreator,init,[[],[inactMsrCreator]]]
[outactMsrCreator,init,[[],[outactMsrCreator]]]
[outactMsrCreator,oeCreateSystemAndEnvironment,[[[qtyComCompanies,ptInteger]],[]]]
[ctState,init,[[ptInteger,ptBoolean],[ctState]]]
[dtComment,is,[[dtComment],[]]]
[dtInteger,eq,[[dtInteger,dtInteger],[]]]
[dtInteger,geq,[[dtInteger,dtInteger],[]]]
[dtInteger,leq,[[dtInteger,dtInteger],[]]]
[dtString,length,[[dtString],[ptInteger]]]
[dtString,myStringConcat,[[dtString,dtString],[dtString]]]
[dtOID,is,[[dtOID],[]]]
[dtPhoneNumber,is,[[dtPhoneNumber],[]]]
[ptInteger,add,[[ptInteger,ptInteger],[ptInteger]]]
[ptInteger,eq,[[ptInteger,ptInteger],[]]]
[ptInteger,geq,[[ptInteger,ptInteger],[]]]
[ptInteger,leq,[[ptInteger,ptInteger],[]]]
[ptInteger,toptReal,[[ptInteger,ptInteger],[ptReal]]]
"