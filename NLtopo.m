function perf = NLtopo(volfrac, penal, decay_q, decay_r, decay_s, decay_u, plotting)
%% setting general variables
nelx = 150;
nely = 75;
nelz = 30;
scale = 1;
rmin = 2.5;
eta_p = 0.5;
maxiter = 250;
betamax = 16;
g_dist = 0.0005;
bcF = 'symmetric';
%% prescribed force-displacement points
nnodes = (nelx+1)*(nely+1)*(nelz+1);
% Load increments [Start End Increment InitialFactor FinalFactor]
TIMS=[0.0 2 1 0.0 1.0]';
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
EXTFORCE_area = [];
EXTFORCE_rib = [];
SDISPT = [];
for n=1:nnodes
    force_rib = area_force_y(XYZ(n,:), 0, 0, nelx, nelz, nely);
    if force_rib ~= 0
        EXTFORCE_rib = [EXTFORCE_rib; n 3 force_rib];
    end
    force_upper = area_force_z(XYZ(n,:), 0, 0, nelx, nely, nelz);
    if force_upper ~= 0
        EXTFORCE_area = [EXTFORCE_area; n 3 force_upper];
    end
    force_lower = area_force_z(XYZ(n,:), 0, 0, nelx, nely, 0);
    if force_lower ~= 0
        EXTFORCE_area = [EXTFORCE_area; n 3 0.5*force_lower];
    end
    if XYZ(n,1) == 0 && XYZ(n,2) == nely && XYZ(n,3) == floor(0.5*nelz)
        fd_LE = n;
    end
    if XYZ(n,1) == nelx && XYZ(n,2) == nely && XYZ(n,3) == floor(0.5*nelz)
        fd_TE = n;
    end
    if XYZ(n,2) == 0
        SDISPT = [SDISPT; n 1 0];
        SDISPT = [SDISPT; n 2 0];
        SDISPT = [SDISPT; n 3 0];
    end
end
Q_rib = 10428;
Q_area =0.5*13452;
EXTFORCE_area(:,3) = Q_area*EXTFORCE_area(:,3)/sum(EXTFORCE_area(:,3));
EXTFORCE_rib(:,3) = Q_rib*EXTFORCE_rib(:,3)/sum(EXTFORCE_rib(:,3));
EXTFORCE = [EXTFORCE_area; EXTFORCE_rib];
EXTFORCE = sortrows(EXTFORCE);
fdpoints = [3*fd_LE, 3*fd_TE];
%% Material properties and general FE-parameters
nu = 0.34; E = 70e8 ; Emin = 70e-1;
% Set program parameters
ITRA=10; ATOL=1.0E5; NTOL=8; TOL=5e-3;
%% Densities and boundaries
%% design boundaries and initial material distribution
x = reshape(repmat(volfrac*0.8,nEl, 1), nely, nelz, nelx);
xmin = reshape(zeros(nEl, 1), nely, nelz, nelx); % lower bounds
xmax = reshape(ones(nEl, 1), nely, nelz, nelx); % upper bounds
lEl = reshape(1:nEl, nely, nelz, nelx);
xSolid = [];
for j=1:nely
    for k=1:nelz
        for i=1:nelx
            if k == nelz
                x(j,k,i) = 1;
                xmin(j,k,i) = 0.9995;
                xSolid = [xSolid; lEl(j,k,i)];
            elseif k == 1
                x(j,k,i) = 1;
                xmin(j,k,i) = .9995;
                xSolid = [xSolid; lEl(j,k,i)];
            elseif j == nely
                x(j,k,i) = 1;
                xmin(j,k,i) = 0.9995;
                xSolid = [xSolid; lEl(j,k,i)];
            end
        end
    end
end
x = reshape(x,[],1);
xmin = reshape(xmin, [], 1);
xmax = reshape(xmax, [], 1);
%% Scale geometry arcording to real dimensions
XYZ = XYZ/nelx;
%% PREPARE FILTER
[dy,dz,dx]=meshgrid(-ceil(rmin)+1:ceil(rmin)-1,...
    -ceil(rmin)+1:ceil(rmin)-1,-ceil(rmin)+1:ceil(rmin)-1 );
h = max( 0, rmin - sqrt( dx.^2 + dy.^2 + dz.^2 ) );                        % conv. kernel                #3D#
Hs = imfilter( ones( nely, nelz, nelx ), h, bcF );                         % matrix of weights (filter)  #3D#
dHs = Hs;
%% setting up densities
xTilde = x;
beta = 1;
xPhys = (tanh(beta*eta_p) + tanh(beta*(xTilde - eta_p))) / (tanh(beta * eta_p) + tanh(beta*(1-eta_p))); % intialize projection % no filtering yet, so phsical density and design variables are the same
%% INITIALIZE MMA-OPTIMIZER
%m = 2*length(U_pre)+1;
m = 3;
n = nelx*nely*nelz;
a0 = 1;
a = zeros(m,1);
ci = 10000;
d = ones(m,1);
xold1   = x;
xold2   = x;
low     = xmin;
upp     = xmax;
iter = 0;
loopbeta = 0;
move = 0.5;
%% VOLUME CONSTRAINT
dv = (100/(volfrac*nelx*nely*nelz))*ones(1, nelx*nely*nelz); % sensitivity of volume constraint with respect of physical density (must be changed for different filtering)
v = (100/(volfrac*nelx*nely*nelz))*(sum(xPhys(:)) - volfrac*nelx*nely*nelz);
%% Call nonlinear FE-Analysis
[U, U_points, c_stiff, dc_stiff, c_diff, dc_diff, g1, g2, dg1, dg2, failed] = ...
    fastNLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E, Emin, penal, xPhys, EXTFORCE, SDISPT, XYZ, madMat, fdpoints, g_dist);
