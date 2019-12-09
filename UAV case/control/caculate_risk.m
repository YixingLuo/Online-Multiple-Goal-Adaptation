function [SR, PR] = caculate_risk(trajectory, env)
global configure
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);
configure = Configure();

[a, b] = size(trajectory);
p_x=[];
p_y=[];
p_z=[];
for i =1:a
    p_x = [p_x, trajectory(i,1)];
    p_y = [p_y, trajectory(i,2)];
    p_z = [p_z, trajectory(i,3)];            
end

bound_o = length_o * (a-1);
bound_p = length_p * (a-1);
dis_o = zeros(a-1,length_o);
dis_p = zeros(a-1,length_p);

if length_o > 0
for i = 1:a-1
    left = [p_x(i),p_y(i),p_z(i)];
    right = [p_x(i+1),p_y(i+1),p_z(i+1)];
    lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
    rl = [left(1)-right(1), left(2)-right(2),left(3)-right(3)];
    for j = 1: length_o
        obstacle = env.obstacle_list(j,:);
        lo = [obstacle(1)-left(1), obstacle(2)-left(2), obstacle(3)-left(3)];
        ro = [obstacle(1)-right(1), obstacle(2)-right(2), obstacle(3)-right(3)];
        if dot(lo, lr)<0 || dot(lo, rl)<0
            dis_o(i,j)= min(norm(lo),norm(ro));
        else
            angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
            dis_o(i,j) = sin(angle)*norm(lo);
        end
        
    end
end
end

if length_p > 0
for i = 1:a-1
    left = [p_x(i),p_y(i),p_z(i)];
    right = [p_x(i+1),p_y(i+1),p_z(i+1)];
    lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
    rl = [left(1)-right(1), left(2)-right(2),left(3)-right(3)];
    for j = 1: length_p
        privacy = env.privacy_list(j,:);
        lo = [privacy(1)-left(1), privacy(2)-left(2), privacy(3)-left(3)];
        ro = [privacy(1)-right(1), privacy(2)-right(2), privacy(3)-right(3)];
        if dot(lo, lr)<0 || dot(lo, rl)<0
            dis_p(i,j)= min(norm(lo),norm(ro));
        else
            angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
            dis_p(i,j) = sin(angle)*norm(lo);
        end
    end
end
end

SR = 0;
num_o = 0;
for j = 1: length_o
    for i = 1:a-1
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
    for i = 1:a-1
%         PR = PR + min(1,(dis_p(i, j)-(configure.radius + configure.privacy_radius))/configure.privacy_max);
        disk_risk = max(0,((configure.radius + configure.privacy_radius + configure.privacy_max) - dis_p(i, j))/configure.privacy_max);
        omega = trajectory(i,4);
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

% if bound_o>0
%     SR = SR/bound_o;
% end
% if bound_p>0
%     PR = PR/bound_p;
% end

if num_o > 0
    SR = SR/num_o;
end
if num_p > 0
    PR = PR/num_p;
end