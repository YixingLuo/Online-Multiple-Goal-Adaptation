function f = objuav_relax3(x)
y = [0,0,0,0,0];
for i = 1:5
    if (x(end-5+1)>0.5)
        y(i) = 1;
    end
end
global configure
global env_known
global initial_N
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

temp_f = y(3)*x(end-5)/(configure.battery_budget-configure.battery_target) + y(4)*x(end-5-1)/(configure.Time_budget-configure.Time_target) + y(5)* x(end-5-2)/(configure.forensic_target-configure.forensic_budget);
f = temp_f;
f = 0;
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
    f = f + y(2)*PR/num_p;
end
if num_o > 0
    f = f + y(1)*SR/num_o;
end

