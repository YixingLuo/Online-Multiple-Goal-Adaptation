clc
clear
data3_1 = [];
trajectory3_1 = [];
velocity_history3_1 = [];
planningtime3_1 = zeros(100,100);
rate_list3_1 = zeros(100,100);
tag_list3_1 = zeros(100,100);

global eplison
eplison_list = [1e-1,5e-1,1];
% obs_prob = [0.7,0.5,0.3];
% for prob = 0:0.1:1
iternum = 20;   
prob = 0.7;
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
            rate_o = 7;
            rate_p = 3;
            for i = 1:iternum       
                num = i;
%                 map_initialize(num, rate_o,rate_p);   
                iter = mod(num,iternum);
                if iter == 0
                    iter = iternum;
                end

                    [data, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num);
                    if data(1)> 0
                        data3_1 = [data3_1; data];
                        trajectory3_1 = [trajectory3_1; trajectory];
                        velocity_history3_1 = [velocity_history3_1; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];               
                        planningtime3_1(:,i) = planning_time;
                        rate_list_ = [rate_list, zeros(5,100-size(rate_list,2))];
                        tag_list_ =  [tag_list, zeros(5,100-size(tag_list,2))];
                        rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
                        tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;                       
                end

                if mod(num,iternum)==0
                    time = datestr(now,30);
                    name = 'data' + string(time) + '.mat';
                    save(name);
                    data3_1 = [];
                    trajectory3_1 = [];
                    velocity_history3_1 = [];
                    planningtime3_1 = zeros(100,100);
                    rate_list3_1 = zeros(100,100);
                    tag_list3_1 = zeros(100,100);
                end
            end
        end



