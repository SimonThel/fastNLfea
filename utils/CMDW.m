function decay = CMDW(iter, itermax, q, i_crit, r, s)
beta = pow2(2,q);
eta = i_crit/itermax;
x = iter/itermax;
decay = r*(-(1)*(tanh(beta*eta) + tanh(beta*(x - eta))) / (tanh(beta * eta) + tanh(beta*(1-eta)))+1)+s;