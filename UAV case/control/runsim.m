configure = Configure();
tau = configure.Time_step;
start_time = 0;
end_time = length(planning_time)*tau;
runsimulation(tau,start_time,end_time);


function [] = runsimulation(tau,start_time,end_time)

% NOTE: This srcipt will not run as expected unless you fill in proper
% code in trajhandle and controlhandle
% You should not modify any part of this script except for the
% visualization part
%
% ***************** MEAM 620 QUADROTOR SIMULATION *****************
% close all
% clear all

addpath('utils')
addpath('trajectories')
addpath('50_50')
global time_step 
time_step = tau;
global time_tol
global planning_time
global velocity_history
global trajectory
planning_time = load('planningtime.mat').planning_time;
velocity_history = load ('velocity_history.mat').velocity_history;
trajectory = load('trajectory.mat').trajectory;
configure = Configure();
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
time_tol = end_time;

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


%%  **************************** ENVIRONMENT *****************************
env = load('gridmap-2.mat').map;
r_o = configure.obstacle_radius + configure.radius;
r_p = configure.privacy_radius + configure.radius;
% r_o = configure.obstacle_radius + configure.obstacle_max + configure.radius;
% r_p = configure.privacy_radius + configure.privacy_max + configure.radius;
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);

for i = 1: length_o
    r=r_o;
    ox0=env.obstacle_list(i,1);
    oy0=env.obstacle_list(i,2);
    oz0=env.obstacle_list(i,3);
    [ox,oy,oz]=sphere;
    mesh(ox0+r*ox,oy0+r*oy,oz0+r*oz)
    hold on
end

for i = 1: length_p
    r=r_p;
    px0=env.privacy_list(i,1);
    py0=env.privacy_list(i,2);
    pz0=env.privacy_list(i,3);
    [px,py,pz]=sphere;
    mesh(px0+r*px,py0+r*py,pz0+r*pz)
    hold on
end

% maplabel = importdata('maplabel_privacy.txt');
% map_height = importdata('maplabel_height_update.txt');
% obstacle_s = [];
% privacy_s = [];
% obstacle_l = [];
% privacy_l = [];
% [a1,b1] = size(maplabel);
% 
% for i = 1:a1
%     for j = 1:b1
%         if maplabel(i,j) == 1
%             height = map_height(i,j)/10;
%             obstacle_s = [obstacle_s; i-1, j-1, 0];
%             obstacle_l = [obstacle_l; 1, 1, height];
%         elseif maplabel(i,j) == 2 || maplabel(i,j) == 3 || maplabel(i,j) == 4
%             height = map_height(i,j)/10;
%             privacy_s = [privacy_s; i-1, j-1, 0];
%             privacy_l = [privacy_l; 1, 1, height];
%         end
%     end
% end
% [ao,bo] = size(obstacle_s);
% [ap,bp] = size(privacy_s);
% for i = 1:ao
%     boxsurface(obstacle_s(i,:),obstacle_l(i,:),1)
%     hold on
% end
% for i = 1:ap
%     boxsurface(privacy_s(i,:),privacy_l(i,:),2)
%     hold on
% end
%% *********************** INITIAL CONDITIONS ***********************
fprintf('Setting initial conditions...\n')
max_iter  = 5000;      % max iteration
starttime = start_time;
% starttime = 2;         % start of simulation in seconds
tstep     = 0.01;      % this determines the time step at which the solution is given
cstep     = 0.05;      % image capture time interval
nstep     = cstep/tstep;
time      = starttime; % current time
err = []; % runtime errors

for qn = 1:nquad
    % Get start and stop position
    des_start = trajhandle(start_time, qn);
    des_start.pos;
    des_stop  = trajhandle(end_time, qn);
    des_stop.pos;
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

%% ************************* RUN SIMULATION *************************
OUTPUT_TO_VIDEO = 1;
if OUTPUT_TO_VIDEO == 1
    v = VideoWriter('navigation.avi');
    open(v)
end

fprintf('Simulation Running....')
% Main loop
for iter = 1:max_iter
    iter;
    timeint = time:tstep:time+cstep;

    tic;
    % Iterate over each quad
    for qn = 1:nquad
        % Initialize quad plot
        if iter == 1
            QP{qn} = QuadPlot(qn, x0{qn}, 0.1, 0.04, quadcolors(qn,:), max_iter, h_3d);
            desired_state = trajhandle(time, qn);
            QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time);
            h_title = title(sprintf('iteration: %d, time: %4.2f', iter, time));
        end

        % Run simulation
        [tsave, xsave] = ode45(@(t,s) quadEOM(t, s, qn, controlhandle, trajhandle, params), timeint, x{qn});
        x{qn}    = xsave(end, :)';
        
        % Save to traj
        xtraj{qn}((iter-1)*nstep+1:iter*nstep,:) = xsave(1:end-1,:);
        ttraj{qn}((iter-1)*nstep+1:iter*nstep) = tsave(1:end-1);

        % Update quad plot
       
        desired_state = trajhandle(time + cstep, qn);
        QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time + cstep);
        set(h_title, 'String', sprintf('iteration: %d, time: %4.2f', iter, time + cstep));
        if OUTPUT_TO_VIDEO == 1
            im = frame2im(getframe(gcf));
            writeVideo(v,im);
        end
    end
    
%     if mod(time,0.5)==0
%        desired_state = trajhandle(time, qn);
%        real_trajectory = [real_trajectory;desired_state.pos]; 
%     end
    
    time = time + cstep; % Update simulation time
    
    t = toc;
    % Check to make sure ode45 is not timing out
    if(t> cstep*500)
        err = 'Ode45 Unstable';
        break;
    end

    % Pause to make real-time
    if real_time && (t < cstep)
        pause(cstep - t);
    end
    
    % Pause for planning
    if mod(time,time_step)== 0 && time > 0
        k = ceil(time/time_step);
        planning_time(k);
        pause(planning_time(k));
    end
    
    % Check termination criteria
    if terminate_check(x, time, stop, pos_tol, vel_tol, time_tol)
        break
    end
end

if OUTPUT_TO_VIDEO == 1
    close(v);
end

%% ************************* POST PROCESSING *************************
% Truncate xtraj and ttraj
for qn = 1:nquad
    xtraj{qn} = xtraj{qn}(1:iter*nstep,:);
    ttraj{qn} = ttraj{qn}(1:iter*nstep);
end

% Plot the saved position and velocity of each robot
for qn = 1:nquad
    % Truncate saved variables
    QP{qn}.TruncateHist();
    % Plot position for each quad
    h_pos{qn} = figure('Name', ['Quad ' num2str(qn) ' : position']);
    plot_state(h_pos{qn}, QP{qn}.state_hist(1:3,:), QP{qn}.time_hist, 'pos', 'vic');
    plot_state(h_pos{qn}, QP{qn}.state_des_hist(1:3,:), QP{qn}.time_hist, 'pos', 'des');
    % Plot velocity for each quad
    h_vel{qn} = figure('Name', ['Quad ' num2str(qn) ' : velocity']);
    plot_state(h_vel{qn}, QP{qn}.state_hist(4:6,:), QP{qn}.time_hist, 'vel', 'vic');
    plot_state(h_vel{qn}, QP{qn}.state_des_hist(4:6,:), QP{qn}.time_hist, 'vel', 'des');
end
if(~isempty(err))
    error(err);
end

fprintf('finished.\n')
end
