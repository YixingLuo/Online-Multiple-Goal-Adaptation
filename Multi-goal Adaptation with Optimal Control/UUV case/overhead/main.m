clc
clear
data1 = [];
data2 = [];
data3 = [];
usage_plan1 = [];
usage_plan2 = [];
usage_plan3 = [];
iternum = 1000;
planning_time1 = zeros(360,iternum);
planning_time2 = zeros(360,iternum);
planning_time3 = zeros(360,iternum);
rate_list3 = zeros(100,100);
tag_list3 = zeros(100,100);

% index = [];
global eplison
eplison_list = [1e-3];
% for kk = 1:length(eplison_list)
    eplison = [1e-3,0,0];
    
    for num = 1:iternum

        k = ceil((num)/iternum);
%         flag = 0; %% have no solution at initial point
%         while flag == 0
%             [condition, indextemp] = randomsituation(num,k);
%             index(num,:) =  indextemp;
%             [x_pre,flag] = uuv_initial();
%         end

        [condition, indextemp] = randomsituation(num,k);
%         indextemp =  index_all(num,1:ceil((num)/50)*3);
        index(num,:) = indextemp;
        
        iter = mod(num,iternum);
        if iter == 0
            iter = iternum;
        end
        [data,usage_plan,planning_time] = uuv_normal(num, indextemp);
        data1 = [data1 ; data];
        usage_plan1 = [usage_plan1 ; usage_plan];
        planning_time =[planning_time; zeros(360-length(planning_time),1)] ;              
        planning_time1(:,iter) = planning_time;

        [data,usage_plan,planning_time] = uuv_relax2(num, indextemp);
        data2 = [data2; data]; 
        usage_plan2 = [usage_plan2 ; usage_plan];
        planning_time =[planning_time; zeros(360-length(planning_time),1)];               
        planning_time2(:,iter) = planning_time;
        
    
        [data,usage_plan,planning_time,rate_list,tag_list] = uuv_relaxation(num, indextemp);
        data3 = [data3; data];
        usage_plan3 = [usage_plan3 ; usage_plan];
        planning_time =[planning_time; zeros(360-length(planning_time),1)];               
        planning_time3(:,iter) = planning_time;
        rate_list_ = [rate_list, zeros(3,100-size(rate_list,2))];
        rate_list3((iter-1)*3+1:iter*3,:) = rate_list_;
        tag_list_ = [tag_list, zeros(3,100-size(tag_list,2))];
        tag_list3((iter-1)*3+1:iter*3,:) = tag_list_;
    

        if mod(num,iternum)==0
            data1 = [data1; mean(data1,1)];
            data2 = [data2; mean(data2,1)];
            data3 = [data3; mean(data3,1)];
            time = datestr(now,30);
            name = 'data' + string(time)+'-'+string(k) + '.mat';
            save(name);
            data1 = [];
            data2 = [];
            data3 = [];
            usage_plan1 = [];
            usage_plan2 = [];
            usage_plan3 = [];
            index = [];
            planning_time1 = zeros(360,iternum);
            planning_time2 = zeros(360,iternum);
            planning_time3 = zeros(360,iternum);
            rate_list3 = zeros(100,100);
            tag_list3 = zeros(100,100);
        end
    end
% end



