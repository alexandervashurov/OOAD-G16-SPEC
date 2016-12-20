@mankey
newSystemClass(ClassName,ClassDef,PartRoleName,PartRoleCardinality)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newSystemClass"
@mainform
"newSystemClass(ClassName, ClassDef, [PartRoleName, PartRoleCardinality])"
@parameter
"ClassName
the name of the class type for a new system state type."
@parameter
"ClassDef
a list of attribute names with their types."
@parameter
"PartRoleName
the role name for class as part of the composition association 
with the ctState class."
@parameter
"PartRoleCardinality
the cardinality for the composition end."
@endparameters
@description
"a new system state type ClassName is introduced with attributes
defined in ClassDef. A new composition association is defined 
between ctState and ClassName such that the part end as
PartRoleName for role name and PartRoleCardinality for cardinality."
@comment
"the name of the association is automatically generated using the 
names of the associated classes."
@example
"newSystemClass(ctAlert,[ [kind,etHumanKind],
                            [id,dtAlertID],
                            [phoneNumber,dtPhoneNumber],
                            [comment,dtComment]
                          ],
                  [rnctAlert,['0','*']])."