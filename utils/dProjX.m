function dx = dProjX(x, eta, beta)

dx = beta*(1-tanh(beta*(x-eta)).^2)./(tanh(beta*eta)+tanh(beta*(1-eta)));