function xPhys = projX(xTilde, eta, beta)
xPhys = (tanh(beta*eta)+tanh(beta*(xTilde(:)-eta)))./(tanh(beta*eta)+tanh(beta*(1-eta)));