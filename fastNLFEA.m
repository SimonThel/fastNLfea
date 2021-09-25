function [U, c_lin, c_quad, dc_lin, dc_quad] ...
    = fastNLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E0, Emin, penal, xPhys, ...
    EXTFORCE, SDISPT, XYZ, LE, quad_move)
%********************************************************************
% MAIN PROGRAM FOR GEOMETRIC NONLINEAR PROBLEMS
%********************************************************************
% Purpose:
%       Computations of deformation of uniform mesh while considering
%       geometric nonlinearities
% Variable Descritption:
%   Output:
%       U - vector containing the deformation of all DOFs
%   Input:
%       ITRA - max. num. of newton iterations [double]
%       ATOL - divergence tolerance for bisection [double]
%       NTOL - max. num. of bisection [double]
%       TOL - tolerance of residuum [double]
%       TIMS - Load increments [double]
%       nu - Poisson's Ratio [double]
%       E - Young's modulus [double]
%       Emin - Stiffness of void elements (SIMP method) [double]
%       penal - SIMP parameter [double]
%       xPhsy - vector for material distribution [nelx*nely*nelz x 1 double]
%       EXTFORCE - appiled force [n x 3 double]
%       SDISPT - fixed displacements [m x 3 double]
%       XYZ - node postions [(nelx+1)*(nely+1)*(nelz+1) x 3 double]
%       LE - node conectivity [nelx*nely*nelz x 8 double]
%% Convert to single to improve performance of arithmetric operations
% ITRA = single(ITRA);
% TOL = single(TOL);
% ATOL = single(ATOL);
% NTOL = single(NTOL);
% TIMS = single(TIMS);
% nu = single(nu);
% E0 = single(E0);
% Emin = single(Emin);
% penal = single(penal);
% xPhys = single(xPhys);
% EXTFORCE = single(EXTFORCE);
% SDISPT = single(SDISPT);
% XYZ = single(XYZ);
% LE = single(LE);
% fdpoint = single(fdpoint);
% U_pre = single(U_pre);
% g_dist = single(g_dist);
% iter = single(iter);
% decay_q = single(decay_q);
% decay_r = single(decay_r);
% decay_s = single(decay_s);
%% Initialize some variables
[NUMNP, NDOF] = size(XYZ);              % Analysis parameters
NE = size(LE,1);
NEQ = int32(NDOF*NUMNP);
DISPTD=zeros(NEQ,1);                    % Nodal displacement
% energy interpolation parameters
beta = 500;
eta = 0.01;
% ITGZONE(XYZ, LE, NOUT);                 % Check element connectivity
% Load increments [Start End Increment InitialLoad FinalLoad]
NLOAD=size(TIMS,2);
ILOAD=1;                                % First load increment
TIMEF=TIMS(1,ILOAD);                    % Starting time
TIMEI=TIMS(2,ILOAD);                    % Ending time
DELTA=TIMS(3,ILOAD);                    % Time increment
CUR1=TIMS(4,ILOAD);                     % starting load factor
CUR2=TIMS(5,ILOAD);                     % ending load factor
DELTA0 = DELTA;                         % saved time increment
TIME = TIMEF;                           % starting time
TDELTA = TIMEI - TIMEF;                 % time interval for laod step
ITOL = 1;                               % Bisection level
TARY=zeros(NTOL,1);                     % Time stamps for bisections
[lambda, mu, ETAN, DET, BG, gSHPDT, temp] = lin_assembly(nu, E0, Emin, xPhys, penal, NE, XYZ, LE);
GDOF = (reshape ([1 + (LE-1)*NDOF; 2 + (LE-1)*NDOF; 3 + (LE-1)*NDOF],NE, 24));
iK = (reshape(repmat(GDOF, 1,24)', 576*NE, 1));
jK = (reshape(repmat(reshape(GDOF',1, 24*NE), 24, 1), 1 , 576*NE)');
lK = (reshape(permute(GDOF,[2 1 3 4]), 24*NE, 1));
FIXEDDOF=(NDOF*(SDISPT(:,1)-1)+SDISPT(:,2));
ALLDOF=1:NEQ;
FREEDOF=setdiff(ALLDOF,FIXEDDOF);
%% Load increment loop
ISTEP = -1; FLAG10 = 1;
while(FLAG10 == 1)                      % Solution has been converged
    FLAG10 = 0;
    FLAG11 = 1;
    FLAG20 = 1;
    CDISP = DISPTD;                     % Store converged displacement
    if(ITOL==1)                         % No bisection
        DELTA = DELTA0;
        TARY(ITOL) = TIME + DELTA;
    else                                % Recover previous bisection
        ITOL = ITOL-1;                  % Reduce the bisection level
        DELTA = TARY(ITOL)-TARY(ITOL+1);% New time incremtn
        TARY(ITOL+1) = 0;               % Empty converged bisection level
        ISTEP = ISTEP - 1;              % Decrease load increment
    end
    TIME0 = TIME;                        % save the current time
    TIME = TIME + DELTA;                 % increase time
    ISTEP = ISTEP + 1;
    %% Bisection loop
    while(FLAG11 == 1)                   % Bisection loop start
        FLAG11 = 0;
        if ((TIME-TIMEI)>1E-10)          % Time passed the end time
            if ((TIMEI+DELTA-TIME)>1E-10)% One more at the end time
                DELTA=TIMEI+DELTA-TIME;  % Time increment to the end
                DELTA0=DELTA;            % Saved time increment
                TIME=TIMEI;              % Current time is the end
            else
                ILOAD=ILOAD+1;           % Progress to next load step
                if(ILOAD>NLOAD)          % Finished final load step
                    FLAG10 = 0;          % Stop the program
                    break;
                else                     % Next load step
                    TIME=TIME-DELTA;
                    DELTA=TIMS(3,ILOAD);
                    DELTA0=DELTA;
                    TIME = TIME + DELTA;
                    TIMEF = TIMS(1,ILOAD);
                    TIMEI = TIMS(2,ILOAD);
                    TDELTA = TIMEI - TIMEF;
                    CUR1 = TIMS(4,ILOAD);
                    CUR2 = TIMS(5,ILOAD);
                end
            end
        end
        %
        % Load factor and prescribed displacements
        FACTOR = CUR1 + (TIME-TIMEF)/TDELTA*(CUR2-CUR1);
        %% Convergence iteration
        ITER = 0;
        while(FLAG20 == 1)
            FLAG20 = 0;
            ITER = ITER + 1;
            % Check max iteration
            if(ITER>ITRA)
                error('Iteration limit exceeds');
            end
            % Assemble K and F
            [GKF, FORCE, BN, E, E_int, epsilon_int, epsilon] = assembly(DISPTD, xPhys, penal, beta, eta, NE, NEQ, NDOF, LE, lambda, mu, ETAN, DET, BG, gSHPDT, temp, iK, jK, lK);
            % Increase external force
            if size(EXTFORCE,1)>0
                LOC = NDOF*(EXTFORCE(:,1)-1)+EXTFORCE(:,2);
                FORCE = FORCE + sparse((LOC),1,double(FACTOR*EXTFORCE(:,3)), double(NEQ), 1);
            end
            % Check convergence
            if(ITER>1)
                RESN=max(abs(FORCE(FREEDOF)));
                OUTPUT(1, ITER, RESN, TIME, DELTA)
                if(RESN<double(TOL))
                    FLAG10 = 1;
                    break;
                else
                    clear DCOM BN E E_int epsilon_int epsilon
                end
                % Start bisection
                if ((RESN>double(ATOL))||(ITER>=double(ITRA)))
                    ITOL = ITOL + 1;
                    if(ITOL<NTOL)
                        DELTA = 0.5*DELTA;
                        TIME = TIME0 + DELTA;
                        TARY(ITOL) = TIME;
                        DISPTD=CDISP;
                        fprintf(1,'Not converged. Bisecting load increment %3d\n',ITOL);
                    end
                    FLAG11 = 1;
                    FLAG20 = 1;
                    break;
                end
            end
            % Solve the system equation
            if(FLAG11 == 0)
                % assuming symmetry of tangent stiffness matrix
                GKF = 0.5*(GKF+GKF');
                DECOM = decomposition(GKF(FREEDOF, FREEDOF));
                DISPTD(FREEDOF) = DISPTD(FREEDOF) + DECOM\FORCE(FREEDOF);
                FLAG20 = 1;
            else
                FLAG20 = 0;
            end
            if(FLAG10 == 1)
                break;
            end
        end                     %20 Convergence iteration
    end                         %11 Bisection
end                             %10 Load increment
%% sensitvity analysis
% evaluate objective function
L_stiff = zeros(NEQ,1);
L_stiff(LOC) = EXTFORCE(:,3);
c_quad = (DISPTD'*L_stiff-quad_move)^2;
c_lin = DISPTD'*L_stiff;
% evaluate displacement constraint function
dforce = sensitvity(DET, nu, E0, Emin, lambda, mu, xPhys, penal, eta, beta, NE, ...
                    NDOF, LE, BN, E, E_int, epsilon_int, epsilon);
dc_quad = adjoint_quad(L_stiff, dforce, DECOM, DISPTD, quad_move, GDOF, FREEDOF, NEQ, NE);
dc_lin = adjoint_lin(L_stiff, dforce, DECOM, GDOF, FREEDOF, NEQ, NE);
% final displacement
U = double(DISPTD);
end