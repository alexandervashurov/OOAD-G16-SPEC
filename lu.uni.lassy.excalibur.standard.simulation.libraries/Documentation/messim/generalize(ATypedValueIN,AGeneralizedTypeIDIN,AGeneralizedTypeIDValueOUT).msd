@mankey
generalize(ATypedValueIN,AGeneralizedTypeIDIN,AGeneralizedTypeIDValueOUT)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"generalize"
@mainform
"generalize(ATypedValueIN, AGeneralizedTypeIDIN, AGeneralizedTypeIDValueOUT)"
@parameter
"ATypedValueIN
a data type value using the Messim data type value representation"
@parameter
"AGeneralizedTypeIDIN
a type name"
@parameter
"AGeneralizedTypeIDValueOUT
a data type value using the Messim data type value representation"
@endparameters
@description
"is true if AGeneralizedTypeIDValueOUT is the Messim data type value representation
of type ATypedValueIN such that this value is of type AGeneralizedTypeIDIN."
@comment
"It is supposed that ATypedValueIN is a subtype of AGeneralizedTypeIDIN.
The generalization of a typed value to its own type as supertype is considered 
true when the generalized value is the same as the initial typed value. 
This property could be argued against but it is a convention for the Messim engine. 
The generalization of an empty type (no attribute at all) to itself is false.
In case of multiple inheritance trees in which the same type appears as a super type, 
then the generalization is true for the first declared supertype value in the list."
@example
"In the context of iCrashMini we would have:
?- generalize(
     [dtSMS,[],[[dtString,[[value,[ptString,rtKIewj3]]],[]]]],
     dtString,
     Value).
Value = [dtString,[[value,[ptString,rtKIewj3]]],[]] ?
yes

"