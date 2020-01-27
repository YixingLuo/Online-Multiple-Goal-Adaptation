function [desired_state] = navigation(t, qn)
global velocity_history
global trajectory
global configure
[a,b] = size(trajectory);
% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables
% time_tol = 0.5;
% length = 0.5;
% k1 = t/0.5;
% if k1 <= 0 
%     pos = [0;0;0];
%     vel = [0;0;0];
%     acc = [0;0;0];
% else
%     pos = [trajectory(k1,1);trajectory(k1,2);trajectory(k1,3)];
%     vel = [velocity_history(k1,1);velocity_history(k1,2);velocity_history(k1,3)];
%     acc = [0;0;0];
% end
% 
% yaw = 0;
% yawdot = 0;
% time_tol = 3;
dt = 0.0001;
global time_step 
global time_tol
    function [pos, vel] = get_pos_vel(t)
        k_start = floor(t/time_step);
        k_end = ceil(t/time_step);
        k = time_tol/time_step;
        if t >= time_tol
            pos = [trajectory(k,1);trajectory(k,2);trajectory(k,3)];
            vel = [velocity_history(k,1);velocity_history(k,2);velocity_history(k,3)];
        elseif k_start == 0 && k_end == 0
            pos = [0;0;0];
            vel = [0;0;0];
        elseif k_start == 0 && k_end ~= 0
            [pos, vel, ~] = tj_from_line([0;0;0],[trajectory(k_end,1);trajectory(k_end,2);trajectory(k_end,3)], k_end, t);
        else
            [pos, vel, ~] = tj_from_line([trajectory(k_start,1);trajectory(k_start,2);trajectory(k_start,3)],[trajectory(k_end,1);trajectory(k_end,2);trajectory(k_end,3)], k_end, t - 0.5*k_start);
        end
    end

    if t >= time_tol
        pos = [configure.end_point(1);configure.end_point(2);configure.end_point(3)];
        vel = [0;0;0];
        acc = [0;0;0];
    elseif t == 0
        pos = [configure.start_point(1);configure.start_point(2);configure.start_point(3)];
        vel = [0;0;0];
        acc = [0;0;0];
    else
        [pos, vel] = get_pos_vel(t);
        [~, vel1] = get_pos_vel(t+dt);
        acc = (vel1-vel)/dt;
    end

    
yaw = 0;
yawdot = 0;
% =================== Your code ends here ===================

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

end
