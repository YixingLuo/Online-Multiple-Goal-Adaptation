function simulation(tau,start_time,end_time,x,x0)
global xtraj
global ttraj
global x0
global quadcolors
global h_3d
global stop
global time_tol
global QP
% NOTE: This srcipt will not run as expected unless you fill in proper
% code in trajhandle and controlhandle
% You should not modify any part of this script except for the
% visualization part
%
% ***************** MEAM 620 QUADROTOR SIMULATION *****************
% close all
% clear all
time      = start_time;
tstep     = 0.01;
cstep     = 0.05;
max_iter  = (end_time - start_time)/tau;  
nquad     = 1;
trajhandle = @navigation;
controlhandle = @controller;
params = crazyflie();
nstep     = cstep/tstep;
real_time = true;
pos_tol   = 1e-3;
vel_tol   = 1e-3;

%% ************************* RUN SIMULATION *************************
% OUTPUT_TO_VIDEO = 1;
% if OUTPUT_TO_VIDEO == 1
%     v = VideoWriter('navigation.avi');
%     open(v)
% end

fprintf('Simulation Running....')
% Main loop
for iter = 1:max_iter
    iter;
    timeint = time:tstep:time+cstep;
    h_title = title(sprintf(' time: %4.2f', time));
    tic;
    % Iterate over each quad
    for qn = 1:nquad
        % Initialize quad plot
%         if iter == 1
%             QP{qn} = QuadPlot(qn, x0{qn}, 0.1, 0.04, quadcolors(qn,:), max_iter, h_3d);
%             desired_state = trajhandle(time, qn);
%             QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time);
%             h_title = title(sprintf('iteration: %d, time: %4.2f', iter, time));
%         end
        % Run simulation
        [tsave, xsave] = ode45(@(t,s) quadEOM(t, s, qn, controlhandle, trajhandle, params), timeint, x{qn});
        x{qn}    = xsave(end, :)';
        
        % Save to traj
        xtraj{qn}((iter-1)*nstep+1:iter*nstep,:) = xsave(1:end-1,:);
        ttraj{qn}((iter-1)*nstep+1:iter*nstep) = tsave(1:end-1);

        % Update quad plot
       
        desired_state = trajhandle(time + cstep, qn);
        QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time + cstep);
        set(h_title, 'String', sprintf('iteration: %d, time: %4.2f', iter, time + cstep))
%         if OUTPUT_TO_VIDEO == 1
%             im = frame2im(getframe(gcf));
%             writeVideo(v,im);
%         end
    end
    
%     if mod(time,0.5)==0
%        desired_state = trajhandle(time, qn);
%        real_trajectory = [real_trajectory;desired_state.pos]; 
%     end
    
    time = time + cstep; % Update simulation time
    
    t = toc;
    % Check to make sure ode45 is not timing out
    if(t> cstep*50)
        err = 'Ode45 Unstable';
        break;
    end

    % Pause to make real-time
    if real_time && (t < cstep)
        pause(cstep - t);
    end

    % Check termination criteria
    if terminate_check(x, time, stop, pos_tol, vel_tol, time_tol)
        break
    end
    
    
end

% if OUTPUT_TO_VIDEO == 1
%     close(v);
% end

%% ************************* POST PROCESSING *************************
% Truncate xtraj and ttraj
for qn = 1:nquad
    xtraj{qn} = xtraj{qn}(1:iter*nstep,:);
    ttraj{qn} = ttraj{qn}(1:iter*nstep);
end

% Plot the saved position and velocity of each robot
% for qn = 1:nquad
%     % Truncate saved variables
%     QP{qn}.TruncateHist();
%     % Plot position for each quad
%     h_pos{qn} = figure('Name', ['Quad ' num2str(qn) ' : position']);
%     plot_state(h_pos{qn}, QP{qn}.state_hist(1:3,:), QP{qn}.time_hist, 'pos', 'vic');
%     plot_state(h_pos{qn}, QP{qn}.state_des_hist(1:3,:), QP{qn}.time_hist, 'pos', 'des');
%     % Plot velocity for each quad
%     h_vel{qn} = figure('Name', ['Quad ' num2str(qn) ' : velocity']);
%     plot_state(h_vel{qn}, QP{qn}.state_hist(4:6,:), QP{qn}.time_hist, 'vel', 'vic');
%     plot_state(h_vel{qn}, QP{qn}.state_des_hist(4:6,:), QP{qn}.time_hist, 'vel', 'des');
% end
% if(~isempty(err))
%     error(err);
% end

fprintf('finished.\n')
end
