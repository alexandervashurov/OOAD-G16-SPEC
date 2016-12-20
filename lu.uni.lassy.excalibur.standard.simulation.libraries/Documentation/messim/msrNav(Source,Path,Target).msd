@mankey
msrNav(Source,Path,Target)
@arity
3
@author
"NG"
@date
"[12,07,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrNav"
@mainform
"msrNav(Source,Path,Target)"
@parameter
"Source
a list of typed value defined according to the Messim representation"
@parameter
"Path
a list representing a navigation path."
@parameter
"Target
a list of typed value"
@endparameters
@description
"is true if Target is the list of all typed values that can be reached by navigating 
from Source until the end of the navigation path Path."
@comment
"1) For each value in the list Source, it is collected the values reachable at navigation path end.
2) the msrNav predicate is split in 9 axioms. 
- axiom 01: navigating from a source along an empty path reaches the source.
- axiom 02: if Source is an object and Path is a list made of an output name followed by 
the list of parameters for this event then msrNav is true if Result is the value satisfying 
the msrSim predicate applied to the object value for its outputEvent belonging to its output
interface. (In addition the listing of the Messim abstract machine together with the 
evolution histories listing are produced.
- axiom 03: "
@example
"In the context of iCrashMini we would have:
N.A.
"