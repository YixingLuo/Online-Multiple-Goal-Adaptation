% uuv_relax(1)
function [data,usage_plan] = uuv_relax(nnum, indextemp, x_initial)
% clc
% clear
global uuv
uuv = UnmannedUnderwaterVehicle();
global pastdistance
global pasttime
global pastenergy
global pastaccuracy
pastdistance = 0;
pasttime = 0;
pastenergy = 0;
pastaccuracy = 0;
usage_plan = [];
x_plan_relax=[];
x_plan = [];
speed = [];
acc_list = [];
distance_list = [];
energy_list = [];
flag = [];
f_value = [];
flag_relax = [];
f_value_relax = [];
c=[];
log = [];
x_pre = [];
current_step = 1;
num = 0;
% cond = load('condition.mat');
name = 'condition' + string(nnum) + '.mat'
cond = load(name)
need_replan = 0;
plan_num = length(indextemp);
index_cond = 1;
x_plan = [];
while(1)
    need_replan = 0;
    fprintf('uuv_relax: current step %d\n', current_step);
    if current_step > 360 
        DS_A = (pastaccuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)
        DS_D = (pastdistance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)
        DS_E = (uuv.energy_budget - pastenergy) /(uuv.energy_budget - uuv.energy_target)
        data = [DS_A, pastaccuracy, DS_D, pastdistance, DS_E, pastenergy];
