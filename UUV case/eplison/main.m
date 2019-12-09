clc
clear
data1 = [];
data2 = [];
data3 = [];
usage_plan1 = [];
usage_plan2 = [];
usage_plan3 = [];
index = [];
global eplison
eplison_list = [0.1];
for kk = 1:1
    eplison = eplison_list(kk);
    for num = 1:1
%     num =1;
%     index = unidrnd(2,369,9,1);
    
        k = ceil((num)/1);
        flag = 0; %% have no solution at initial point
        while flag == 0
            [condition, indextemp] = randomsituation(num,k);
            index(num,:) =  indextemp;
            [x_pre,flag] = uuv_initial();
        end
    
    index = [index; indextemp];
%     continue;
%     name = 'condition' + string(num) + '.mat';
%     cond = load(name);
%     cond.condition(1,1)

%         [data,usage_plan] = uuv_normal(num, indextemp, x_pre);
%         data1 = [data1 ; data];
%         usage_plan1 = [usage_plan1 ; usage_plan];
    
%     [tt, text, raw] = xlsread('data1101.xls'); 
%     [rowN, columnN]=size(raw);
%     sheet=1;
%     xlsRange=['A',num2str(rowN+2)];
%     xlswrite('data1101.xls',data1,sheet,xlsRange);

%         [data,usage_plan] = uuv_relax(num, indextemp, x_pre);
%         data2 = [data2; data]; 
%         usage_plan2 = [usage_plan2 ; usage_plan];
    
%     [tt, text, raw] = xlsread('data1101.xls');
%     [rowN, columnN]=size(raw);
%     sheet=2;
%     xlsRange=['A',num2str(rowN+2)];
%     xlswrite('data1101.xls',data2,sheet,xlsRange);

        [data,usage_plan] = uuv_relaxation(num, indextemp, x_pre);
        data3 = [data3; data];
        usage_plan3 = [usage_plan3 ; usage_plan];
    
%     [tt, text, raw] = xlsread('data1101.xls');
%     [rowN, columnN]=size(raw);
%     sheet=3;
%     xlsRange=['A',num2str(rowN+2)];
%     xlswrite('data1101.xls',data3,sheet,xlsRange);

        if mod(num,1)==0
            time = datestr(now,30);
            name = 'data' + string(time) + '.mat';
            save(name);
%             data1 = [];
%             data2 = [];
            data3 = [];
%             usage_plan1 = [];
%             usage_plan2 = [];
            usage_plan3 = [];
            index = [];
        end
    end
end



