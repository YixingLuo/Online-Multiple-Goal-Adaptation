function f = objuav_normal(x)
x;
sum = 0;
global configure
global initial_N
global env_known
global configure
global current_point
global time
global ratio
global energy
global information
global past_distance
global eplison

f=[];
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

% time_list = [];
% if x(initial_N + 1) ~= 0
%     time_x = (p_x(end)-p_x(end-1))/x(initial_N + 1);
%     time_list = [time_list, time_x];
% else
%     time_x = 0;
% end
% if x(2*(initial_N + 1)) ~= 0
%     time_y = (p_y(end)-p_y(end-1))/x(2*(initial_N + 1));
%     time_list = [time_list, time_y];
% else
%     time_y = 0;
% end
% if x(3*(initial_N + 1)) ~= 0
%     time_z = (p_z(end)-p_z(end-1))/x(3*(initial_N + 1));
%     time_list = [time_list, time_z];
% else
%     time_z = 0;
% end
% 
% if length(time_list) > 0
%     time_now = time + initial_N*tau + time_list(1);
% else
%     time_now = time + initial_N*tau;
% end

if x(initial_N + 1) == 0 && x(2*(initial_N + 1))== 0 && x(3*(initial_N + 1))==0
    time_now = time + initial_N*tau;
    last_info = 0;
else
%     time_now = time + initial_N*tau + time_x;
    time_now = time + initial_N*tau + sqrt((p_x(end)-p_x(initial_N + 1)).^2+(p_y(end)-p_y(initial_N + 1)).^2+(p_z(end)-p_z(initial_N + 1)).^2) /sqrt(x(initial_N + 1).^2+x(2*(initial_N + 1)).^2+x(3*(initial_N + 1)).^2);
    last_info = x(4*(initial_N + 1))*sqrt((p_x(end)-p_x(initial_N + 1)).^2+(p_y(end)-p_y(initial_N + 1)).^2+(p_z(end)-p_z(initial_N + 1)).^2) /sqrt(x(initial_N + 1).^2+x(2*(initial_N + 1)).^2+x(3*(initial_N + 1)).^2);
end

distance = 0;
energy_now = 0;
info_now = 0;
for i = 1:initial_N + 1
    temp_dis = sqrt((p_x(i+1)-p_x(i)).^2+(p_y(i+1)-p_y(i)).^2+(p_z(i+1)-p_z(i)).^2);
    distance = distance + temp_dis;
    energy_now = energy_now + configure.battery_per * x(3*(initial_N + 1)+i) * tau + sqrt((p_x(i+1)-p_x(i)).^2+(p_y(i+1)-p_y(i)).^2+(p_z(i+1)-p_z(i)).^2);    
%     info_now = info_now + x(3*(initial_N + 1)+i)*sqrt((p_x(i+1)-p_x(i)).^2+(p_y(i+1)-p_y(i)).^2+(p_z(i+1)-p_z(i)).^2);
%     time_now = time_now + temp_dis/sqrt(x(i).^2+x((initial_N + 1) + i).^2+x(2*(initial_N + 1) + i).^2);
end

for i = 1:initial_N
    energy_now = energy_now + configure.battery_per2 * sqrt((x(i+1)-x(i)).^2+(x(2*(initial_N + 1)+i+1)-x(2*(initial_N + 1)+i)).^2+(x(3*(initial_N + 1)+i+1)-x(3*(initial_N + 1)+i)).^2); 
end

for i = 1:initial_N 
    info_now = info_now + x(3*(initial_N + 1)+i) * tau;
end
energy_now = energy + energy_now;
% info_now, information, distance,past_distance
% info_now = (information * past_distance + info_now) / (past_distance + distance);
info_now = (information * time + info_now + last_info)/(time_now);



%% DS safety, privacy
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
% bound_o = length_o * (initial_N);
% bound_p = length_p * (initial_N);
% dis_o = zeros(initial_N,length_o);
% dis_p = zeros(initial_N,length_p);

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
%         SR = SR + min(1,(dis_o(i, j)-(configure.radius + configure.obstacle_radius))/configure.obstacle_max);
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
%         PR = PR + min(1,(dis_p(i, j)-(configure.radius + configure.privacy_radius))/configure.privacy_max);
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

f = 0;
f = f + (configure.forensic_target-info_now).^2;
f = f + ((time_now -  configure.Time_target)/configure.Time_budget).^2;
f = f + ((energy_now - configure.battery_target)/configure.battery_budget).^2;

if num_o > 0
    f = f + (SR/num_o).^2;
end

if num_p > 0
    f = f + (PR/num_p).^2;
end

% f = 0;
% if num_o > 0
%     f = f + SR/num_o;
% end
% 
% if num_p > 0
%     f = f + PR/num_p;
% end
% 
% f = f + (1-info_now).^2; 
% f = f + ((time_now )/ (configure.Time_budget)).^2;
% f = f + ((energy_now)/ (configure.battery_budget)).^2;


