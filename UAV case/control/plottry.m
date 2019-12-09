addpath('utils')
addpath('trajectories')
global time_step 
time_step = 0.5;
global time_tol
global quadcolors
global h_3d
global stop
% real_trajectory = [];
% You can change trajectory here

% trajectory generator
% trajhandle = @step;
% trajhandle = @circle;
% trajhandle = @diamond;
trajhandle = @navigation;

% controller
controlhandle = @controller;

% real-time 
real_time = true;

% *********** YOU SHOULDN'T NEED TO CHANGE ANYTHING BELOW **********
% number of quadrotors
nquad = 1;

% max time
% time_tol = 3.5;
% time_tol = end_time;

% parameters for simulation
params = crazyflie();

%% **************************** FIGURES *****************************
fprintf('Initializing figures...\n')
h_fig = figure;
h_3d = gca;
axis equal
grid on
view(3);
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
quadcolors = lines(nquad);

set(gcf,'Renderer','OpenGL')

%% *********************** INITIAL CONDITIONS ***********************
fprintf('Setting initial conditions...\n')
max_iter  = 5000;      % max iteration
starttime = 0;
% starttime = 2;         % start of simulation in seconds
tstep     = 0.01;      % this determines the time step at which the solution is given
cstep     = 0.05;      % image capture time interval
nstep     = cstep/tstep;
time      = starttime; % current time
err = []; % runtime errors
start_time = 0;
end_time = 19;
time_tol = end_time;
global xtraj
global ttraj
global x0
global QP

for qn = 1:nquad
    % Get start and stop position
    des_start = trajhandle(start_time, qn)
    des_stop  = trajhandle(end_time, qn)
    stop{qn}  = des_stop.pos;
    x0{qn}    = init_state( des_start.pos, 0 );
    xtraj{qn} = zeros(max_iter*nstep, length(x0{qn}));
    ttraj{qn} = zeros(max_iter*nstep, 1);
end

x         = x0;        % state

% pos_tol   = 0.01;
% vel_tol   = 0.01;
pos_tol   = 1e-3;
vel_tol   = 1e-3;
QP{qn} = QuadPlot(qn, x0{qn}, 0.1, 0.04, quadcolors(qn,:), max_iter, h_3d);
desired_state = trajhandle(time, qn);
QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time);

 
for tt = 0:0.5:19-0.5
    time_tol = tt+0.5;
    simulation(0.5,tt,tt+0.5,x,x0)
end