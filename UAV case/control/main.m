clc
clear
data1 = [];
data2 = [];
data3 = [];
trajectory1 = [];
trajectory2 = [];
trajectory3 = [];
velocity_history1 = [];
velocity_history2 = [];
velocity_history3 = [];
planningtime1 = [];
planningtime2 = [];
planningtime3 = [];

global eplison
eplison = 1e-3;
num_obs = [10];
for nobs = 1:length(num_obs)
    for i = 1:5
%         flag = 0; %% have no solution at initial point
%         while flag == 0
%             map_initialize(num, num_obs(nobs));
%             [data, trajectory,velocity_history,planning_time, flag] = uav_initial(num);
%         end   

        num = (nobs-1)*10 + i;
        map_initialize(num, num_obs(nobs));        
%         for j = 1:3
            [data, trajectory,velocity_history,planning_time] = uav_normal(num);
            data1 = [data1 ; data];
            trajectory1 = [trajectory1; trajectory];
            velocity_history1 = [velocity_history1; velocity_history];
            planningtime1 = [planningtime1; planning_time];
%         end

%         for j = 1:3
            [data, trajectory,velocity_history,planning_time] = uav_relax(num);
            data2 = [data2; data]; 
            trajectory2 = [trajectory2; trajectory];
            velocity_history2 = [velocity_history2; velocity_history];
            planningtime2 = [planningtime2; planning_time];
%         end
    
%         for j = 1:3
            [data, trajectory,velocity_history,planning_time] = uav_relaxation(num);
            data3 = [data3; data];
            trajectory3 = [trajectory3; trajectory];
            velocity_history3 = [velocity_history3; velocity_history];
            planningtime3 = [planningtime3; planning_time];
%         end

        if mod(num,5)==0
            time = datestr(now,30);
            name = 'data' + string(time) + '.mat';
            save(name);
            data1 = [];
            data2 = [];
            data3 = [];
            trajectory1 = [];
            trajectory2 = [];
            trajectory3 = [];
            velocity_history1 = [];
            velocity_history2 = [];
            velocity_history3 = [];
            planningtime1 = [];
            planningtime2 = [];
            planningtime3 = [];
        end
    end
end


