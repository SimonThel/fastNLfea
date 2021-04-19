function assembly(nu, E0, Emin, xPhys, penal, beta, eta, NE, NEQ, NDOF, XYZ, LE)
%***********************************************************************
%  MAIN PROGRAM COMPUTING GLOBAL STIFFNESS MATRIX RESIDUAL FORCE 
%***********************************************************************
%%
  global DISPTD FORCE GKF
  %%
    % Simp penalization
    E = Emin + xPhys.^penal*(E0-Emin);
    % Lame constants
    lambda = reshape((nu*E)/((1+nu)*(1-2*nu)), 1,1,[]);
    mu = reshape(E/(2*(1+nu)), 1, 1, []);
    % assemble material properties into fourth order consitutive tensor
    % (matrxi representation)
    mu_mat = repmat(eye(3),1,1,NE).*repmat(mu,3,3,1);
    lambda_mat = repmat(lambda, 3, 3, 1);
    ETAN = [lambda_mat+2*mu_mat zeros(3,3,NE);
            zeros(3,3,NE) mu_mat];
  %% Integration points and weights
    XI = 0.57735026918963D0 *reshape([-1 -1 -1 -1  1  1  1  1;
                                      -1 -1  1  1 -1 -1  1  1;
                                      -1  1 -1  1 -1  1 -1  1], 24,1);
    XNODE=repmat([-1  1  1 -1 -1  1 1 -1; 
                  -1 -1  1  1 -1 -1 1  1;
                  -1 -1 -1 -1  1  1 1  1], 8, 1); 
  %% Calculate shape functions            
    QUAR = 0.125;
    XI0 = reshape(1 + repmat(XI,1,8).*XNODE, 3,64);
    XNODE = reshape(XNODE, 3 , 64);
    % derivative of shape functions
    DSF = reshape(QUAR*[XNODE(1,:).*XI0(2,:).*XI0(3,:); 
                XNODE(2,:).*XI0(1,:).*XI0(3,:); 
                XNODE(3,:).*XI0(1,:).*XI0(2,:)], 24,8);
    ELXY=XYZ(LE(1,:),:);
    J = DSF*ELXY; 
    % only calculate det of one part of GJ as regular mesh is used
    DET = det(J(1:3,1:3));
    SHPD = (eye(24).*repmat(diag(inv(J(1:3,1:3)))', 1, 8))*DSF;
    gSHPDT = pagetranspose(repmat(SHPD, 1, 1, NE));
    temp = pagetranspose(reshape(repmat(SHPD, 1,3)', 24,3,1,8));
    temp = temp(:,[1,9,17,2,10,18,3,11,19,4,12,20,5,13,21,6,14,22,7,15,23,8,16,24],:,:);
    %% linear displacement-strain matrix eq. 3.151   
    BG = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);...
        repmat([0 0 1],3, 8)].*repmat(temp, 3,1,1,1), 1, 1, NE, 1);
    %% Displacement and defortmation gradient
    % Nodal coordinates and incremental displacements
    % Local to global mapping
    GDOF = reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24);
    GDSP1 = DISPTD(GDOF)';
    GDSP=reshape(GDSP1,NDOF,8,NE); % sum(GDSP(:)) ~= 0
    % Interpolation factor
    gamma = reshape((tanh(beta*eta) + tanh(beta*(xPhys.^penal - eta))) / ...
        (tanh(beta * eta) + tanh(beta*(1-eta))),1,1, NE);
    GDSP_int = pagemtimes(gamma, GDSP);
    % Deformation gradient see eq. 3.5
    d0U = permute(reshape(permute(reshape(pagemtimes(GDSP, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    d0U_int = permute(reshape(permute(reshape(pagemtimes(GDSP_int, gSHPDT), ...
        [3 1 3 8 NE]), [1 3 2 4 5]), [3 3 8 NE]), [1 2 4 3]);
    F_int = d0U_int + repmat(eye(3), 1, 1, NE, 8);
    FT_int = pagetranspose(F_int);
    C_int = pagemtimes(FT_int, F_int);
    % Lagrangian strain eq. 3.10
    E_int = 0.5*(C_int-repmat(eye(3), 1, 1, NE, 8));
    % split strain tensor into the parts for each integration point
    % infitismal (linear) strain tensor
    epsilon = 0.5*(d0U+pagetranspose(d0U));
    epsilon_int = 0.5*(d0U_int+pagetranspose(d0U_int));
    %% nonlinear displacement-strain matrix eq. 3.142
    BN = [temp.*repmat(FT_int, 1, 8, 1, 1); ...
        temp.*repmat(circshift(FT_int,[-1 0 0 0]), 1, 8, 1, 1)...
        + circshift(temp,[-1 0 0 0]).*repmat(FT_int, 1, 8, 1, 1)];
    BNT = pagetranspose(BN);
        %% Compute stress
    % assumption of plane stress
    tr = repmat(eye(3), 1, 1, NE, 8);
    % second piola kirchhoff stress tensor (nonlinear)
    nintSTRESS = (lambda.*sum(E_int.*tr, [1 2]) .* tr + 2*mu.*E_int);
    lSTRESS = (lambda.*sum(epsilon.*tr, [1 2]) .* tr + 2*mu.*epsilon);
    lintSTRESS = (lambda.*sum(epsilon_int.*tr, [1 2]) .* tr + 2*mu.*epsilon_int);
    STRESS = nintSTRESS + lSTRESS - lintSTRESS;
    % voigt notation of stress matrix
    STRESSv = [zeros(1,1,NE, 8); STRESS(2,2,:,:); STRESS(3,3,:,:); zeros(1,1,NE, 8); STRESS(2,3,:,:); zeros(1,1,NE,8)];
    %% compute internal force vector 
    gforce = DET * sum(pagemtimes(BNT, STRESSv),4);
    %% compute tangent stiffness  
    SHEAD = [nintSTRESS zeros(3,6,NE,8); zeros(3,3,NE,8) nintSTRESS zeros(3,3,NE,8); zeros(3,6,NE,8) nintSTRESS];
    gstiff = DET*sum(pagemtimes(pagemtimes(BNT, repmat(ETAN,1,1,1,8)),BN) + pagemtimes(pagemtimes(BG, 'transpose', SHEAD, 'none'),BG),4);
    %% assemble internal force vector and stiffness matrix     
    FORCE = fsparse(reshape(pagetranspose(GDOF), 24*NE, 1), 1, ...
        - reshape(pagetranspose(gforce), 24*NE, 1), [NEQ 1]);
    GKF = fsparse(reshape(repmat(GDOF, 1,24)', 576*NE, 1), ...
        reshape(repmat(reshape(GDOF',1, 24*NE), 24, 1), 1 , 576*NE)', ...
        reshape(gstiff, 576*NE ,1), [NEQ NEQ]);
end