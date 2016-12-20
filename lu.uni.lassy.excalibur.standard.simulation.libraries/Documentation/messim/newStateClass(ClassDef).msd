@mankey
newStateClass(ClassDef)
@arity
1
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"newStateClass"
@mainform
"newStateClass(ClassDef)"
@parameter
"ClassDef
a parameters definition list"
@endparameters
@description
"declares a new class type ctState with 
ClassDef as attributes definition. 
The state class which is a special class since its name 
must not be free to be defined (i.e. it must be ctState), 
we thus use a specific Prolog predicate instead of 
using directly the newType predicate. 
Furthermore we cannot use the newSystemClass predicate since 
there cannot be an aggregation relation in between ctState and itself.
The attributes list is provided in terms of couples made 
of an attribute name and an attribute type."
@comment
"N.A."
@example
"In the context of iCrashMini we would have:
   newStateClass([ [nextValueForAlertID,ptInteger],
                   [vpStarted,ptBoolean]
                 ])."