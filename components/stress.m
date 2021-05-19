%#codegen
function S = stress(lambda, mu, strain, NE)
tr = repmat(eye(3), 1, 1, NE, 8);
S = (repmat(lambda.*sum(strain.*tr, [1 2]),3,3,1,1) .* tr + 2*repmat(mu,3,3,1,1).*strain);