clc
clear
data1 = [];
data2_1 = [];
% data2_4 = [];
data3_1 = [];
% data3_2 = [];
trajectory1 = [];
trajectory2_1 = [];
% trajectory2_4 = [];
trajectory3_1 = [];
% trajectory3_2 = [];
velocity_history1 = [];
velocity_history2_1 = [];
% velocity_history2_4 = [];
velocity_history3_1 = [];
% velocity_history3_2 = [];
planningtime1 = zeros(100,100);
planningtime2_1 = zeros(100,100);
% planningtime2_4 = zeros(100,50);
planningtime3_1 = zeros(100,100);
% planningtime3_2 = zeros(100,50);
rate_list3_1 = zeros(100,100);
% rate_list3_2 = zeros(100,50);
tag_list3_1 = zeros(100,100);
index = [];
% tag_list3_2 = zeros(100,50);
global eplison
eplison_list = [1e-6];
iternum = 50;
% obs_prob = [0.7,0.5,0.3];
% for prob = 0:0.1:1
    prob = 0.5;
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
        num_obs = [0.005,0.008,0.01];
        for nobs = 1:length(num_obs)
            for i = 1:3*iternum
                k = ceil(i/iternum);
                num = (nobs-1)*iternum + i;
                map_initialize(num, num_obs(nobs),prob);   
                [condition, indextemp] = randomsituation(num,k);
                index(num,:) =  indextemp;
                iter = mod(num,iternum);
                if iter == 0
                    iter = iternum;
                end

%                 for j = 1:3
                    [data_1, trajectory,velocity_history,planning_time] = uav_normal(num, indextemp);
%                     data1 = [data1 ; data];
%                     trajectory1 = [trajectory1; trajectory];
%                     velocity_history1 = [velocity_history1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];
%                     planningtime1(:,i) = planning_time;
                    if data_1(1)> 0
                        data1 = [data1 ; data_1];
                        trajectory1 = [trajectory1; trajectory];
                        velocity_history1 = [velocity_history1; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];
                        planningtime1(:,i) = planning_time;                       
%                         break
                    end
%                 end

%                     [data, trajectory,velocity_history,planning_time] = uav_relax(num, indextemp);
%                     data2_1 = [data2_1; data]; 
%                     trajectory2_1 = [trajectory2_1; trajectory];
%                     velocity_history2_1 = [velocity_history2_1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];                  
%                     planningtime2_1(:,i) = planning_time;

%                 for j = 1:3
                    [data_2, trajectory,velocity_history,planning_time] = uav_relax(num, indextemp);
%                     data2_1 = [data2_1; data]; 
%                     trajectory2_1 = [trajectory2_1; trajectory];
%                     velocity_history2_1 = [velocity_history2_1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];                  
%                     planningtime2_1(:,i) = planning_time;
                    if data_2(1)> 0
                        data2_1 = [data2_1; data_2]; 
                        trajectory2_1 = [trajectory2_1; trajectory];
                        velocity_history2_1 = [velocity_history2_1; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];                  
                        planningtime2_1(:,i) = planning_time;                      
%                         break
                    end
%                 end

%                     [data, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num, indextemp);
%                     data3_1 = [data3_1; data];
%                     trajectory3_1 = [trajectory3_1; trajectory];
%                     velocity_history3_1 = [velocity_history3_1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];               
%                     planningtime3_1(:,i) = planning_time;
%                     rate_list_ = [rate_list, zeros(5,50-size(rate_list,2))];
%                     tag_list_ =  [tag_list, zeros(5,50-size(tag_list,2))];
%                     rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
%                     tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;

%                 for j = 1:3
                    [data_3, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num, indextemp);
%                     data3_1 = [data3_1; data];
%                     trajectory3_1 = [trajectory3_1; trajectory];
%                     velocity_history3_1 = [velocity_history3_1; velocity_history];
%                     planning_time =[planning_time; zeros(100-length(planning_time),1)];               
%                     planningtime3_1(:,i) = planning_time;
%                     rate_list_ = [rate_list, zeros(5,50-size(rate_list,2))];
%                     tag_list_ =  [tag_list, zeros(5,50-size(tag_list,2))];
%                     rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
%                     tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;
                    if data_3(1)> 0
                        data3_1 = [data3_1; data_3];
                        trajectory3_1 = [trajectory3_1; trajectory];
                        velocity_history3_1 = [velocity_history3_1; velocity_history];
                        planning_time =[planning_time; zeros(100-length(planning_time),1)];               
                        planningtime3_1(:,i) = planning_time;
                        rate_list_ = [rate_list, zeros(5,100-size(rate_list,2))];
                        tag_list_ =  [tag_list, zeros(5,100-size(tag_list,2))];
                        rate_list3_1((iter-1)*5+1:iter*5,:) = rate_list_;
                        tag_list3_1((iter-1)*5+1:iter*5,:) = tag_list_;                       
%                         break
                    end
%                 end
                
%                 if data_1(1)>0 && data_2(1)>0 && data_3(1)>0
%                     data1 = [data1; data_1];
%                     data2_1 = [data2_1; data_2];
%                     data3_1 = [data3_1; data_3];
%                 end
        
                if mod(num,iternum)==0
                    data1(iternum + 1,:) = mean(data1,1);
                    data2_1(iternum + 1,:) = mean(data2_1,1);
                    data3_1(iternum + 1,:) = mean(data3_1,1);
                    time = datestr(now,30);
                    name = 'data' + string(time) + '_' + string(num_obs(nobs)) + string(eplison) + '_'+ string(prob) + '.mat';
                    save(name);
                    data1 = [];
                    data2_1 = [];
%                     data2_4 = [];
                    data3_1 = [];
%                     data3_2 = [];
                    trajectory1 = [];
                    trajectory2_1 = [];
%                     trajectory2_4 = [];
                    trajectory3_1 = [];
%                     trajectory3_2 = [];
                    velocity_history1 = [];
                    velocity_history2_1 = [];
%                     velocity_history2_4 = [];
                    velocity_history3_1 = [];
%                     velocity_history3_2 = [];
                    planningtime1 = zeros(100,100);
                    planningtime2_1 = zeros(100,100);
%                     planningtime2_4 = zeros(100,50);
                    planningtime3_1 = zeros(100,100);
%                     planningtime3_2 = zeros(100,50);
                    rate_list3_1 = zeros(100,100);
%                     rate_list3_2 = zeros(100,50);
                    tag_list3_1 = zeros(100,100);
%                     tag_list3_2 = zeros(100,50);
                    index = [];
                end
            end
        end
    end
%     end
% end


