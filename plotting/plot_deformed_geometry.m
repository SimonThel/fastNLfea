function plot_deformed_geometry(nelx, nely, nelz, U, madMat, xPhys, name)
nnodes = (nelx+1)*(nely+1)*(nelz+1);
U_slice = U(1:nnodes*3/2);
u = flipud(reshape(U_slice(2:3:nnodes*3/2), nely+1, nelz+1)');
v = flipud(reshape(U_slice(3:3:nnodes*3/2), nely+1, nelz+1)'); 
mad_slice = [madMat(:,1) madMat(:,4) madMat(:,5) madMat(:,8)];


[X,Y] = meshgrid((0:1:nely),(nelz:-1:0)); 
X = X + u; 
Y = Y + v; 
A = mad_slice;  C = 1./histc(A(:), (1:(nely+1)*(nelz+1))');

Z = zeros((nely+1)*(nelz+1), 1);  D = xPhys(:).*C(A);  
for i = 1:nely*nelz; Z(A(i,:)) =  Z(A(i,:)) + (D(i,:))';end 
surf(X,Y,flipud(reshape(1-Z,nely+1,nelz+1)'));colormap(gray);  grid on;  title(name); 
rectangle('Position',[0 0 nely nelz], 'EdgeColor','r', 'LineWidth', 2); 
daspect([nely nelz*3 2]); view(2); axis equal; %xlim([-0.02*nely 1.1*nely]); 
%ylim([0 2*nelz])
drawnow; 