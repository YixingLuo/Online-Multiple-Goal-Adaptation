function [safety_ratio, privacy_ratio,  info_ratio,  time_ratio, energy_ratio] = goal_selection2(x)

global configure
global initial_N
global env_known
% temp_f = x(end) + x(end-1) + x(end-2);
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env_known.obstacle_list);
[length_p, width_p] = size(env_known.privacy_list);
bound_o = length_o * (initial_N+1);
bound_p = length_p * (initial_N+1);
dis_o = zeros(initial_N+1,length_o);
dis_p = zeros(initial_N+1,length_p);

y = zeros(bound_o + bound_p + 3);
for i = 1:(bound_o + bound_p + 3)
    if (x(end-(bound_o + bound_p + 3) + i)>0.5)
        y(i) = 1;
    end
end
energy_ratio = x(end-(bound_o + bound_p + 3))/(configure.battery_budget-configure.battery_target);
time_ratio = x(end-(bound_o + bound_p + 3)-1)/(configure.Time_budget-configure.Time_target);
info_ratio = x(end-(bound_o + bound_p + 3)-2)/(configure.forensic_target-configure.forensic_budget);

sum_x = 0;
num_x = 0;
if bound_o > 0
    for j = 1: bound_o
        x_index = 4*(initial_N + 1) + j;
        sum_x = sum_x + y(j)*x(x_index);
        if x(x_index)>0
            num_x = num_x + 1;
        end
    end
%     sum_x = sum_x/(bound_o * configure.obstacle_max);
    if num_x > 0
        sum_x = sum_x/(num_x * configure.obstacle_max);
    end
end
safety_ratio = sum_x;

sum_y = 0;
num_y = 0;
if bound_p > 0
    for j = 1: bound_p
        x_index = 4*(initial_N + 1) + bound_o + j;
        sum_y = sum_y + y(bound_o + j)*x(x_index);
        if x(x_index)>0
            num_y = num_y + 1;
        end
    end
%     sum_y = sum_y/(bound_p * configure.privacy_max);
    if num_y > 0
        sum_y = sum_y/(num_y * configure.privacy_max);
    end
end

privacy_ratio = sum_y;
