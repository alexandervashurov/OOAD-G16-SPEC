@mankey
newAssociationParts(AssociationType,AssociationName,PartsList,PartsDefinitionOUT)
@arity
4
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newAssociationParts"
@mainform
"newAssociationParts(AssociationType, AssociationName, PartsList, PartsDefinitionOUT)"
@parameter
"AssociationType
an atom indicating the type of association "
@parameter
"AssociationName
an atom indicating the name of the association"
@parameter
"PartsList
A list of parts definition made of elements of form 
[ClasseName, RoleName, RoleType, CardMin, CardMax]."
@parameter
"PartsDefinitionOUT
a list of elements of type 'rtRelDefPart' "
@endparameters
@description
"is true if PartsDefinitionOUT is a list made of typed elements of type 'rtRelDefPart' 
built using Messim typed element creation using the values given for each element of 
PartsList."
@comment
"Association types are: association, composition, aggregation.
It is a sub predicate used in the newAssociation predicate."
@example
"In the context of iCrashMini we would have:
newAssociationParts( 
association, 
rtctAlertrnctAlertactComCompanyrnactComCompany, 
[[ctAlert,rnctAlert,associate,'0',*], 
 [actComCompany,rnactComCompany,associate,'1','1']],X).

X = 
[[rtRelDefPart,
   [[partEnd,[ptString,ctAlert]],
   [roleName,[ptString,rnctAlert]],
   [roleType,[ptString,associate]],
   [cardMin,[ptString,'0']],
   [cardMax,[ptString,*]]],[]],
 [rtRelDefPart,
   [[partEnd,
    [ptString,actComCompany]],
    [roleName,[ptString,rnactComCompany]],
    [roleType,[ptString,associate]],
    [cardMin,[ptString,'1']],
    [cardMax,[ptString,'1']]],[]]] 
yes

"