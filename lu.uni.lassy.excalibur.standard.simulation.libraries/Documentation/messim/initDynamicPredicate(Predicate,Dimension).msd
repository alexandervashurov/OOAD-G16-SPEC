@mankey
initDynamicPredicate(Predicate,Dimension)
@arity
2
@author
"NG"
@date
"[12,04,03]"
@file
"02_msrMetaModel.pl"
@predicate
"initDynamicPredicate"
@mainform
"initDynamicPredicate(Predicate,Dimension)"
@parameter
"Predicate
a name of a predicate"
@parameter
"Dimension
a natural number"
@endparameters
@description
"declares at resolution time a new dynamic predicate 'Predicate' having 
'Dimension' as arity. The declaration is twice, one for the Prolog engine 
and one for the specific knowledge base handled by the Messir simulator. "
@comment
"Uses a temporary file to dynamically write the declarations to be consulted by
 the Prolog engine."
@example
"In the context of iCrashMini we would have:
we would have:
?- allDynamicPredicates(L), write(L).
L = [
[commentData,2],[commentHeader,2],
[evolution,1],[protectedOperations,1],
[operations,1],[outputEvents,1],
[inputEvents,1],[interfaceTypes,1],
[actorTypes,1],[classTypes,1],
[subTypes,1],[relationTypes,1],
[dataTypes,1],[enumerationTypes,1],
[primitiveTypes,1],[messam,4],
[lastMessamVersion,1],[currentMessamVersion,1],
[nextObjectID,1]] ? 
yes
"