function f = objuav(x)
global configure
global initial_N
global env_known

temp_f =  x(end-1)/(configure.Time_budget-configure.Time_target) + x(end-2)/(configure.forensic_target - configure.forensic_budget);
% temp_f = x(end)/configure.battery_budget + x(end-1)/configure.Time_budget + x(end-2);
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
%     if num_x > 0
%         sum_x = sum_x/(num_x * configure.obstacle_max);
%     end
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
%     if num_y > 0
%         sum_y = sum_y/(num_y * configure.privacy_max);
%     end
end

sum_z = 0;
for i = (initial_N+1) * 3 + 1 : (initial_N+1) * 4
   sum_z = sum_z +  max(configure.forensic_target - x(i),0);
end

f = sum_x + sum_y + sum_z + temp_f;


