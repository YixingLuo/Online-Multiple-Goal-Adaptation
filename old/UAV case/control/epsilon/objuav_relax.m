function f = objuav_relax(x)
global configure
global initial_N
global env_known
temp_f = x(end)/configure.battery_budget + x(end-1)/configure.Time_budget + x(end-2);
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

sum_x = 0;
num_x = 0;
if bound_o > 0
    for j = 1: bound_o
        x_index = 4*(initial_N + 1) + j;
        sum_x = sum_x + x(x_index);
        if x(x_index)>0
            num_x = num_x + 1;
        end
    end
%     sum_x = sum_x/(bound_o * configure.obstacle_max);
    if num_x > 0
        sum_x = sum_x/(num_x * configure.obstacle_max);
    end
end

sum_y = 0;
num_y = 0;
if bound_p > 0
    for j = 1: bound_p
        x_index = 4*(initial_N + 1) + bound_o + j;
        sum_y = sum_y + x(x_index);
        if x(x_index)>0
            num_y = num_y + 1;
        end
    end
%     sum_y = sum_y/(bound_p * configure.privacy_max);
    if num_y > 0
        sum_y = sum_y/(num_y * configure.privacy_max);
    end
end

f = sum_x + sum_y + temp_f;

%% DS safety, privacy
% length_o = 0;
% width_o = 0;
% length_p = 0;
% width_p = 0;
% [length_o, width_o] = size(env_known.obstacle_list);
% [length_p, width_p] = size(env_known.privacy_list);
% bound_o = length_o * (initial_N+1);
% bound_p = length_p * (initial_N+1);
% dis_o = zeros(initial_N+1,length_o);
% dis_p = zeros(initial_N+1,length_p);
% bound_o = length_o * (initial_N);
% bound_p = length_p * (initial_N);
% dis_o = zeros(initial_N,length_o);
% dis_p = zeros(initial_N,length_p);
% 
% if length_o> 0
%     for i = 1:initial_N
% for i = 1:initial_N + 1
%     left = [p_x(i),p_y(i),p_z(i)];
%     right = [p_x(i+1),p_y(i+1),p_z(i+1)];
%     lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
%     rl = [left(1)-right(1), left(2)-right(2),left(3)-right(3)];
%     for j = 1: length_o
%         obstacle = env_known.obstacle_list(j,:);
%         lo = [obstacle(1)-left(1), obstacle(2)-left(2), obstacle(3)-left(3)];
%         ro = [obstacle(1)-right(1), obstacle(2)-right(2), obstacle(3)-right(3)];
%         if dot(lo, lr)<0 || dot(lo, rl)<0
%             dis_o(i,j)= min(norm(lo),norm(ro));
%         else
%             angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
%             dis_o(i,j) = sin(angle)*norm(lo);
%         end
%         
%     end
% end
% end
% 
% if length_p > 0
%     for i = 1:initial_N
% for i = 1:initial_N + 1
%     left = [p_x(i),p_y(i),p_z(i)];
%     right = [p_x(i+1),p_y(i+1),p_z(i+1)];
%     lr = [right(1)-left(1), right(2)-left(2), right(3)-left(3)];
%     rl = [left(1)-right(1), left(2)-right(2),left(3)-right(3)];
%     for j = 1: length_p
%         privacy = env_known.privacy_list(j,:);
%         lo = [privacy(1)-left(1), privacy(2)-left(2), privacy(3)-left(3)];
%         ro = [privacy(1)-right(1), privacy(2)-right(2), privacy(3)-right(3)];
%         if dot(lo, lr)<0 || dot(lo, rl)<0
%             dis_p(i,j)= min(norm(lo),norm(ro));
%         else
%             angle = acos(dot(lo, lr)/(norm(lo)*norm(lr)));
%             dis_p(i,j) = sin(angle)*norm(lo);
%         end
%     end
% end
% end
% SR = 0;
% for j = 1: length_o
%     for i = 1:initial_N
%     for i = 1:initial_N + 1
%         SR = SR + min(1,(dis_o(i, j)-(configure.radius + configure.obstacle_radius))/configure.obstacle_max);
%     end
% end
% PR = 0;
% for j = 1: length_p
%     for i = 1:initial_N
%     for i = 1:initial_N + 1
%         PR = PR + min(1,(dis_p(i, j)-(configure.radius + configure.privacy_radius))/configure.privacy_max);
%     end
% end
% 
% 
% % 1118
% f = 0;
% if x(end-2) > 0
%     f = f + x(end-2)/(configure.forensic_target-configure.forensic_budget);
% end
% if x(end-1) > 0
%     f = f + x(end-1)/(configure.Time_budget-configure.Time_target) ;
% end
% if x(end) > 0
%     f = f + x(end)/(configure.battery_budget-configure.battery_target) ;
% end
% if bound_o > 0 && (SR/bound_o)  > 0
%     f = f + SR/bound_o ;
% end
% if bound_p > 0 && (PR/bound_p)  > 0
%     f = f + PR/bound_p ;
% end
% % f = x(end-4) + x(end-3) + x(end-2)/(configure.forensic_target-configure.forensic_budget)+ x(end-1)/(configure.Time_budget-configure.Time_target)+ x(end)/(configure.battery_budget-configure.battery_target) ;