%         [num, text, raw] = xlsread('data.xls');
%         [rowN, columnN]=size(raw);
%         sheet=1;
%         xlsRange=['A',num2str(rowN+1)];
%         xlswrite('data.xls',data,sheet,xlsRange);
        break
    end
    
    if  plan_num > 0 && current_step == indextemp(index_cond)        
        need_replan = 1;
        plan_num = plan_num - 1;
        if cond.condition(index_cond,1) == 1
            uuv = EnergyBudget(uuv, cond.condition(index_cond,2));
        elseif cond.condition(index_cond,1) == 2
            uuv = DistanceBudget(uuv, cond.condition(index_cond,2));
            elseif cond.condition(index_cond,1) == 3
                uuv = AccuracyBudget(uuv, cond.condition(index_cond,2));
                elseif cond.condition(index_cond,1) == 4
                    uuv = SensorError(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
%                     elseif cond.condition(index_cond,1) == 5
%                         uuv = SensorFailure(uuv, cond.condition(index_cond,2));            
                        elseif cond.condition(index_cond,1) == 5
                            uuv = EnergyDisturbance(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
        else
             uuv = SpeedDisturbance(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
        end
        index_cond = index_cond+1;
    end
    
    if current_step == 1
        need_replan = 0;
        x_pre = x_initial;
    end

    if need_replan == 1 
        exitflag = 0;
        iternum = 0;
        while exitflag <= 0  
            lb=[];
            ub=[];
            x0=[];
            for i = 1 : uuv.N_s % portion of time
                lb(i) = 0;
                ub(i) = 1;
%                 x0(i) = 1/uuv.N_s + unifrnd(-1/uuv.N_s,1/uuv.N_s);
                x0(i) = unifrnd(0,1/uuv.N_s);
            end
            for i = uuv.N_s + 1 : 3*uuv.N_s % accuracy and speed exploition
                lb(i) = 0;
                ub(i) = 1;
%                 x0(i) = 1- unifrnd(0,0.2);
                x0(i) = unifrnd(0,1);
            end
%             length(lb)
%             length(x_pre)
%             x0 = x_pre(1:15);
            %%slash variable
            lb = [lb, 0, 0, 0];
            ub = [ub,uuv.acc_target-uuv.acc_budget, uuv.distance_target-uuv.distance_budget, uuv.energy_budget-uuv.energy_target];
            x0 = [x0, 0, 0, 0];
            % options=optimoptions(@fminsearch, 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
            optimset('Algorithm','sqp');  
            [x,fval,exitflag,output,lambda]=fmincon(@objuuv,x0,[],[],[],[],lb,ub,@myconuuv);
%           [c1,c2] = myconuuv(x);
%           c =[c;c1];
%           flag = [flag,exitflag];
%           f_value = [f_value, fval];
  
            if exitflag > 0 || iternum > 50
                fprintf(2,'uuv_relax: have solution at current step: %d , %d\n',exitflag, current_step);
                flag = [flag,exitflag];
                f_value = [f_value, fval];
                x_pre = x;
                x_plan = [x_plan;x];
                break
            end        
            iternum = iternum+1;
        end
    
        if iternum > 50 && exitflag < 0 
            fprintf(2,'uuv_relax: no solution at current step: %d , %d\n',exitflag, current_step);
            break;
        end

        %% distance
        speed_now = 0;
        for i = 1:uuv.N_s
            speed_now = speed_now + x(i)*uuv.s_speed(i)*x(i+uuv.N_s);
        end
        speed = [speed, speed_now];
        pastdistance = pastdistance + speed_now * uuv.time_step;
        distance_list = [distance_list, pastdistance];
       
       %% accuracy
        acc = 0;
        for i = 1:uuv.N_s
            acc = acc + x(i)*uuv.s_accuracy(i)*x(i+2*uuv.N_s);
        end
        acc_list = [acc_list, acc];
        pastaccuracy = (pastaccuracy * pasttime + acc * uuv.time_step) / (pasttime + uuv.time_step);
        
        %% energy
        engy = 0;
        for i = 1:uuv.N_s
%             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
            engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%             engy = engy + x(i)*uuv.s_energy(i);
%             engy = engy + x(i)*(x(i + 2*uuv.N_s)+x(i + uuv.N_s))/2*uuv.s_energy(i);
        end
        pastenergy = pastenergy + engy * uuv.time_step;
        energy_list = [energy_list, engy];       
    
        %% time
        pasttime = pasttime + uuv.time_step;   
        
        %% sensor usage
        index = 1;
        for i = 1:length(uuv.s_work)
            if uuv.s_work(i) == 1                  
                usage_plan(current_step, i) = x(index);
                usage_plan(current_step, length(uuv.s_work) + i) = x(uuv.N_s + index);
                usage_plan(current_step, 2*length(uuv.s_work) + i) = x(2*uuv.N_s + index);
                index = index+1;
            else
                usage_plan(current_step, i) = 0;
                usage_plan(current_step, length(uuv.s_work) + i) = 0;
                usage_plan(current_step, 2*length(uuv.s_work) + i) = 0;
            end
        end
    
    else
        %% distance
        speed_now = 0;
        for i = 1:uuv.N_s
            speed_now = speed_now + x_pre(i)*uuv.s_speed(i)*x_pre(i+uuv.N_s);
        end
        speed = [speed, speed_now];
        pastdistance = pastdistance + speed_now * uuv.time_step;
        distance_list = [distance_list, pastdistance];
        
        %% accuracy
        acc = 0;
        for i = 1:uuv.N_s
            acc = acc + x_pre(i)*uuv.s_accuracy(i)*x_pre(i+2*uuv.N_s);
        end
        acc_list = [acc_list, acc];
        pastaccuracy = (pastaccuracy * pasttime + acc * uuv.time_step) / (pasttime + uuv.time_step);
        
        %% energy
        engy = 0;
        for i = 1:uuv.N_s
%             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
            engy = engy + x_pre(i)*(exp(x_pre(i + 2*uuv.N_s)+x_pre(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%                 engy = engy + x_pre(i)*uuv.s_energy(i);
%             engy = engy + x_pre(i)*(x_pre(i + 2*uuv.N_s)+x_pre(i + uuv.N_s))/2*uuv.s_energy(i);
        end
        pastenergy = pastenergy + engy * uuv.time_step;
        energy_list = [energy_list, engy];       
    
        %% time
        pasttime = pasttime + uuv.time_step;   
        
        %% sensor usage
        index = 1;
        for i = 1:length(uuv.s_work)
            if uuv.s_work(i) == 1                  
                usage_plan(current_step, i) = x_pre(index);
                usage_plan(current_step, length(uuv.s_work) + i) = x_pre(uuv.N_s + index);
                usage_plan(current_step, 2*length(uuv.s_work) + i) = x_pre(2*uuv.N_s + index);
                index = index+1;
            else
                usage_plan(current_step, i) = 0;
                usage_plan(current_step, length(uuv.s_work) + i) = 0;
                usage_plan(current_step, 2*length(uuv.s_work) + i) = 0;
            end
        end        
    end
    current_step = current_step + 1;
end
end



