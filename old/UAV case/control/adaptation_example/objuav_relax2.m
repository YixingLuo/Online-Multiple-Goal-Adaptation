function f = objuav_relax2(x)
global configure
global env_known
global initial_N
global current_point
tau = configure.Time_step;
p_x = [];
p_y = [];
p_z = [];
p_x(1) = current_point(1);
p_y(1) = current_point(2);
p_z(1) = current_point(3);

for i = 1: initial_N
     p_x(i+1) = x(i)*tau + p_x(i);
     p_y(i+1) = x(i+(initial_N + 1))*tau + p_y(i);
     p_z(i+1) = x(i+2*(initial_N + 1))*tau + p_z(i);
end
p_x = [p_x, configure.end_point(1)];
p_y = [p_y, configure.end_point(2)];
p_z = [p_z, configure.end_point(3)];


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

temp_f = x(end)/(configure.battery_budget-configure.battery_target) + x(end-1)/(configure.Time_budget-configure.Time_target) + x(end-2)/(configure.forensic_target-configure.forensic_budget);
% f = temp_f + x(end-4)/configure.obstacle_max + x(end-3)/configure.privacy_max;
f = temp_f;


if length_o> 0
    for i = 1:initial_N + 1
        for j = 1: length_o
            obstacle = env_known.obstacle_list(j,:);
            dis_o(i,j) = sqrt((p_x(i) - obstacle(1)).^2 + (p_y(i) - obstacle(2)).^2 + (p_z(i) - obstacle(3)).^2);
        end
    end
end

if length_p > 0
    for i = 1:initial_N + 1
        for j = 1: length_p
            privacy = env_known.privacy_list(j,:);
            dis_p(i,j) = sqrt((p_x(i) - privacy(1)).^2 + (p_y(i) - privacy(2)).^2 + (p_z(i) - privacy(3)).^2);
        end
    end
end


SR = 0;
num_o = 0;
for j = 1: length_o
    for i = 1:initial_N + 1
        safety_risk = max(0,((configure.radius + configure.obstacle_radius + configure.obstacle_max) - dis_o(i, j))/configure.obstacle_max);
        SR = SR + safety_risk;
        if safety_risk > 0
            num_o = num_o + 1;
        end
    end
end

PR = 0;
num_p = 0;
for j = 1: length_p
    for i = 1:initial_N + 1
        disk_risk = max(0,((configure.radius + configure.privacy_radius + configure.privacy_max) - dis_p(i, j))/configure.privacy_max);       
        omega = x(3*(initial_N + 1)+i);
        if disk_risk > 0
            privacy_risk = disk_risk*omega;
        else
            privacy_risk = 0;
        end
        PR = PR + privacy_risk;
        if privacy_risk > 0
            num_p = num_p + 1;
        end
    end
end
if num_p > 0
    f = f + PR/num_p;
end
if num_o > 0
    f = f + SR/num_o;
end