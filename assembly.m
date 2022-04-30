function [GKF, FORCE, BN, E, E_int, epsilon_int, epsilon] = assembly(DISPTD, xPhys, penal, beta, eta, NE, NEQ, NDOF, LE, lambda, mu, ETAN, DET, BG, gSHPDT, temp, iK, jK, lK)
%***********************************************************************
%  MAIN PROGRAM COMPUTING GLOBAL STIFFNESS MATRIX RESIDUAL FORCE 
%***********************************************************************
    %% Displacement and defortmation gradient
    % Nodal coordinates and incremental displacements
    % Local to global mapping
    GDOF = reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24);
    GDSP=reshape(DISPTD(GDOF)',NDOF,8,NE);
    % Interpolation factor
    gamma = reshape((tanh(beta*eta) + tanh(beta*(xPhys.^penal - eta))) / ...
        (tanh(beta * eta) + tanh(beta*(1-eta))),1,1, NE);
    GDSP_int = repmat(gamma, 3, 8, 1).*GDSP;
    % Deformation gradient 
    d0U = permute(reshape(permute(reshape(pagemtimes(GDSP, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    d0U_int = permute(reshape(permute(reshape(pagemtimes(GDSP_int, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    F = d0U + repmat(eye(3), 1, 1, NE, 8);
    F_int = d0U_int + repmat(eye(3), 1, 1, NE, 8);
    FT_int = permute(F_int, [2 1 3 4]);
    % Lagrangian strain
    E = 0.5*(pagemtimes(F, 'transpose', F, 'none') - repmat(eye(3), 1, 1, NE, 8));
    E_int = 0.5*(pagemtimes(FT_int, F_int) - repmat(eye(3), 1, 1, NE, 8));
    % split strain tensor into the parts for each integration point
    % infitismal (linear) strain tensor
    epsilon = 0.5*(d0U+permute(d0U,[2 1 3 4]));
    epsilon_int = 0.5*(d0U_int+permute(d0U_int, [2 1 3 4]));
    %% nonlinear displacement-strain matrix
    BN = nlStrainDisplacment(temp, FT_int);
    %% Compute stress
    % second piola kirchhoff stress tensor
    nintSTRESS = stress(lambda, mu, E_int, NE);
    STRESS = nintSTRESS + stress(lambda, mu, epsilon, NE) ...
        - stress(lambda, mu, epsilon_int, NE);
    % voigt notation of stress matrix
    STRESSv = [STRESS(1,1,:,:); STRESS(2,2,:,:); STRESS(3,3,:,:); ...
        STRESS(2,1,:,:); STRESS(3,2,:,:); STRESS(1,3,:,:)];
    %% compute internal force vector 
    gforce = DET * sum(pagemtimes(BN,'transpose', STRESSv,'none'),4);
    FORCE = sparse(lK, 1, double(-reshape(permute(gforce,[2 1 3 4]), 24*NE, 1)), double(NEQ), 1);
    %% compute tangent stiffness  
    gstiff = DET*sum(pagemtimes(pagemtimes(BN,'transpose', ETAN,'none'),BN) ...
        + pagemtimes(pagemtimes(BG, 'transpose', SIGMA(nintSTRESS, NE), 'none'),BG),4);
    GKF = sparse(iK, jK, double(reshape(gstiff, 576*NE ,1)), double(NEQ), double(NEQ));
end