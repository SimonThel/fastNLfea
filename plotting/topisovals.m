function topisovals(xPhys, nelx, nely, nelz, U, madMat, XYZ, viewangle)
U = reshape(U, 3, [])';
deform = XYZ + U;
xdeform = deform(:,1); ydeform = deform(:,2); zdeform = deform(:,3);
xdeform = xdeform(madMat); ydeform = ydeform(madMat); zdeform = zdeform(madMat);
xdeform = mean(xdeform, 2); ydeform = mean(ydeform, 2); zdeform = mean(zdeform, 2);
xdeform = shiftdim( reshape( xdeform, nely, nelz, nelx ), 2 );
ydeform = shiftdim( reshape( ydeform, nely, nelz, nelx ), 2 );
zdeform = shiftdim( reshape( zdeform, nely, nelz, nelx ), 2 );
isovals = shiftdim( reshape( xPhys, nely, nelz, nelx ), 2 );
isovals = smooth3( isovals, 'box',1);
[faces,verts] = isosurface(xdeform, ydeform, zdeform, isovals, .5, 'noshare');

patch(isosurface(xdeform, ydeform, zdeform, isovals, .5),'FaceColor', [0 0.4470 0.7410] , 'EdgeColor','None');
patch(isocaps(xdeform, ydeform, zdeform, isovals, .5), 'FaceColor',[0 0.4470 0.7410], 'EdgeColor','None');
lighting gouraud
view(viewangle)
camlight('left')
camlight('right')
material dull
axis equal tight off;
set(gca, 'Projection','perspective')