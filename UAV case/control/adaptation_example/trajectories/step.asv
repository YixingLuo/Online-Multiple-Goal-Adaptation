function [desired_state] = step(t, qn)
% Hover trajectory generator for a circle

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables
time_tol = 0.5*50;

k_start = floor(t/0.5);
k_end = ceil(t/0.5);
if t >= time_tol
    pos = [9;9;9];
    vel = [0;0;0];
elseif k_start == 0 && k_end == 0
    pos = [0;0;0];
    vel = [1;1;1];
elseif k_start == 0 && k_end ~= 0
    [pos, vel, ~] = tj_from_line([0;0;0],[trajectory(k_end,1);trajectory(k_end,2);trajectory(k_end,3)], k_end, t);
else
    [pos, vel, ~] = tj_from_line([trajectory(k_start,1);trajectory(k_start,2);trajectory(k_start,3)],[trajectory(k_end,1);trajectory(k_end,2);trajectory(k_end,3)], k_end, t - 0.5*k_start)
end


if t <= 0
    pos = [0;0;0];
    vel = [0;0;0];
    acc = [0;0;0];
else
%     pos = [1;0;0];
    pos = [0.500000000000000,0.500000000000000,0.500000000000000];
    vel = [1;1;1];
    acc = [0;0;0];
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
