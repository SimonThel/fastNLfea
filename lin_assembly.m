function [lambda, mu, ETAN, DET, BG, gSHPDT, temp] = lin_assembly(nu, E, Emin, xPhys, penal, NE, XYZ, LE)
  %%
    % Simp penalization
    E = Emin + xPhys.^penal*(E-Emin);
    % Lame constants
    lambda = repmat(reshape((nu*E)/((1+nu)*(1-2*nu)), 1,1,NE),1,1,1,8);
    mu = repmat(reshape(E/(2*(1+nu)), 1, 1, NE),1,1,1,8);
    % assemble material properties into fourth order consitutive tensor
    % (matrxi representation)
    mu_mat = repmat(eye(3),1,1,NE,8).*repmat(mu,3,3,1,1);
    lambda_mat = repmat(lambda, 3, 3, 1,1);
    ETAN = [lambda_mat+2*mu_mat zeros(3,3,NE,8);
            zeros(3,3,NE,8) mu_mat];
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
    SHPD = (eye(24).*repmat(diag(inv(J(1:3,1:3)))', 24, 8))*DSF;
    gSHPDT = repmat(SHPD, 1, 1, NE);
    gSHPDT = permute(gSHPDT,[2 1 3]);
    temp = permute(reshape(repmat(SHPD, 1,3)', 24,3,1,8), [2 1 3 4]);
    temp = repmat(temp(:,[1,9,17,2,10,18,3,11,19,4,12,20,5,13,21,6,14,22,7,15,23,8,16,24],:,:),1,1,NE,1);
    %% linear displacement-strain matrix eq. 3.151   
    BG = [repmat([1 0 0],3, 8, NE, 8);repmat([0 1 0],3, 8, NE, 8);...
        repmat([0 0 1],3, 8, NE, 8)].*repmat(temp, 3,1,1,1);