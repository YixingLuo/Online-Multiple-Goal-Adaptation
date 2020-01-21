clc
clear
iternum = 100;
data3 = [];
trajectory3 = [];
velocity_history3 = [];
planningtime3 = zeros(100,100);
rate_list3 = zeros(100,100);
tag_list3 = zeros(100,100);
global eplison
eplison_list = [0,1e-12,1e-11,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,5e-1];
    for ep = 1:length(eplison_list)
        eplison = eplison_list(ep);
%         eplison = 0;
        for nobs = 1:iternum
%             for i = 1:iternum
                num = nobs;
                i = nobs;
                iter = mod(num,iternum);
                if iter == 0
                    iter = iternum;
                end
                name = 'index' + string(num) + '.mat';
                indextemp = load(name);
                [data, trajectory,velocity_history,planning_time,rate_list,tag_list] = uav_relaxation(num,num,indextemp.index);
                if data(1)> 0
                    data3(i,:) = data;
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
                    data3 = [data3; mean(data3,1)];
                    time = datestr(now,30);
                    name = 'data' + string(time) + '_10_' + string(eplison) + '_5.mat';
                    save(name);
                    data3 = [];
                    trajectory3 = [];
                    velocity_history3 = [];
                    planningtime3 = zeros(100,100);
                    rate_list3 = zeros(100,100);
                    tag_list3 = zeros(100,100);
                end
        end
    end
%     end
% end

