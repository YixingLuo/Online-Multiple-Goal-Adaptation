clc
clear
iternum = 10;
data3_1 = [];
trajectory3_1 = [];
velocity_history3_1 = [];
planningtime3_1 = zeros(100,100);
rate_list3_1 = zeros(100,100);
tag_list3_1 = zeros(100,100);
global eplison
eplison_list = [0,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6,5e-6,1e-5,5e-5,1e-4,5e-4,1e-3,5e-3,1e-2,5e-2,1e-1,5e-1,1];
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
        num_obs = [10];
        for nobs = 1:length(num_obs)
            for i = 1:iternum
                num = nobs;
                indextemp = [0,0,0];
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
                        rate_list_ = [rate_list, zeros(5,50-size(rate_list,2))];
                        tag_list_ =  [tag_list, zeros(5,50-size(tag_list,2))];
                        rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
                        tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;                       
                    end

                if mod(num,iternum)==0
                    data3_1 = [data3_1; mean(data3_1,1)];
                    time = datestr(now,30);
                    name = 'data' + string(time) + '.mat';
                    save(name);
                    data3_1 = [];
                    trajectory3_1 = [];
                    velocity_history3_1 = [];
                    planningtime3_1 = zeros(100,50);
                    rate_list3_1 = zeros(100,50);
                    tag_list3_1 = zeros(100,50);
                end
            end
        end
    end
% end

