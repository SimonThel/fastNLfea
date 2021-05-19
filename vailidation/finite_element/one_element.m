clc
clear
close all
%% setting general variables
nelx = 1;
nely = 1;
nelz = 1
scale = 1;
penal = 3;
volfrac = 0.5;
rmin = 1.5;
eta_p = 0.5;
betamax = 16;
kkttol = 1e-4;
g_dist = 0.07;
%% prescribed force-displacement points
nnodes = (nelx+1)*(nely+1)*(nelz+1);
fdpoint = [10; 11; 12];
U_pre = [4; 8; 12; 18; 24];
steps = 100;
U_pre = [(1:steps)*0; (1:steps)*0; (1:steps)*0];
% Load increments [Start End Increment InitialFactor FinalFactor]
TIMS=[0.0 steps 1 0.0 1.0]';
% decay parameter
iter = 10;
decay_q = 1;
decay_r = 1.5;
decay_s = 1e-4;
%% initialize FE-grid  
% node position
XYZ = zeros(nnodes,3);
coord = [nelx*scale, 0, 0];
for n=1:nnodes
    XYZ(n,:) = coord;
    if coord(2)<scale*nely
        coord(2) = coord(2) + scale;
    elseif coord(2) == scale*nely && coord(3) < scale*nelz
        coord(2) = 0;
        coord(3) = coord(3) + scale;
    elseif coord(2) == scale*nely && coord(3) == scale*nelz
        coord(1) = coord(1) - scale;
        coord(2) = 0;
        coord(3) = 0;
    end
end
%XYZ = XYZ * 0.5;
% node connectivity
nEl = nelx * nely * nelz;                                                  
nodeNrs = ( reshape( 1 : ( 1 + nelx ) * ( 1 + nely ) * ( 1 + nelz ), ...
    1 + nely, 1 + nelz, 1 + nelx ) );         
madVec = reshape( nodeNrs( 1 : nely, 1 : nelz, 1 : nelx ) + 1, nEl, 1 );
madMat = madVec+([0, (nely+1)*(nelz+1)+[0,-1], -1, (nely+1)+[0], (nely+1)*(nelz+2)+[0, -1],(nely+1)+[-1]]);             
%% boundary condtions and loads
% External forces [Node, DOF, Value]
nodal_force = 1;
% Prescribed displacements [Node, DOF, Value]
EXTFORCE = [];
SDISPT = [];
for n=1:nnodes
    force = area_force_y(XYZ(n,:), 0, 0, 1, 1, 1);
    if force ~= 0
        EXTFORCE = [EXTFORCE; n 2 force];
    end
    if XYZ(n,1) == 0 && XYZ(n,2) == 0 && XYZ(n,3) == 0
       SDISPT = [SDISPT; n 1 0];
       SDISPT = [SDISPT; n 2 0];
       SDISPT = [SDISPT; n 3 0];
    elseif XYZ(n,1) == 0 && XYZ(n,2) == 0 
        SDISPT = [SDISPT; n 1 0];
        SDISPT  = [SDISPT; n 2 0];
    elseif XYZ(n,2) == 0 
        SDISPT  = [SDISPT; n 2 0];
    end
end
total_force = 100;
EXTFORCE(:,3) = total_force*EXTFORCE(:,3)/sum(EXTFORCE(:,3));
%% Material properties and general FE-parameters
nu = 0.2; E = 200.0; Emin = 1e-9;
% Set program parameters
ITRA=10; ATOL=1.0E4; NTOL=20; TOL=5e-4;
%% setting up densities
xPhys = ones(nEl, 1);
tic
[c, dc, U_matlab,  U_points,  g_lower, dg_lower, g_upper, dg_upper] = ...
    fastNLFEA(single(ITRA), single(TOL), single(ATOL), single(NTOL), single(TIMS), single(nu), single(E), single(Emin), single(penal), single(xPhys), ...
    single(EXTFORCE), single(SDISPT), single(XYZ), single(madMat), single(fdpoint), single(U_pre), single(g_dist),...
    single(iter), single(decay_q), single(decay_r), single(decay_s));
toc

tic
figure
display_3D(xPhys, U_matlab, XYZ, madMat, nEl, [0.6 0 0])
display_3D(xPhys, zeros(24,1), XYZ, madMat, nEl, [0 0.6 0])
toc

