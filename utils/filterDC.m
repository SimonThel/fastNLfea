function dc_filtered = filterDC(dc, h, bcF, dHs, nelx, nely, nelz)

dc_filter = reshape( dc, nely, nelz, nelx );
dc_filter(:,nelz,:) = dc_filter(:,nelz-1,:);
dc_filter(:,1,:) = dc_filter(:,2,:);
dc_filter(nely,:,:) = dc_filter(nely-1, :,:);
dc_filtered = imfilter(dc_filter, h, bcF ) ./ dHs;
