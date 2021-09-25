function sensitivity = adjoint_quad(L, dforce, DECOM, DISPTD, quad_move, GDOF, FREEDOF, NEQ, NE)
lambda = zeros(NEQ,1);
lambda(FREEDOF) = DECOM\L(FREEDOF);
lambda(FREEDOF) = 2*(L'*DISPTD-quad_move)*lambda(FREEDOF);
lambda = reshape(lambda(GDOF)', 1,24,NE);
sensitivity = -reshape(pagemtimes(lambda, dforce), NE,1);