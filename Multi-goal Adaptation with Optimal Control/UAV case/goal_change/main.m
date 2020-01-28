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
% index = [];

global eplison
eplison = [1e-20,1e-20,1e-6,1e-6,1e-6];
iternum = 100;
num_o = [19];
num_p = [7];
% for grid = 5:-1:5
%     for np = 1:length(num_p)
%         for no = 1:length(num_o)
            for i = 1 :3*iternum
                k = ceil(i/iternum);
                num_condition = i;
                num = i;
                map_initialize(num, num_o(1),num_p(1));
                [condition, indextemp] = randomsituation(num_condition,k);
                index(num_condition,:) =  indextemp;
    %             indextemp = index(num,:);
                iter = mod(num_condition,iternum);
                if iter == 0
                    iter = iternum;
                end          
%                 num_map = grid;

                [data_1, trajectory,velocity_history,planning_time] = uav_normal(num, num_condition, indextemp);
                if data_1(1)> 0
%                     data1(i,:) = data_1;
                    trajectory1 = [trajectory1; trajectory];
                    velocity_history1 = [velocity_history1; velocity_history];
                    planning_time =[planning_time; zeros(100-length(planning_time),1)];
                    planningtime1(:,i) = planning_time;                       
                end


                [data_2, trajectory,velocity_history,planning_time] = uav_relax(num, num_condition, indextemp);
                if data_2(1)> 0
%                     data2(i,:) = data_2; 
                    trajectory2 = [trajectory2; trajectory];
                    velocity_history2 = [velocity_history2; velocity_history];
                    planning_time =[planning_time; zeros(100-length(planning_time),1)];                  
                    planningtime2(:,i) = planning_time;                      
                end


                [data_3, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num, num_condition, indextemp);
                if data_3(1)> 0
%                     data3(i,:) = data_3;
                    trajectory3 = [trajectory3; trajectory];
                    velocity_history3 = [velocity_history3; velocity_history];
                    planning_time =[planning_time; zeros(100-length(planning_time),1)];               
                    planningtime3(:,i) = planning_time;
                    rate_list_ = [rate_list, zeros(5,100-size(rate_list,2))];
                    tag_list_ =  [tag_list, zeros(5,100-size(tag_list,2))];
                    rate_list3((iter-1)*5+1:iter*5,:) = rate_list_;
                    tag_list3((iter-1)*5+1:iter*5,:) = tag_list_;                       
                end

                if data_1(1)>0 && data_2(1)>0 && data_3(1)>0
                    data1 = [data1; data_1];
                    data2 = [data2; data_2];
                    data3 = [data3; data_3];
                end

                if mod(num_condition,iternum)== iternum
                    data1(i + 1,:) = mean(data1(i-(iternum-1):i,:),1);
                    data2(i + 1,:) = mean(data2(i-(iternum-1):i,:),1);
                    data3(i + 1,:) = mean(data3(i-(iternum-1):i,:),1);
                    time = datestr(now,30);
                    name = 'data' + string(time) + '_' + string(num_o(1))  + '_' + string(eplison) + '_'+ string(num_p(1)) + '.mat';
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
                    index = [];
                end
            end
%         end
%     end
% end

