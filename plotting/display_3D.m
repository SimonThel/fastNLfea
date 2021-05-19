function display_3D(rho, U, XYZ, madMat, NE, color)
coder.extrinsic('patch')
[~, dim] = size(U);
if dim ~= 3
    U = reshape(U, 3, [])';
end
madMat = madMat(:, [2 3 4 1 6 7 8 5]);
face = [1 2 3 4; 
        2 6 7 3; 
        4 3 7 8; 
        1 5 8 4;   
        1 2 6 5; 
        5 6 7 8];
set(gcf,'Name','ISO display','NumberTitle','off');
faces = repmat(face, NE, 1)+reshape(repmat((1:8:NE*8)-1,24,1),4,[])';
deform = XYZ + U;
verts = deform(reshape(madMat',8*NE,1),:);
crho = reshape(repmat(rho', 6,1), [],1);
patch('Faces',faces,'Vertices',verts,'FaceColor',color);
%patch('Faces',faces,'Vertices',verts,'FaceColor',color, 'FaceVertexAlphaData', crho, 'FaceAlpha', 'flat');
axis equal; axis tight; axis off; box on; view([30,30]); pause(1e-6);
end
