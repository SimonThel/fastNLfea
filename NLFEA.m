function U = NLFEA(ITRA, TOL, ATOL, NTOL, TIMS, nu, E, Emin, penal, xPhys, EXTFORCE, SDISPT, XYZ, LE)
%******************************************************************** 
% MAIN PROGRAM FOR HYPERELASTIC/ELASTOPLASTIC ANALYSIS 
%******************************************************************** 
global DISPDD DISPTD FORCE GKF %Global variables
[NUMNP, NDOF] = size(XYZ); % Analysis parameters
NE = size(LE,1);
NEQ = NDOF*NUMNP;
% U_points = zeros(size(U_pre));

DISPTD=zeros(NEQ,1);                    % Nodal displacement
DISPDD=zeros(NEQ,1);                    % Nodal displacement increment

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
%
% Load increment loop
%------------------------------------------?-----------
ISTEP = -1; FLAG10 = 1;
while(FLAG10 == 1)                      % Solution has been converged
    FLAG10 = 0; 
    FLAG11 = 1; 
    FLAG20 = 1;
    %
    CDISP = DISPTD;                     % Store converged displacement 
    %
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
    %
    % Check time and control bisection
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
        %
        % Start convergence iteration 
        %-------------------------------------------------------------- 
        ITER = 0;
        DISPDD = zeros(NEQ,1); 
        while(FLAG20 == 1)
            FLAG20 = 0;
            ITER = ITER + 1;
            % Check max iteration
            if(ITER>ITRA) 
                error('Iteration limit exceeds'); 
            end
            %
            % Initialize global stiffness K and residual vector F
            %GKF = fsparse(NEQ,NEQ, 0);
            %FORCE = fsparse(NEQ,1, 0);
            %
            % Assemble K and F
            assembly(nu, E, Emin, xPhys, penal, beta, eta, NE, NEQ, NDOF, XYZ, LE)
            %
            % Increase external force
            if size(EXTFORCE,1)>0
                LOC = NDOF*(EXTFORCE(:,1)-1)+EXTFORCE(:,2);
                FORCE = FORCE + fsparse(LOC,1,FACTOR*EXTFORCE(:,3), [NEQ 1]);
            end
            %
            % Check convergence
            FIXEDDOF=NDOF*(SDISPT(:,1)-1)+SDISPT(:,2); 
            ALLDOF=1:NEQ;
            FREEDOF=setdiff(ALLDOF,FIXEDDOF); 
            if(ITER>1)
                RESN=max(abs(FORCE(FREEDOF)));
                OUTPUT(1, ITER, RESN, TIME, DELTA) 
                if(RESN<TOL) 
                    FLAG10 = 1; 
                    break;
                end
                if ((RESN>ATOL)||(ITER>=ITRA))      % Start bisection
                ITOL = ITOL + 1; 
                    if(ITOL<NTOL)
                        % Start bisection
                        DELTA = 0.5*DELTA;
                        TIME = TIME0 + DELTA;
                        TARY(ITOL) = TIME;
                        DISPTD=CDISP;
                        fprintf(1,'Not converged. Bisecting load increment %3d\n',ITOL);
                    else
                        error('Max No. of bisection');
                    end
                FLAG11 = 1; 
                FLAG20 = 1; 
                break;
                end
            end
            %
            % Solve the system equation 
            if(FLAG11 == 0)
                GKF = (GKF+GKF')/2;
                SOLN = decomposition(GKF(FREEDOF, FREEDOF))\FORCE(FREEDOF);
                DISPDD(FREEDOF) = DISPDD(FREEDOF) + SOLN; 
                DISPTD(FREEDOF) = DISPTD(FREEDOF) + SOLN; 
                FLAG20 = 1;
            else
                FLAG20 = 0;
            end
            if(FLAG10 == 1) 
                break; 
            end
        end                             %20 Convergence iteration
    end %11 Bisection
end                             %10 Load increment
%
U = DISPTD;
% Successful end of program
%fprintf('*** Successful end of program ***\n');
end
