function [FORCE, GKF] = assembly(DISPTD, xPhys, penal, beta, eta, NE, NEQ, NDOF, LE, lambda, mu, ETAN, DET, BG, gSHPDT, temp)
%***********************************************************************
%  MAIN PROGRAM COMPUTING GLOBAL STIFFNESS MATRIX RESIDUAL FORCE 
%***********************************************************************
%%
    %% Displacement and defortmation gradient
    % Nodal coordinates and incremental displacements
    % Local to global mapping
    GDOF = reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24);
    GDSP1 = DISPTD(GDOF)';
    GDSP=reshape(GDSP1,NDOF,8,NE); % sum(GDSP(:)) ~= 0
    % Interpolation factor
    gamma = reshape((tanh(beta*eta) + tanh(beta*(xPhys.^penal - eta))) / ...
        (tanh(beta * eta) + tanh(beta*(1-eta))),1,1, NE);
    GDSP_int = repmat(gamma, 3, 8, 1).*GDSP;
    % Deformation gradient see eq. 3.5
    d0U = permute(reshape(permute(reshape(pagemtimes(GDSP, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    d0U_int = permute(reshape(permute(reshape(pagemtimes(GDSP_int, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    F_int = d0U_int + repmat(eye(3), 1, 1, NE, 8);
    FT_int = permute(F_int, [2 1 3 4]);
    C_int = pagemtimes(FT_int, F_int);
    % Lagrangian strain eq. 3.10
    E_int = 0.5*(C_int-repmat(eye(3), 1, 1, NE, 8));
    % split strain tensor into the parts for each integration point
    % infitismal (linear) strain tensor
    epsilon = 0.5*(d0U+permute(d0U,[2 1 3 4]));
    epsilon_int = 0.5*(d0U_int+permute(d0U_int, [2 1 3 4]));
    %% nonlinear displacement-strain matrix eq. 3.142
    BN = [temp.*repmat(FT_int, 1, 8, 1, 1); ...
        temp.*repmat(circshift(FT_int,[-1 0 0 0]), 1, 8, 1, 1)...
        + circshift(temp,[-1 0 0 0]).*repmat(FT_int, 1, 8, 1, 1)];
    %BNT = permute(BN,[2 1 3 4]);
        %% Compute stress
    % assumption of plane stress
    tr = repmat(eye(3), 1, 1, NE, 8);
    % second piola kirchhoff stress tensor (nonlinear)
    nintSTRESS = (repmat(lambda.*sum(E_int.*tr, [1 2]),3,3,1,1) .* tr + 2*repmat(mu,3,3,1,1).*E_int);
    lSTRESS = (repmat(lambda.*sum(epsilon.*tr, [1 2]),3,3,1,1) .* tr + 2*repmat(mu,3,3,1,1).*epsilon);
    lintSTRESS = (repmat(lambda.*sum(epsilon_int.*tr, [1 2]),3,3,1,1) .* tr + 2*repmat(mu,3,3,1,1).*epsilon_int);
    STRESS = nintSTRESS + lSTRESS - lintSTRESS;
    % voigt notation of stress matrix
    STRESSv = [STRESS(1,1,:,:); STRESS(2,2,:,:); STRESS(3,3,:,:); ...
        STRESS(2,1,:,:); STRESS(3,2,:,:); STRESS(1,3,:,:)];
    %% compute internal force vector 
    gforce = DET * sum(pagemtimes(BN,'transpose', STRESSv,'none'),4);
    %% compute tangent stiffness  
    SHEAD = [nintSTRESS zeros(3, 6, NE, 8); ...
        zeros(3, 3, NE, 8) nintSTRESS zeros( 3, 3, NE, 8); ...
        zeros(3, 6, NE, 8) nintSTRESS];
    gstiff = DET*sum(pagemtimes(pagemtimes(BN,'transpose', ETAN,'none'),BN) ...
        + pagemtimes(pagemtimes(BG, 'transpose', SHEAD, 'none'),BG),4);
    %% assemble internal force vector and stiffness matrix     
    FORCE = fsparse(reshape(permute(GDOF,[2 1 3 4]), 24*NE, 1), 1, ...
        - reshape(permute(gforce,[2 1 3 4]), 24*NE, 1), [NEQ 1]);
    GKF = fsparse(reshape(repmat(GDOF, 1,24)', 576*NE, 1), ...
        reshape(repmat(reshape(GDOF',1, 24*NE), 24, 1), 1 , 576*NE)', ...
        reshape(gstiff, 576*NE ,1), [NEQ NEQ]);
end