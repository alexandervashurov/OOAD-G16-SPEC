@mankey
substituteSuperTypeObject(AnObject,ASuperTypeObject,ASubstitutedObject)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"substituteSuperTypeObject"
@mainform
"substituteSuperTypeObject(AnObject, ASuperTypeObject, ASubstitutedObject)"
@parameter
"AnObject
a data type value using the Messim data type value representation"
@parameter
"ASuperTypeObject
a data type value using the Messim data type value representation"
@parameter
"ASubstitutedObject
a data type value using the Messim data type value representation"
@endparameters
@description
"is true if ASubstitutedObject is a value equal to AnObject in which all 
the objects of same type than the type of ASuperTypeObject have
been replaced by ASuperTypeObject."
@comment
"If AnObject and ASuperTypeObject are of same type than ASubstitutedObject 
must be equal to ASuperTypeObject.
In case AnObject is a multiple subtype of the same supertype that the type of 
ASuperTypeObject then all those super type objects are substituted. 
Nevertheless, this is currently not used in Messim."
@example
"In the context of iCrashMini we would have:
?- msrop(dtSMS,new,[bound],X), 
   msrop(dtString,new,[bound],Y),
   substituteSuperTypeObject(X,Y,Z).
X = [dtSMS,[],[[dtString,[[value,[ptString,rg]]],[]]]],
Y = [dtString,[[value,[ptString,pN3MuF9]]],[]],
Z = [dtSMS,[],[[dtString,[[value,[ptString,pN3MuF9]]],[]]]] ? 
yes"