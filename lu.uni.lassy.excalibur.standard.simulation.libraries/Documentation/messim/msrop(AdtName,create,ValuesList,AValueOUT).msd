@mankey
msrop(AdtName,create,ValuesList,AValueOUT)
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
"msrop(AdtName,create,ValuesList,AValueOUT)"
@parameter
"AdtName
a bound name of a declared data type or class type."
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
"is true if AValue is a list expression of type AdtName that is built accordingly
to the Messim typed value representation (c.f. Messim chapter). The Prolog list structure
is recursively build by creating (using the 'msrop' predicate for creation) a typed value 
for each of the defined fields. The recursion follows the field hierarchy declared in the type definition
(i.e. level zero typed fields specific to the type AdtName and fields belonging 
to the declared list of supertypes)."
@comment
"both class types and data types use the same Prolog representation and thus share 
the same axiomatization for the creation of a value of their type. 
the bound property of AdtName is not checked.
ValuesList must either be a free variable or should contain more values than the number of fields
that can be deduced from the definition of AdtName. This list is consumed using a left deep first
approach to associate to the fields.
No type checking is made for the provide values in the list w.r.t. primitive types definitions.
"
@example
"In the context of iCrashMini we would have:
1) 
msrop(dtSecuredSMS,create,[key,aCryptedMessageValue],AValueOUT).
AValueOUT = 
[dtSecuredSMS,
[[key,[dtString,[[value,[ptString,key]]],[]]]],
[[dtSMS,[],[[dtString,[[value,[ptString,aCryptedMessageValue]]],[]]]]]] ? 
yes
2) In this example, notice the length of the values list and the non type checking for the boolean value.
?- msrop(ctState,create,[1,11,111,false],AValue).
AValue = 
[ctState,
[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,1]]],[]]]]],
[nextValueForAlertID,[ptInteger,11]],
[vpStarted,[ptBoolean,111]]],[]]
3) in this example, we show that having a variable as parameters list is equivalent to
create a new value with randomly selected bound values:
?- msrop(dtString,create,_,AValue).
AValue = [dtString,[[value,[ptString,iVFyEnzKt0labkQOJRMXHSefw]]],[]] ? 
yes
?- msrop(ctState,create,_,AValue), write(AValue).
AValue = 
[ctState,[[oid,[dtOID,[],[[dtInteger,[[value,[ptInteger,-21174]]],[]]]]],
[nextValueForAlertID,[ptInteger,-95836]],
[vpStarted,[ptBoolean,true]]],[]] ? 
yes
"