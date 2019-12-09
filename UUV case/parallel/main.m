clc
clear
data1 = [];
data2 = [];
data3 = [];
usage_plan1 = [];
usage_plan2 = [];
usage_plan3 = [];
planning_time1 = zeros(360,50);
planning_time2 = zeros(360,50);
planning_time3 = zeros(360,50);
rate_list3 = zeros(100,100);
tag_list3 = zeros(100,100);

% index = [];
global eplison
eplison_list = [0.0005];
for kk = 1:length(eplison_list)
    eplison = eplison_list(kk);
    
    for num = 1:250

        k = ceil((num)/50);
%         flag = 0; %% have no solution at initial point
%         while flag == 0
%             [condition, indextemp] = randomsituation(num,k);
%             index(num,:) =  indextemp;
%             [x_pre,flag] = uuv_initial();
%         end

        [condition, indextemp] = randomsituation(num,k);
        index(num,:) =  indextemp;

        iter = mod(num,50);
        if iter == 0
            iter = 50;
        end
        [data,usage_plan,planning_time] = uuv_normal(num, indextemp);
        data1 = [data1 ; data];
        usage_plan1 = [usage_plan1 ; usage_plan];
%         planning_time1 = [planning_time1; planning_time];
%         planning_time, planning_time1(:,iter)
        planning_time =[planning_time; zeros(360-length(planning_time),1)] ;              
        planning_time1(:,iter) = planning_time;

        [data,usage_plan,planning_time] = uuv_relax2(num, indextemp);
        data2 = [data2; data]; 
        usage_plan2 = [usage_plan2 ; usage_plan];
%         planning_time2 = [planning_time2; planning_time];
        planning_time =[planning_time; zeros(360-length(planning_time),1)];               
        planning_time2(:,iter) = planning_time;
        
    
        [data,usage_plan,planning_time,rate_list,tag_list] = uuv_relaxation(num, indextemp);
        data3 = [data3; data];
        usage_plan3 = [usage_plan3 ; usage_plan];
%         planning_time3 = [planning_time3; planning_time];
        planning_time =[planning_time; zeros(360-length(planning_time),1)];               
        planning_time3(:,iter) = planning_time;
        rate_list_ = [rate_list, zeros(3,100-size(rate_list,2))];
        rate_list3((iter-1)*3+1:iter*3,:) = rate_list_;
        tag_list_ = [tag_list, zeros(3,100-size(tag_list,2))];
        tag_list3((iter-1)*3+1:iter*3,:) = tag_list_;
    

        if mod(num,50)==0
            data1 = [data1; mean(data1,1)];
            data2 = [data2; mean(data2,1)];
            data3 = [data3; mean(data3,1)];
            time = datestr(now,30);
            name = 'data' + string(time) + '.mat';
            save(name);
            data1 = [];
            data2 = [];
            data3 = [];
            usage_plan1 = [];
            usage_plan2 = [];
            usage_plan3 = [];
            index = [];
            planning_time1 = zeros(360,50);
            planning_time2 = zeros(360,50);
            planning_time3 = zeros(360,50);
            rate_list3 = zeros(100,100);
            tag_list3 = zeros(100,100);
        end
    end
end
