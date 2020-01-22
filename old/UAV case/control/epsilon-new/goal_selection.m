function [safety_variance, safety_ratio, privacy_variance, privacy_ratio, info_variance, info_ratio, time_variance, time_ratio, energy_variance, energy_ratio] = goal_selection(x)

global env_known
global initial_N
global configure
info_variance = x(end-2);
time_variance = x(end-1);
energy_variance = x(end);
safety_variance = 0;
privacy_variance = 0;

length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env_known.obstacle_list);
[length_p, width_p] = size(env_known.privacy_list);
bound_o = length_o * (initial_N+1);
bound_p = length_p * (initial_N+1);
num_o = 0;
for i = 1:bound_o
    safety_variance = safety_variance + x(4*(initial_N + 1) + i);
    if x(4*(initial_N + 1) + i) > 0
        num_o = num_o + 1;
    end
end
num_p = 0;
for i = 1:bound_p
    privacy_variance = privacy_variance + x(4*(initial_N + 1) + bound_o + i);
    if x(4*(initial_N + 1) + bound_o + i) > 0
        num_p = num_p + 1;
    end
end

safety_ratio = 0;
privacy_ratio = 0;
info_ratio = info_variance /(configure.forensic_target-configure.forensic_budget);
time_ratio = time_variance /(configure.Time_budget-configure.Time_target);
energy_ratio = energy_variance /(configure.battery_budget-configure.battery_target);
if bound_o > 0
    safety_ratio = safety_variance/(configure.obstacle_max * bound_o);
end
% if num_o > 0
%     safety_ratio = safety_variance/(configure.obstacle_max * num_o);
% end
if bound_p > 0
    privacy_ratio = privacy_variance/(configure.privacy_max * bound_p);
end
% if num_p > 0
%      privacy_ratio = privacy_variance/(configure.privacy_max * num_p);
% end

% f=[safety_variance, safety_ratio, privacy_variance, privacy_ratio, info_variance, info_ratio, time_variance, time_ratio, energy_variance, energy_ratio];


