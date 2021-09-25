function display_3D_top(rho, U, XYZ, madMat, NE, cutoff)
coder.extrinsic('patch')
[~, dim] = size(U);
if dim ~= 3
    U = reshape(U, 3, [])';
end
el_rho = [rho (1:NE)'];
red_el_rho = el_rho(el_rho(:,1)>cutoff,:);
[NE_red,~] = size(red_el_rho);
madMat = madMat(:, [2 3 4 1 6 7 8 5]);
face = [1 2 3 4; 
        2 6 7 3; 
        4 3 7 8; 
        1 5 8 4;   
        1 2 6 5; 
        5 6 7 8];
set(gcf,'Name','ISO display','NumberTitle','off');
faces = repmat(face, NE_red, 1)+reshape(repmat((1:8:NE_red*8)-1,24,1),4,[])';
deform = XYZ + U;
verts = deform(reshape(madMat',8*NE,1),:);
verts_rho = [verts reshape(repmat(rho', 8,1),[],1)];
red_verts = verts_rho(verts_rho(:,4)>cutoff,:);
crho = repmat(reshape(repmat((0.2+0.8*(1-rho(rho>cutoff)))', 6,1), [],1),1,3);
patch('Faces',faces,'Vertices',red_verts(:,1:3),'FaceColor','flat', 'FaceVertexCData', crho)
axis equal; axis tight; axis off; box on; view([30,30]); pause(1e-6); hold on;
    
end
