clc
clear
close all
%% setting general variables
nelx = 20;
nely = 70;
nelz = 20;
scale = 1;
penal = 3;
%% prescribed force-displacement points
nnodes = (nelx+1)*(nely+1)*(nelz+1);
% Load increments [Start End Increment InitialFactor FinalFactor]
TIMS=[0.0 5 1 0.0 1.0]';
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
% node connectivity
nEl = nelx * nely * nelz;                                                  
nodeNrs = ( reshape( 1 : ( 1 + nelx ) * ( 1 + nely ) * ( 1 + nelz ), ...
    1 + nely, 1 + nelz, 1 + nelx ) );         
madVec = reshape( nodeNrs( 1 : nely, 1 : nelz, 1 : nelx ) + 1, nEl, 1 );
madMat = madVec+([0, (nely+1)*(nelz+1)+[0,-1], -1, (nely+1)+[0], (nely+1)*(nelz+2)+[0, -1],(nely+1)+[-1]]);             
%% boundary condtions and loads
% External forces [Node, DOF, Value]
% Prescribed displacements [Node, DOF, Value]
EXTFORCE = [];
SDISPT = [];
for n=1:nnodes
    force = area_force_z(XYZ(n,:), 0, 60, 10, 70, 20);
    if force ~= 0
        EXTFORCE = [EXTFORCE; n 3 force];
    end
    if XYZ(n,2) == 0
       SDISPT = [SDISPT; n 1 0];
       SDISPT = [SDISPT; n 2 0];
       SDISPT = [SDISPT; n 3 0];
%     else
%        SDISPT = [SDISPT; n 1 0];
    end
end
total_force = 3;
EXTFORCE(:,3) = total_force*EXTFORCE(:,3)/sum(EXTFORCE(:,3));

%% Material properties and general FE-parameters
nu = 0.3; E = 1.0; Emin = 1e-9;
% Set program parameters
ITRA=10; ATOL=1.0E4; NTOL=20; TOL=5e-6;
%% setting up densities
xPhys = ones(nEl, 1);
tic
U = fastNLFEA(single(ITRA), single(TOL), single(ATOL), single(NTOL), single(TIMS), single(nu), single(E), single(Emin), single(penal), single(xPhys), ...
    single(EXTFORCE), single(SDISPT), single(XYZ), single(madMat));
toc

tic
figure
display_3D(xPhys, U, XYZ, madMat, nEl, [0.6 0 0])
toc