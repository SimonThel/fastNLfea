clc
clear
%% setting general variables
nelx = 1;   % number of elements in x-direction
nely = 200; % number of elements in y-direction
nelz = 50;  % number of elements in z-direction
penal = 3;  % SIMP parameter
nEl = nelx*nely*nelz;  
nnodes = (nelx+1)*(nely+1)*(nelz+1);
% Load increments [Start End Increment InitialFactor FinalFactor]
TIMS=[0.0 5 1 0.0 1.0]';
%% initialize FE-grid  
XYZ = zeros(nnodes,3); % node position
coord = [nelx*0.1, 0, 0];
for n=1:nnodes
    XYZ(n,:) = coord;
    if coord(2)<nely
        coord(2) = coord(2) + 1;
    elseif coord(2) == nely && coord(3) < nelz
        coord(2) = 0;
        coord(3) = coord(3) + 1;
    elseif coord(2) == nely && coord(3) == nelz
        coord(1) = coord(1) - 0.1;
        coord(2) = 0;
        coord(3) = 0;
    end
end
% node connectivity                                           
nodeNrs = (reshape(1:(1+nelx)*(1+nely)*(1+nelz), 1+nely, 1+nelz, 1+nelx));         
madVec = reshape(nodeNrs(1:nely, 1:nelz, 1:nelx)+1, nEl, 1);
madMat = madVec+([0, (nely+1)*(nelz+1)+[0, -1], -1, (nely+1), ...
    (nely+1)*(nelz+2)+[0, -1], nely]);                 
%% boundary condtions and loads
% External forces [Node, DOF, Value]
nodal_force = 0.003;
% Prescribed displacements/forces [Node, DOF, Value]
EXTFORCE = [];
SDISPT = [];
for n=1:nnodes
    if XYZ(n,3) == nelz && XYZ(n,2) == nely
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
%% Material properties and general FE-parameters
nu = 0.3; E = 1.0; Emin = 1e-9;
% Set program parameters
ITRA = 30;    % max. num. of newton iterations
ATOL = 1.0E4; % divergence tolerance for bisection
NTOL = 10;    % max. num. of bisection
TOL = 1E-5;   % tolerance of residuum
%% running FEA with test material distribution
load('softening0_200x50.mat')
%xPhys=0.5*ones(nEl,1);
U = NLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E, Emin, penal, xPhys, ...
    EXTFORCE, SDISPT, XYZ, madMat);
deviation = sum(abs(U(:)-U_valid(:)));
plot_deformed_geometry(nelx, nely, nelz, U, madMat, xPhys, 'new')