% Nodal coordinates
clc
clear
close all
% nelx = 1, nely = 15, nelz = 5
nelx = 1;
nely = 15;
nelz = 5;

nnodes = (nelx+1)*(nely+1)*(nelz+1);
XYZ = zeros(nnodes,3);

coord = [nelx, 0, 0];
for n=1:nnodes
    XYZ(n,:) = coord;
    if coord(2)<nely
        coord(2) = coord(2) + 1;
    elseif coord(2) == nely && coord(3) < nelz
        coord(2) = 0;
        coord(3) = coord(3) + 1;
    elseif coord(2) == nely && coord(3) == nelz
        coord(1) = coord(1) - 1;
        coord(2) = 0;
        coord(3) = 0;
    end
end

nEl = nelx * nely * nelz;                                                  
nodeNrs = ( reshape( 1 : ( 1 + nelx ) * ( 1 + nely ) * ( 1 + nelz ), ...
    1 + nely, 1 + nelz, 1 + nelx ) );         
madVec = reshape( nodeNrs( 1 : nely, 1 : nelz, 1 : nelx ) + 1, nEl, 1 );
madMat = madVec+([0, (nely+1)*(nelz+1)+[0,-1], -1, (nely+1)+[0], (nely+1)*(nelz+2)+[0, -1],(nely+1)+[-1]]);             
%
% Element connectivity 
LE=madMat; 
%
% External forces [Node, DOF, Value]
nodal_force = 5;
%
% Prescribed displacements [Node, DOF, Value]
EXTFORCE = [];
SDISPT = [];
for n=1:nnodes
    if XYZ(n,3) == nelz
        EXTFORCE = [EXTFORCE; n 3 nodal_force];
    end
    if XYZ(n,2) == 0
       SDISPT = [SDISPT; n 1 0];
       SDISPT = [SDISPT; n 2 0];
       SDISPT = [SDISPT; n 3 0];
    else
       SDISPT = [SDISPT; n 1 0];
    end
end
%
% Load increments [Start End Increment InitialFactor FinalFactor]
TIMS=[0.0 1 1 0.0 1.0]';
%
% Material properties
nu = 0.3; E0 = 10920; Emin = 1e-6;
%´
x = reshape(repmat(0.5,nEl, 1), nelx, nely, nelz);
for i=1:nelx
    for j=1:nely
        for k=1:nelz
            if  j <= 1 
                x(i,j,k) = 1;
                
            elseif j >= 15
                x(i,j,k) = 1;
                
            elseif k <= 1
                x(i,j,k) = 1;
                
            elseif k >= 5
                x(i,j,k) = 1;
            elseif k<=4 && k>=2 && j<=10 && j>=8
                x(i,j,k) = 0;
            end
        end
    end
end
x = reshape(x,[],1);
%x = 0.5+rand(nelx*nely*nelz, 1).*0.5;
xPhys = x;
penal = 3;
% Set program parameters
ITRA=70; ATOL=1.0E4; NTOL=10; TOL=1E-3;
%
% Calling main function
%tic
quad_move = 100;
[U, c_lin, c_quad, dc_lin, dc_quad] ...
    = fastNLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E0, Emin, penal, xPhys, ...
    EXTFORCE, SDISPT, XYZ, madMat, quad_move);

%display_3D_top(xPhys, U, XYZ, madMat, nEl, [0.1 0.1 .1])


if true
    h = 1e-7;
    dc_lin_num = zeros(nEl,1);
    dc_quad_num = zeros(nEl,1);
    xPhys_h = xPhys;
    for i=1:nEl
        xPhys_h(i) = xPhys(i) + h;
        [~, c_lin_h, c_quad_h, ~, ~] ...
            = fastNLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E0, Emin, penal, xPhys_h, ...
                         EXTFORCE, SDISPT, XYZ, madMat, quad_move);
        dc_lin_num(i) = (c_lin_h - c_lin)/h;
        dc_quad_num(i) = (c_quad_h - c_quad)/h;
        xPhys_h(i) = xPhys_h(i) - h;
    end

    figure
    title('sensitvity c_lin')
    plot(1:nEl, dc_lin_num, 'r*', 1:nEl, dc_lin, 'k')

    
    figure
    title('sensitvity c_quad')
    plot(1:nEl, dc_quad_num, 'r*', 1:nEl, dc_quad, 'k')
    
end

