function [c,ceq] = myconuav_normal(x)
c=[];
ceq=[];
global configure
global current_point
global time
global information
global energy
global past_distance
global env_known
global initial_N
global ratio
global eplison

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
     c = [c, -p_x(i+1), -p_y(i+1), -p_z(i+1)];
     c = [c, p_x(i+1)-(configure.grid_x-configure.radius), p_y(i+1)-(configure.grid_y-configure.radius), p_z(i+1)-(configure.grid_z-configure.radius)];
end

p_x = [p_x, configure.end_point(1)];
p_y = [p_y, configure.end_point(2)];
p_z = [p_z, configure.end_point(3)];

% time_to_destination = max((p_x(end)-p_x(initial_N + 1))/x(initial_N + 1), (p_y(end)-p_y(initial_N + 1))/x(2*(initial_N + 1)));
% time_to_destination = max(time_to_destination, (p_z(end)-p_z(initial_N + 1))/x(3*(initial_N + 1)));
% time_to_destination2 = min((p_x(end)-p_x(initial_N + 1))/x(initial_N + 1), (p_y(end)-p_y(initial_N + 1))/x(2*(initial_N + 1)));
% time_to_destination2 = min(time_to_destination, (p_z(end)-p_z(initial_N + 1))/x(3*(initial_N + 1)));

if x(initial_N + 1) ~= 0
    time_x = (p_x(end)-p_x(end-1))/x(initial_N + 1);
    c = [c, time + initial_N*tau + time_x - configure.Time_budget];
    c = [c, -time_x];
else
%     ceq = [ceq , p_x(end)-p_x(end-1)];
end
if x(2*(initial_N + 1)) ~= 0
    time_y = (p_y(end)-p_y(end-1))/x(2*(initial_N + 1));
    c = [c, time + initial_N*tau + time_y - configure.Time_budget];
    c = [c, -time_y];
else
%     ceq = [ceq , p_y(end)-p_y(end-1)];
end
if x(3*(initial_N + 1)) ~= 0
    time_z = (p_z(end)-p_z(end-1))/x(3*(initial_N + 1));
    c = [c, time + initial_N*tau + time_z - configure.Time_budget];
    c = [c, -time_z];
else
%     ceq = [ceq , p_z(end)-p_z(end-1)];
end
time_list = [];
if x(initial_N + 1) ~= 0
    time_x = (p_x(end)-p_x(end-1))/x(initial_N + 1);
    time_list = [time_list, time_x];
else
    time_x = 0;
end
if x(2*(initial_N + 1)) ~= 0
    time_y = (p_y(end)-p_y(end-1))/x(2*(initial_N + 1));
    time_list = [time_list, time_y];
else
    time_y = 0;
end
if x(3*(initial_N + 1)) ~= 0
    time_z = (p_z(end)-p_z(end-1))/x(3*(initial_N + 1));
    time_list = [time_list, time_z];
else
    time_z = 0;
end

for i = 1:length(time_list)
    c = [c, - time_list(i)];
end

if length(time_list) == 2
    ceq = [ceq , time_list(1)-time_list(2)];
    elseif length(time_list) == 3
        ceq = [ceq ,time_list(1)-time_list(2), time_list(3)-time_list(2)];
end

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


for j = 1: length_o
    for i = 1:initial_N  + 1
        c = [c, - dis_o(i, j) + (configure.radius + configure.obstacle_radius)];
    end
end


for j = 1: length_p
    for i = 1:initial_N + 1 
        c = [c, - dis_p(i, j) + (configure.radius + configure.privacy_radius)];
    end
end

c = [c, - info_now + configure.forensic_budget];
c = [c, time_now - configure.Time_budget];
c = [c, energy_now - configure.battery_budget];

