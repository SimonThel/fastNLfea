function sensitivity = adjoint_lin(L, dforce, DECOM, GDOF, FREEDOF, NEQ, NE)
lambda = zeros(NEQ,1);
lambda(FREEDOF) = DECOM\L(FREEDOF);
lambda = reshape(lambda(GDOF)', 1,24,NE);
sensitivity = -reshape(pagemtimes(lambda, dforce), NE,1);