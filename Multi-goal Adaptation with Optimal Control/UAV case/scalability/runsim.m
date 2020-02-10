global configure
configure = Configure();
tau = configure.Time_step;
start_time = 0;
a = load ('velocity_history_50_0210.mat');
velocity_history = a.velocity_history;
end_time = (length(velocity_history))*tau;
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
a = load('planningtime_50_0210.mat');
planning_time = a.planning_time;
a = load ('velocity_history_50_0210.mat');
velocity_history = a.velocity_history;
a = load('trajectory_50_0210.mat');
trajectory = a.trajectory;
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



%%  **************************** ENVIRONMENT *****************************
gridmap = load('gridmap-50.mat');
env = gridmap.map;
% r_o = configure.obstacle_radius ;
% r_p = configure.privacy_radius ;
% % r_o = configure.obstacle_radius + configure.obstacle_max + configure.radius;
% % r_p = configure.privacy_radius + configure.privacy_max + configure.radius;
% length_o = 0;
% width_o = 0;
% length_p = 0;
% width_p = 0;
% [length_o, width_o] = size(env.obstacle_list);
% [length_p, width_p] = size(env.privacy_list);
% axis_pos= [0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z];
% ax1 = axes;
% for i = 1: length_o
%     r=r_o;
%     ox0=env.obstacle_list(i,1);
%     oy0=env.obstacle_list(i,2);
%     oz0=env.obstacle_list(i,3);
%     [ox,oy,oz]=sphere;
%     mesh(ox0+r*ox,oy0+r*oy,oz0+r*oz);
% %     shading flat
%     hold on
% end
% box on
% axis on
% % hidden off
% axis(axis_pos);
% colormap(ax1,winter);
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% set(gca,'fontname','Times')
% view(60,45);
% 
% ax2 = axes;
% for i = 1: length_p
%     r=r_p;
%     px0=env.privacy_list(i,1);
%     py0=env.privacy_list(i,2);
%     pz0=env.privacy_list(i,3);
%     [px,py,pz]=sphere;
%     mesh(px0+r*px,py0+r*py,pz0+r*pz)
%     hold on
% end
% % box off
% axis off
% % hidden off
% axis(axis_pos );
% colormap(ax2,autumn);
% view(60,45);
% xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
% set(gca,'fontname','Times');

h_3d = gca;
% axis on
grid on
view(60,45);
quadcolors = lines(nquad);
set(gca,'fontname','Times');
set(gcf,'Renderer','OpenGL')


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
OUTPUT_TO_VIDEO = 0;
if OUTPUT_TO_VIDEO == 1
    v = VideoWriter('navigation-100','MPEG-4');
%     v.FrameRate = 30;
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
%             h_title = title(sprintf('iteration: %d, time: %4.2f s', iter, time));
%             h_title = title(sprintf('Time: %4.2f s', time));
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            set(gca,'fontname','Times')
            axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z]);
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
%         set(h_title, 'String', sprintf('iteration: %d, time: %4.2f s', iter, time + cstep));
%         set(h_title, 'String',(sprintf('Time: %4.2f s', time + cstep)));
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        set(gca,'fontname','Times')
        axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z]);
        
        if OUTPUT_TO_VIDEO == 1
            frame = getframe(gcf);
%             frame.cdata = imresize(frame.cdata, [1080 1920]); %// 设置视频宽高：H为行数(高)，W为列数(宽)
            im = frame2im(frame);
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
    temp = floor(time*10);
    if mod(temp,5)== 0 && time > 0 && time <= length(planning_time)*time_step
        k = ceil(time/time_step);
        planning_time(k);
        pause_time = max(0,planning_time(k)-time_step);
        pause(pause_time);
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
    positions = QP{qn}.state_hist(1:3,:);
    for i = 1:size(positions,2)-1
        index = min(ceil(i/10),120);
        positions(4,i) = velocity_history(index,4)*100;
    end
    positions(4,end) = positions(4,end-1);
    plot_state(h_pos{qn}, positions, QP{qn}.time_hist, 'pos', 'vic');
    des_positions = QP{qn}.state_des_hist(1:3,:);
    for i = 1:size(positions,2)-1
        index = min(ceil(i/10),120);
        des_positions(4,i) = velocity_history(index,4)*100;
    end
    des_positions(4,end) = des_positions(4,end-1);
    plot_state(h_pos{qn},des_positions, QP{qn}.time_hist, 'pos', 'des');
    
    % Plot velocity for each quad
    h_vel{qn} = figure('Name', ['Quad ' num2str(qn) ' : velocity']);
    velocity = QP{qn}.state_hist(4:6,:);
    for i = 1:size(velocity,2)-1
        index = min(ceil(i/10),120);
        velocity(4,i) = velocity_history(index,4)*100;
    end
    velocity(4,end) = velocity(4,end-1);
    plot_state(h_vel{qn}, velocity, QP{qn}.time_hist, 'vel', 'vic');
    
    des_velocity = QP{qn}.state_des_hist(4:6,:);
    for i = 1:size(velocity,2)-1
        index = min(ceil(i/10),120);
        des_velocity(4,i) = velocity_history(index,4)*100;
    end
    des_velocity(4,end) = des_velocity(4,end-1);
    plot_state(h_vel{qn}, des_velocity, QP{qn}.time_hist, 'vel', 'des');
    
end
if(~isempty(err))
    error(err);
end

fprintf('finished.\n')
end
