@mankey
msrSolve(consistentMessamExpansion,_,_)
@arity
3
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"msrSolve"
@mainform
"msrSolve(consistentMessamExpansion,[Dimension,ATypeName],AValuesList)"
@parameter
"[Dimension,ATypeName]"
@parameter
"A dimension for the abstract machine (i.e. classes or relations
with a type name belonging to this dimension."
@parameter
"AValuesList
a list of values of type ATypeName."
@endparameters
@description
"adds to the Messam abstract machine all the values given in AValuesList
in the correct dimension determined by [Dimension,ATypeName]. This expansion
is made consistently w.r.t. composition associations with the sate class in
case of class instances."
@comment
"N.A."
@example
"N.A.
"