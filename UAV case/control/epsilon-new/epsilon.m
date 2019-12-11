clc
clear

data3_1 = [];
trajectory3_1 = [];
velocity_history3_1 = [];
planningtime3_1 = zeros(100,50);
rate_list3_1 = zeros(100,50);
tag_list3_1 = zeros(100,50);
global eplison
eplison_list = [0,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6,5e-6,1e-5,5e-5,1e-4,5e-4,1e-3,5e-3,1e-2,5e-2,1e-1,5e-1,1];
% obs_prob = [0.7,0.5,0.3];
% for prob = 0:0.1:1
    prob = 0.7;
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
        num_obs = [10];
        for nobs = 1:length(num_obs)
            for i = 1:50

                num = (nobs-1)*50 + i;
%                 map_initialize(num, num_obs(nobs),prob);   
%                 [condition, indextemp] = randomsituation(num,1);
%                 index(num,:) =  indextemp;
                indextemp = [0,0,0];
                iter = mod(num,50);
                if iter == 0
                    iter = 50;
                end



%                 for j = 1:3
                    [data, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num, indextemp);
%                     data3_1 = [data3_1; data];
%                     trajectory3_1 = [trajectory3_1; trajectory];
%                     velocity_history3_1 = [velocity_history3_1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];               
%                     planningtime3_1(:,i) = planning_time;
%                     rate_list_ = [rate_list, zeros(5,50-size(rate_list,2))];
%                     tag_list_ =  [tag_list, zeros(5,50-size(tag_list,2))];
%                     rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
%                     tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;
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
%                         break
                    end
%                 end

                if mod(num,50)==0
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

