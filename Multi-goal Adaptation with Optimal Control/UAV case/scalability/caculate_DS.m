function [DS_S, DS_P] =  caculate_DS(current_point, env_known)

global configure
%% DS safety, privacy
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env_known.obstacle_list);
[length_p, width_p] = size(env_known.privacy_list);
bound_o = length_o ;
bound_p = length_p ;
dis_o = zeros(1,length_o);
dis_p = zeros(1,length_p);

if length_o> 0
    for j = 1: length_o
        obstacle = env_known.obstacle_list(j,:);
        dis_o(1,j) = sqrt((current_point(1) - obstacle(1)).^2 + (current_point(2) - obstacle(2)).^2 + (current_point(3) - obstacle(3)).^2);
    end
end

if length_p > 0
    for j = 1: length_p
        privacy = env_known.privacy_list(j,:);
        dis_p(1,j) = sqrt((current_point(1) - privacy(1)).^2 + (current_point(2) - privacy(2)).^2 + (current_point(3) - privacy(3)).^2);
    end
end

SR = 0;
num_o = 0;
for j = 1: length_o
    safety_risk = max(0,((configure.radius + configure.obstacle_radius + configure.obstacle_max) - dis_o(1, j))/configure.obstacle_max);
    SR = SR + safety_risk;
    if safety_risk > 0
        num_o = num_o + 1;
    end
end

PR = 0;
num_p = 0;
for j = 1: length_p
    disk_risk = max(0,((configure.radius + configure.privacy_radius + configure.privacy_max) - dis_p(1, j))/configure.privacy_max);       
    omega = current_point(4);
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


if bound_o > 0
	DS_S = 1 - SR/bound_o;
else
    DS_S = 1;
end

if bound_p > 0
	DS_P = 1 - PR/bound_p;
else
    DS_P = 1;
end