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
    temp = reshape(repmat(SHPD, 3,1), 24,24);
    temp_e1 = temp(1:3,:); temp_e2 = temp(4:6,:); temp_e3 = temp(7:9,:); temp_e4 = temp(10:12,:);
    temp_e5 = temp(13:15,:); temp_e6 = temp(16:18,:); temp_e7 = temp(19:21,:); temp_e8 = temp(22:24,:);
    %% linear displacement-strain matrix eq. 3.151   
    BG1 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e1, 3,1), 1, 1, NE);
    BG2 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e2, 3,1), 1, 1, NE);
    BG3 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e3, 3,1), 1, 1, NE);
    BG4 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e4, 3,1), 1, 1, NE);
    BG5 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e5, 3,1), 1, 1, NE);
    BG6 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e6, 3,1), 1, 1, NE);
    BG7 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e7, 3,1), 1, 1, NE);
    BG8 = repmat([repmat([1 0 0],3, 8);repmat([0 1 0],3, 8);repmat([0 0 1],3, 8)].*repmat(temp_e8, 3,1), 1, 1, NE);
    %% Displacement and defortmation gradient
    % Nodal coordinates and incremental displacements
    % Local to global mapping
    GDOF = reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24);
    GDSP = DISPTD(GDOF)';
    GDSP=reshape(GDSP,NDOF,8,NE);
    % Interpolation factor
    gamma = reshape((tanh(beta*eta) + tanh(beta*(xPhys.^penal - eta))) / (tanh(beta * eta) + tanh(beta*(1-eta))),1,1, NE);
    GDSP_int = pagemtimes(gamma, GDSP);
    % Deformation gradient see eq. 3.5
    d0U = pagemtimes(GDSP, 'none', repmat(SHPD, 1, 1, NE), 'transpose');
    d0U_int = pagemtimes(GDSP_int, 'none', repmat(SHPD, 1, 1, NE), 'transpose');
    F_int = d0U_int + repmat(eye(3), 1, 8, NE);
    FT_int = pagetranspose(F_int);
    FT_int_e1 = FT_int(1:3,:,:); FT_int_e2 = FT_int(4:6,:,:); FT_int_e3 = FT_int(7:9,:,:); FT_int_e4 = FT_int(10:12,:,:);
    FT_int_e5 = FT_int(13:15,:,:); FT_int_e6 = FT_int(16:18,:,:); FT_int_e7 = FT_int(19:21,:,:); FT_int_e8 = FT_int(22:24,:,:);
    C_int = pagemtimes(FT_int, 'none', F_int, 'none');
    % Lagrangian strain eq. 3.10
    E_int = 0.5*(C_int-repmat(eye(24),1,1,NE));
    % split strain tensor into the parts for each integration point
    E_int1 = E_int(1:3,1:3,:); E_int2 = E_int(4:6,4:6,:); E_int3 = E_int(7:9,7:9,:); E_int4 = E_int(10:12,10:12,:); 
    E_int5 = E_int(13:15,13:15,:); E_int6 = E_int(16:18,16:18,:); E_int7 = E_int(19:21,19:21,:); E_int8 = E_int(22:24,22:24,:); 
    % infitismal (linear) strain tensor
    epsilon1 = 0.5*(d0U(:,1:3,:) + pagetranspose(d0U(:,1:3,:)));
    epsilon2 = 0.5*(d0U(:,4:6,:) + pagetranspose(d0U(:,4:6,:))); 
    epsilon3 = 0.5*(d0U(:,7:9,:) + pagetranspose(d0U(:,7:9,:))); 
    epsilon4 = 0.5*(d0U(:,10:12,:) + pagetranspose(d0U(:,10:12,:))); 
    epsilon5 = 0.5*(d0U(:,13:15,:) + pagetranspose(d0U(:,13:15,:))); 
    epsilon6 = 0.5*(d0U(:,16:18,:) + pagetranspose(d0U(:,16:18,:))); 
    epsilon7 = 0.5*(d0U(:,19:21,:) + pagetranspose(d0U(:,19:21,:))); 
    epsilon8 = 0.5*(d0U(:,22:24,:) + pagetranspose(d0U(:,22:24,:))); 
    epsilon_int1 = 0.5*(d0U_int(:,1:3,:) + pagetranspose(d0U_int(:,1:3,:)));
    epsilon_int2 = 0.5*(d0U_int(:,4:6,:) + pagetranspose(d0U_int(:,4:6,:))); 
    epsilon_int3 = 0.5*(d0U_int(:,7:9,:) + pagetranspose(d0U_int(:,7:9,:))); 
    epsilon_int4 = 0.5*(d0U_int(:,10:12,:) + pagetranspose(d0U_int(:,10:12,:))); 
    epsilon_int5 = 0.5*(d0U_int(:,13:15,:) + pagetranspose(d0U_int(:,13:15,:))); 
    epsilon_int6 = 0.5*(d0U_int(:,16:18,:) + pagetranspose(d0U_int(:,16:18,:))); 
    epsilon_int7 = 0.5*(d0U_int(:,19:21,:) + pagetranspose(d0U_int(:,19:21,:))); 
    epsilon_int8 = 0.5*(d0U_int(:,22:24,:) + pagetranspose(d0U_int(:,22:24,:)));
    %% nonlinear displacement-strain matrix eq. 3.142
    BN1 = [temp_e1.*repmat(FT_int_e1, 1, 8, 1); temp_e1.*repmat(circshift(FT_int_e1,[-1 0 0]), 1, 8, 1) + circshift(temp_e1,[-1 0 0]).*repmat(FT_int_e1, 1, 8, 1)];
    BN2 = [temp_e2.*repmat(FT_int_e2, 1, 8, 1); temp_e2.*repmat(circshift(FT_int_e2,[-1 0 0]), 1, 8, 1) + circshift(temp_e2,[-1 0 0]).*repmat(FT_int_e2, 1, 8, 1)];
    BN3 = [temp_e3.*repmat(FT_int_e3, 1, 8, 1); temp_e3.*repmat(circshift(FT_int_e3,[-1 0 0]), 1, 8, 1) + circshift(temp_e3,[-1 0 0]).*repmat(FT_int_e3, 1, 8, 1)];
    BN4 = [temp_e4.*repmat(FT_int_e4, 1, 8, 1); temp_e4.*repmat(circshift(FT_int_e4,[-1 0 0]), 1, 8, 1) + circshift(temp_e4,[-1 0 0]).*repmat(FT_int_e4, 1, 8, 1)];
    BN5 = [temp_e5.*repmat(FT_int_e5, 1, 8, 1); temp_e5.*repmat(circshift(FT_int_e5,[-1 0 0]), 1, 8, 1) + circshift(temp_e5,[-1 0 0]).*repmat(FT_int_e5, 1, 8, 1)];
    BN6 = [temp_e6.*repmat(FT_int_e6, 1, 8, 1); temp_e6.*repmat(circshift(FT_int_e6,[-1 0 0]), 1, 8, 1) + circshift(temp_e6,[-1 0 0]).*repmat(FT_int_e6, 1, 8, 1)];
    BN7 = [temp_e7.*repmat(FT_int_e7, 1, 8, 1); temp_e7.*repmat(circshift(FT_int_e7,[-1 0 0]), 1, 8, 1) + circshift(temp_e7,[-1 0 0]).*repmat(FT_int_e7, 1, 8, 1)];
    BN8 = [temp_e8.*repmat(FT_int_e8, 1, 8, 1); temp_e8.*repmat(circshift(FT_int_e8,[-1 0 0]), 1, 8, 1) + circshift(temp_e8,[-1 0 0]).*repmat(FT_int_e8, 1, 8, 1)];   
        %% Compute stress
    % assumption of plane stress
    plane_stress = [0 0 0;
                    0 1 1;
                    0 1 1;];
    tr = repmat(eye(3),1,1,NE);
    gplane_stress = repmat(plane_stress, 1, 1, NE);
    % second piola kirchhoff stress tensor (nonlinear)
    nintSTRESS_e1 = (lambda.*sum(E_int1.*tr, [1 2]) .* tr + 2*mu.*E_int1) .* gplane_stress; 
    nintSTRESS_e2 = (lambda.*sum(E_int2.*tr, [1 2]) .* tr + 2*mu.*E_int2) .* gplane_stress;
    nintSTRESS_e3 = (lambda.*sum(E_int3.*tr, [1 2]) .* tr + 2*mu.*E_int3) .* gplane_stress;
    nintSTRESS_e4 = (lambda.*sum(E_int4.*tr, [1 2]) .* tr + 2*mu.*E_int4) .* gplane_stress;
    nintSTRESS_e5 = (lambda.*sum(E_int5.*tr, [1 2]) .* tr + 2*mu.*E_int5) .* gplane_stress;
    nintSTRESS_e6 = (lambda.*sum(E_int6.*tr, [1 2]) .* tr + 2*mu.*E_int6) .* gplane_stress;
    nintSTRESS_e7 = (lambda.*sum(E_int7.*tr, [1 2]) .* tr + 2*mu.*E_int7) .* gplane_stress;
    nintSTRESS_e8 = (lambda.*sum(E_int8.*tr, [1 2]) .* tr + 2*mu.*E_int8) .* gplane_stress;
    lSTRESS_e1 = (lambda.*sum(epsilon1.*tr, [1 2]) .* tr + 2*mu.*epsilon1) .* gplane_stress; 
    lSTRESS_e2 = (lambda.*sum(epsilon2.*tr, [1 2]) .* tr + 2*mu.*epsilon2) .* gplane_stress;
    lSTRESS_e3 = (lambda.*sum(epsilon3.*tr, [1 2]) .* tr + 2*mu.*epsilon3) .* gplane_stress;
    lSTRESS_e4 = (lambda.*sum(epsilon4.*tr, [1 2]) .* tr + 2*mu.*epsilon4) .* gplane_stress;
    lSTRESS_e5 = (lambda.*sum(epsilon5.*tr, [1 2]) .* tr + 2*mu.*epsilon5) .* gplane_stress;
    lSTRESS_e6 = (lambda.*sum(epsilon6.*tr, [1 2]) .* tr + 2*mu.*epsilon6) .* gplane_stress;
    lSTRESS_e7 = (lambda.*sum(epsilon7.*tr, [1 2]) .* tr + 2*mu.*epsilon7) .* gplane_stress;
    lSTRESS_e8 = (lambda.*sum(epsilon8.*tr, [1 2]) .* tr + 2*mu.*epsilon8) .* gplane_stress; 
    lintSTRESS_e1 = (lambda.*sum(epsilon_int1.*tr, [1 2]) .* tr + 2*mu.*epsilon_int1) .* gplane_stress; 
    lintSTRESS_e2 = (lambda.*sum(epsilon_int2.*tr, [1 2]) .* tr + 2*mu.*epsilon_int2) .* gplane_stress;
    lintSTRESS_e3 = (lambda.*sum(epsilon_int3.*tr, [1 2]) .* tr + 2*mu.*epsilon_int3) .* gplane_stress;
    lintSTRESS_e4 = (lambda.*sum(epsilon_int4.*tr, [1 2]) .* tr + 2*mu.*epsilon_int4) .* gplane_stress;
    lintSTRESS_e5 = (lambda.*sum(epsilon_int5.*tr, [1 2]) .* tr + 2*mu.*epsilon_int5) .* gplane_stress;
    lintSTRESS_e6 = (lambda.*sum(epsilon_int6.*tr, [1 2]) .* tr + 2*mu.*epsilon_int6) .* gplane_stress;
    lintSTRESS_e7 = (lambda.*sum(epsilon_int7.*tr, [1 2]) .* tr + 2*mu.*epsilon_int7) .* gplane_stress;
    lintSTRESS_e8 = (lambda.*sum(epsilon_int8.*tr, [1 2]) .* tr + 2*mu.*epsilon_int8) .* gplane_stress; 
    STRESS_e1 = nintSTRESS_e1 + lSTRESS_e1 - lintSTRESS_e1;
    STRESS_e2 = nintSTRESS_e2 + lSTRESS_e2 - lintSTRESS_e2;
    STRESS_e3 = nintSTRESS_e3 + lSTRESS_e3 - lintSTRESS_e3;
    STRESS_e4 = nintSTRESS_e4 + lSTRESS_e4 - lintSTRESS_e4;
    STRESS_e5 = nintSTRESS_e5 + lSTRESS_e5 - lintSTRESS_e5;
    STRESS_e6 = nintSTRESS_e6 + lSTRESS_e6 - lintSTRESS_e6;
    STRESS_e7 = nintSTRESS_e7 + lSTRESS_e7 - lintSTRESS_e7;
    STRESS_e8 = nintSTRESS_e8 + lSTRESS_e8 - lintSTRESS_e8;
    % voigt notation of stress matrix
    STRESS_e1v = [zeros(1,1,NE); STRESS_e1(2,2,:); STRESS_e1(3,3,:); zeros(1,1,NE); STRESS_e1(2,3,:); zeros(1,1,NE)];
    STRESS_e2v = [zeros(1,1,NE); STRESS_e2(2,2,:); STRESS_e2(3,3,:); zeros(1,1,NE); STRESS_e2(2,3,:); zeros(1,1,NE)];
    STRESS_e3v = [zeros(1,1,NE); STRESS_e3(2,2,:); STRESS_e3(3,3,:); zeros(1,1,NE); STRESS_e3(2,3,:); zeros(1,1,NE)];
    STRESS_e4v = [zeros(1,1,NE); STRESS_e4(2,2,:); STRESS_e4(3,3,:); zeros(1,1,NE); STRESS_e4(2,3,:); zeros(1,1,NE)];
    STRESS_e5v = [zeros(1,1,NE); STRESS_e5(2,2,:); STRESS_e5(3,3,:); zeros(1,1,NE); STRESS_e5(2,3,:); zeros(1,1,NE)];
    STRESS_e6v = [zeros(1,1,NE); STRESS_e6(2,2,:); STRESS_e6(3,3,:); zeros(1,1,NE); STRESS_e6(2,3,:); zeros(1,1,NE)];
    STRESS_e7v = [zeros(1,1,NE); STRESS_e7(2,2,:); STRESS_e7(3,3,:); zeros(1,1,NE); STRESS_e7(2,3,:); zeros(1,1,NE)];
    STRESS_e8v = [zeros(1,1,NE); STRESS_e8(2,2,:); STRESS_e8(3,3,:); zeros(1,1,NE); STRESS_e8(2,3,:); zeros(1,1,NE)];
    %% compute internal force vector 
    gforce = DET*(pagemtimes(BN1,'transpose', STRESS_e1v, 'none') + pagemtimes(BN2,'transpose',STRESS_e2v,'none') + pagemtimes(BN3, 'transpose', STRESS_e3v,'none') ...
            + pagemtimes(BN4,'transpose', STRESS_e4v, 'none') + pagemtimes(BN5,'transpose',STRESS_e5v,'none') + pagemtimes(BN6, 'transpose', STRESS_e6v,'none') ...
            + pagemtimes(BN7,'transpose',STRESS_e7v,'none') + pagemtimes(BN8, 'transpose', STRESS_e8v,'none'));
    %% compute tangent stiffness  
    SHEAD1 = [nintSTRESS_e1 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e1 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e1];
    SHEAD2 = [nintSTRESS_e2 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e2 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e2];
    SHEAD3 = [nintSTRESS_e3 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e3 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e3];
    SHEAD4 = [nintSTRESS_e4 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e4 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e4];
    SHEAD5 = [nintSTRESS_e5 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e5 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e5];
    SHEAD6 = [nintSTRESS_e6 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e6 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e6];
    SHEAD7 = [nintSTRESS_e7 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e7 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e7];
    SHEAD8 = [nintSTRESS_e8 zeros(3,6,NE);zeros(3,3,NE) nintSTRESS_e8 zeros(3,3,NE); zeros(3,6,NE) nintSTRESS_e8];
    
    gstiff = DET*((pagemtimes(pagemtimes(BN1, 'transpose', ETAN, 'none'),BN1) + pagemtimes(pagemtimes(BG1, 'transpose', SHEAD1, 'none'),BG1)) ...
        + (pagemtimes(pagemtimes(BN2, 'transpose', ETAN, 'none'),BN2) + pagemtimes(pagemtimes(BG2, 'transpose', SHEAD2, 'none'),BG2)) ...
        + (pagemtimes(pagemtimes(BN3, 'transpose', ETAN, 'none'),BN3) + pagemtimes(pagemtimes(BG3, 'transpose', SHEAD3, 'none'),BG3)) ...
        + (pagemtimes(pagemtimes(BN4, 'transpose', ETAN, 'none'),BN4) + pagemtimes(pagemtimes(BG4, 'transpose', SHEAD4, 'none'),BG4)) ...
        + (pagemtimes(pagemtimes(BN5, 'transpose', ETAN, 'none'),BN5) + pagemtimes(pagemtimes(BG5, 'transpose', SHEAD5, 'none'),BG5)) ...
        + (pagemtimes(pagemtimes(BN6, 'transpose', ETAN, 'none'),BN6) + pagemtimes(pagemtimes(BG6, 'transpose', SHEAD6, 'none'),BG6)) ...
        + (pagemtimes(pagemtimes(BN7, 'transpose', ETAN, 'none'),BN7) + pagemtimes(pagemtimes(BG7, 'transpose', SHEAD7, 'none'),BG7)) ...
        + (pagemtimes(pagemtimes(BN8, 'transpose', ETAN, 'none'),BN8) + pagemtimes(pagemtimes(BG8, 'transpose', SHEAD8, 'none'),BG8)));
    %% assemble internal force vector and stiffness matrix     
    FORCE = fsparse(reshape(pagetranspose(GDOF), 24*NE, 1), 1, -reshape(pagetranspose(gforce), 24*NE, 1), [NEQ 1]);
    GKF = fsparse(reshape(repmat(GDOF, 1,24)', 576*NE, 1), reshape(repmat(reshape(GDOF',1, 24*NE), 24, 1), 1 , 576*NE)', reshape(gstiff, 576*NE ,1), [NEQ NEQ]);
end