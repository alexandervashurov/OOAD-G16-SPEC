%-----------------------------------------------------------------------------%
% Requires that the array 'x' is in increasing order (duplicates are allowed).
%-----------------------------------------------------------------------------%

include "sicstus.mzn";

predicate increasing_bool(array[int] of var bool: x) =
	  pairwise_relation_bool_sicstus(x, -1);


