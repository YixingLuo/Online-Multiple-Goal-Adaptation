clc
clear
data3 = [];
usage_plan3 = [];
planning_time3 = zeros(360,100);
% index = [];
global eplison
% eplison_list = [0.005];
% eplison_list = [0.01];
iternum = 100;
eplison_list = [0,1e-30,1e-25,1e-20,1e-15];
% eplison_list = [1e-7,5e-7];
for ep = 1:length(eplison_list)
    eplison = eplison_list(ep);
    
    for num = 1:iternum
%     num =1;
%     index = unidrnd(2,369,9,1);
    
%         k = ceil((num)/100);
%         flag = 0; %% have no solution at initial point
%         while flag == 0
%             [condition, indextemp] = randomsituation(num,k);
%             index(num,:) =  indextemp;
%             [x_pre,flag] = uuv_initial();
%         end   
%         [condition, indextemp] = randomsituation(num,k);
        name = 'index' + string(num) + '.mat';
        indextemp = load(name);

        [data,usage_plan,planning_time,rate_list] = uuv_relaxation(num, indextemp.index);
        data3 = [data3; data];
        usage_plan3 = [usage_plan3 ; usage_plan];
        planning_time =[planning_time; zeros(360-length(planning_time),1)];   
        iter = mod(num,iternum);
        if iter == 0
            iter = iternum;
        end
        planning_time3(:,iter) = planning_time;
        rate_list_ = [rate_list, zeros(3,100-size(rate_list,2))];
        rate_list3((iter-1)*3+1:iter*3,:) = rate_list_;

        if mod(num,iternum)==0
            data3 = [data3; mean(data3,1)];
            time = datestr(now,30);
            name = 'data' + string(time) +'-'+ string(eplison) + '.mat';
            save(name);
            data3 = [];
            usage_plan3 = [];
            index = [];
            planning_time3 = zeros(360,100);
        end
    end
end



