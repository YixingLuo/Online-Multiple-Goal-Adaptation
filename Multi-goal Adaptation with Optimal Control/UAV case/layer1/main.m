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
planningtime1 = zeros(100,100);
planningtime2 = zeros(100,100);
planningtime3 = zeros(100,100);
rate_list3 = zeros(100,100);
tag_list3 = zeros(100,100);

global eplison
eplison = [0,0,1e-6,1e-6,1e-3];
iternum = 50;
num_o = [38];
num_p = [14];
for np = 1:length(num_p)
    for no = 1:length(num_o)
        for i = 1:iternum 
            num = i;
%             map_initialize(num, num_o(no));
            iter = mod(num,iternum);
            if iter == 0
                iter = iternum;
            end               

%                     [data_2, trajectory,velocity_history,planning_time] = uav_constraint(num);
                    [data_2, trajectory,velocity_history,planning_time] = uav_relax(num);
                    if data_2(1)> 0
                        data2(i,:) =  data_2; 
                        trajectory2 = [trajectory2; trajectory];
                        velocity_history2 = [velocity_history2; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];                  
                        planningtime2(:,i) = planning_time;                      
                    end

                    [data_3, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num);
                    if data_3(1)> 0
                        data3(i,:) =  data_3;
                        trajectory3 = [trajectory3; trajectory];
                        velocity_history3 = [velocity_history3; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];               
                        planningtime3(:,i) = planning_time;
                        rate_list_ = [rate_list, zeros(5,100-size(rate_list,2))];
                        tag_list_ =  [tag_list, zeros(5,100-size(tag_list,2))];
                        rate_list3((iter-1)*5+1:iter*5,:) = rate_list_;
                        tag_list3((iter-1)*5+1:iter*5,:) = tag_list_;                       
                    end
    
                if mod(num,iternum)==0
                    data1(i + 1,:) = mean(data1,1);
                    data2(i + 1,:) = mean(data2,1);
                    data3(i + 1,:) = mean(data3,1);
                    time = datestr(now,30);
                    name = 'S+data' + string(time) + '_' + string(num_o(no))  + '_' + string(eplison) + '_'+ string(num_p(np)) + '.mat';
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
                    planningtime1 = zeros(100,100);
                    planningtime2 = zeros(100,100);
                    planningtime3 = zeros(100,100);
                    rate_list3 = zeros(100,100);
                    tag_list3 = zeros(100,100);
                end
        end
    end
end



