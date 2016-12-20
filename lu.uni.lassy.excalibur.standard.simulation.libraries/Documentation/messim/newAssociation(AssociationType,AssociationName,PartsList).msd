@mankey
newAssociation(AssociationType,AssociationName,PartsList)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newAssociation"
@mainform
"newAssociation(AssociationType, AssociationName, PartsList)"
@parameter
"AssociationType
a bound term representing the type of association (see Messir book)"
@parameter
"AssociationName
an atom defining the name for the association"
@parameter
"PartsList
a bound term representing the list of all association parts definition as values of type 'rtRelDefPart'."
@endparameters
@description
"adds a new relation type in list of relation types satisfying the dynamic 
predicate 'relationTypes'. The new value added is a tuple made of the AssociationType,
the AssociationName, a list of all the associated class type name for each association end
and the parts definition list PartsDefinitions."
@comment
"If AssociationName is a variable at satisfaction time then is it unified with the concatenation 
of all the atoms made of the part class names and role names.
PartsList should not be a variable or an empty list."
@example
"In the context of iCrashMini we would have:
:- newAssociation(
    association,
    VAR,
    [ [ctAlert,rnctAlert,associate,'0','*'],
      [actComCompany,rnactComCompany,associate,'1','1']
    ]).
VAR = rtctAlertrnctAlertactComCompanyrnactComCompany

"