clc
clear
data3_1 = [];
trajectory3_1 = [];
velocity_history3_1 = [];
planningtime3_1 = zeros(100,100);
rate_list3_1 = zeros(100,100);
tag_list3_1 = zeros(100,100);
index = [];
global eplison
eplison_list = [1e-6];
iternum = 50;
% obs_prob = [0.7,0.5,0.3];
% for prob = 0:0.1:1
    prob = 0.5;
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
        num_obs = [0.008];
        for nobs = 1:length(num_obs)
            for i = 1:iternum
                k = ceil(i/iternum);
                num = (nobs-1)*iternum + i;
                map_initialize(num, num_obs(nobs),prob);   
                [condition, indextemp] = randomsituation(num,k);
                index(num,:) =  indextemp;
                iter = mod(num,iternum);
                if iter == 0
                    iter = iternum;
                end


                    [data, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num, indextemp);
%                     if data(1)> 0
                        data3_1 = [data3_1; data];
                        trajectory3_1 = [trajectory3_1; trajectory];
                        velocity_history3_1 = [velocity_history3_1; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];               
                        planningtime3_1(:,i) = planning_time;
                        rate_list_ = [rate_list, zeros(5,100-size(rate_list,2))];
                        tag_list_ =  [tag_list, zeros(5,100-size(tag_list,2))];
                        rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
                        tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;                       
%                     end

                
        
                if mod(num,iternum)==0
                    data3_1(iternum + 1,:) = mean(data3_1,1);
                    time = datestr(now,30);
                    name = 'data' + string(time) + '_' + string(num_obs(nobs)) + string(eplison) + '_'+ string(prob) + '.mat';
                    save(name);
                    data3_1 = [];
                    trajectory3_1 = [];
                    velocity_history3_1 = [];
                    planningtime3_1 = zeros(100,100);
                    rate_list3_1 = zeros(100,100);
                    tag_list3_1 = zeros(100,100);
                    index = [];
                end
            end
        end
    end

