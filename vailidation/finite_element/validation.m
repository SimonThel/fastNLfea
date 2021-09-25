clear
load('L2_lowres.mat')

nodes.Z(nodes.Z < 2e-6) = 0;
nodes.Y(nodes.Y < 2e-6) = 0;
nodes.X(nodes.X < 2e-6) = 0;
nodes_new = sortrows(nodes, 2, 'ascend');
nodes_new = sortrows(nodes_new, 3, 'ascend');
nodes_new = sortrows(nodes_new, 1, 'descend');


U_abaqus = [nodes_new.UU1, nodes_new.UU2, nodes_new.UU3];
XYZ_abaqus = [nodes_new.X, nodes_new.Y, nodes_new.Z];

U_matlab = reshape(U_matlab, 3, [])';

figure
display_3D(xPhys, 10*(U_abaqus - U_matlab), XYZ_abaqus, madMat, nEl, [0.6 0 0])

figure 
display_3D(xPhys, U_matlab, XYZ_abaqus, madMat, nEl, [0.6 0 0])
display_3D(xPhys, U_abaqus, XYZ_abaqus, madMat, nEl, [0 0.6 0])

diff_disp = (U_abaqus-U_matlab);
total_disp = sum(abs(U_matlab(:)));
mean_diff = sum(abs(diff_disp(:)))/total_disp;