c = CMDW(1, maxiter, decay_q, decay_r, decay_s, decay_u)*c_stiff + 1000*c_diff;
dc = CMDW(1, maxiter, decay_q, decay_r, decay_s, decay_u)*dc_stiff + 1000*dc_diff;
g = [v; 10000*g1; 10000*g2];
dg = [dv; 10000*dg1'; 10000*dg2'];
if plotting
    fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f kktnorm.:%7.3f gray.:%7.3f \n',0, c_diff, mean(xPhys(:)), 1, 1);
end
%% FILTERING AND MODIFICATION OF SENSITIVITIES
dc = reshape(imfilter( reshape( dc, nely, nelz, nelx ) ./ dHs, h, bcF ), [],1);
for i=1:m
    dg(i,:) = reshape(imfilter( reshape( dg(i,:)', nely, nelz, nelx ) ./ dHs, h, bcF ), 1, []);
end
%% START ITERATION
while iter < maxiter && ~failed
    iter = iter+1;
    loopbeta = loopbeta + 1;
    %% The MMA subproblem is solved at the point xval:
    [xmma,ymma,zmma,lam,xsi,eta,mu,zet,s,low,upp] = ...
        mmasub(m,n,iter,x,xmin,xmax,xold1,xold2, ...
        c,dc,g,dg,low,upp,a0,a,ci,d, move);
    [~ ,kktnorm, ~] = kktcheck(m,n,xmma,ymma,zmma,lam,xsi,eta,mu,zet,s, ...
        xmin,xmax,dc,g,dg,a0,a,ci,d);
    if isnan(kktnorm)
        kktnorm = 100;
    end
    %% Update Design Variables:
    xold2 = xold1;
    xold1 = x;
    x = xmma;
    xTilde = filterX(x, h, bcF, Hs, nelx, nely, nelz, xSolid); % applying densitity filtering
    f = ( mean( projX( xTilde, eta_p, beta ) ) -  mean(x));     % function (volume)
    while abs( f ) > 1e-6           % Newton process for finding opt. eta
        eta_p = eta_p - f / mean( dProjEta( xTilde, eta_p, beta ) );
        f = mean( projX( xTilde, eta_p, beta ) ) -  mean(x);
    end
    if eta_p > 0.9
        eta_p = 0.9;
    elseif eta_p < 0.1
        eta_p = 0.1;
    end
    dHs = Hs ./ reshape( dProjX( xTilde, eta_p, beta ), nely, nelz, nelx );   % sensitivity modification    #3D#
    xPhys = projX( xTilde, eta_p, beta );                                       % projected (physical) field
    xPhys(xSolid)=1;
    %% Call nonlinear FE-Analysis
    [U, U_points, c_stiff, dc_stiff, c_diff, dc_diff, g1, g2, dg1, dg2, failed] = ...
        fastNLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E, Emin, penal, xPhys, EXTFORCE, SDISPT, XYZ, madMat, fdpoints, g_dist);
    if failed
        break
    end
    c = CMDW(iter, maxiter, decay_q, decay_r, decay_s, decay_u)*c_stiff + 1000*c_diff;
    dc = CMDW(iter, maxiter, decay_q, decay_r, decay_s, decay_u)*dc_stiff + 1000*dc_diff;
    %% VOLUME CONSTRAINT
    dv = (100/(volfrac*nelx*nely*nelz))*ones(1, nelx*nely*nelz); % sensitivity of volume constraint with respect of physical density (must be changed for different filtering)
    v = (100 /(volfrac*nelx*nely*nelz))*(sum(xPhys(:)) - volfrac*nelx*nely*nelz);
    %% assemble constraints
    g = [v; 10000*g1; 10000*g2];
    dg = [dv; 10000*dg1'; 10000*dg2'];
    %% FILTERING AND MODIFICATION OF SENSITIVITIES
    dc = reshape(filterDC(dc, h, bcF, dHs, nelx, nely, nelz), [],1);
    for i=1:m
        dg(i,:) = reshape(filterDC(dg(i,:)', h, bcF, dHs, nelx, nely, nelz), 1, []);
    end
    %% update projection parmeters
    if beta < betamax && loopbeta >= 30
        beta = 2*beta;
        loopbeta = 0;
        fprintf('Parameter beta increased to %g. eta: %g \n',beta, eta_p);
    end
    %% PRINT RESULTS
    Mnd = sum(4*xPhys(:).*(1-xPhys(:)))*100 / (nely*nelx*nelz); % grayness level indicator
    if plotting
        fprintf(' It.:%5i Obj.:%11.4f stiff:%11.4f Vol.:%7.3f kktnorm.:%7.3f gray.:%7.3f g1:%7.3f g2:%7.3f eta:%7.3f \n',iter, c_diff*1000, c_stiff,mean(xPhys(:)), kktnorm, Mnd, g1, g2, eta_p);
        figure(1)
        clf
        subplot(2,1,1)
        display_3D_top(xPhys, U, XYZ, madMat, nEl, volfrac-0.2);
        plot(1:2, U_points(1,:),'b+', 0:2, [0 U_points(2,:)], 'r*')
        subplot(2,1,2)
        xlim([0 2.1])
        drawnow;
    end
    save(append('scratch/temp_iter_', string(iter),'_diff_', string(c_diff), '.mat'))
end
if failed
    perf = (maxiter-iter)*100;
else
    if Mnd > 15
        perf = Mnd + c_diff*100;
    else
        perf = c_diff*100;
    end
end
timestr = datestr(datetime('now'));
filename = append('scratch/', 'topo-perf', string(perf), timestr, '.mat');
save(filename)
end
