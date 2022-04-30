function xTilde = filterX(x, h, bcF, Hs, nelx, nely, nelz, xSolid)

x_filter = reshape( x, nely, nelz, nelx );
x_filter(:,nelz,:) = x_filter(:,nelz-1,:);
x_filter(:,1,:) = x_filter(:,2,:);
x_filter(nely,:,:) = x_filter(nely-1, :,:);
xTilde = reshape(imfilter(x_filter, h, bcF ) ./ Hs, [],1);
xTilde(xSolid) = 1;