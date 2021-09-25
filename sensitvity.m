function dforce = sensitvity(DET, nu, E0, Emin, lambda, mu, xPhys, penal, eta, beta, NE, ...
    NDOF, LE, BN, E, E_int, epsilon_int, epsilon)
    % derivative of material parameters
    dE =  penal*xPhys.^(penal-1)*(E0-Emin);
    dlambda = repmat(reshape((nu*dE)/((1+nu)*(1-2*nu)), 1,1,[]),1,1,1,8);
    dmu = repmat(reshape(dE/(2*(1+nu)), 1, 1, []),1,1,1,8);
    %% Displacement and defortmation gradient
    % Nodal coordinates and incremental displacements
    % Local to global mapping
    GDOF = reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24);
    gamma = reshape((tanh(beta*eta) + tanh(beta*(xPhys.^penal - eta))) / (tanh(beta * eta) + tanh(beta*(1-eta))),1,1, NE);
        %% Compute stress
    % second piola kirchhoff stress tensor (nonlinear)
    dxSTRESS = stress(dlambda, dmu, E_int, NE) ... 
        + stress(dlambda, dmu, epsilon, NE) ...
        - stress(dlambda, dmu, epsilon_int, NE);
    % voigt notation of stress matrix
    dxSTRESS_v = [dxSTRESS(1,1,:,:); dxSTRESS(2,2,:,:); dxSTRESS(3,3,:,:); ...
        dxSTRESS(2,1,:,:); dxSTRESS(3,2,:,:); dxSTRESS(1,3,:,:)];
    %% compute internal force vector 
    dxforce = DET*sum(pagemtimes(BN,'transpose', dxSTRESS_v, 'none'),4);
    %% compute derivative of internal force vector w.r.t. projection factor gamma
    % second piola kirchhoff stress tensor (nonlinear)
    % second piola kirchhoff stress tensor (linear)
    % adding both stresses
    dgSTRESS = stress(lambda, mu, E, NE) - stress(lambda, mu, epsilon, NE);
    % voigt notation of stress matrix
    dgSTRESS_v = [dgSTRESS(1,1,:,:); dgSTRESS(2,2,:,:); dgSTRESS(3,3,:,:); ...
        dgSTRESS(2,1,:,:); dgSTRESS(3,2,:,:); dgSTRESS(1,3,:,:)];
    % compute internal force vector 
    dgforce = DET*sum(pagemtimes(BN,'transpose', dgSTRESS_v, 'none'),4);
    dgforce = 2*loopmtimes(gamma, dgforce);
    %% compute sensitivty of projection factor w.r.t. element density
    dx = reshape((beta * penal * xPhys.^(penal-1) .* sech(beta*(xPhys-eta)).^2) / (tanh(beta * eta) + tanh(beta*(1-eta))), 1,1, NE);
    dforce = dxforce + pagemtimes(dgforce,dx);
end