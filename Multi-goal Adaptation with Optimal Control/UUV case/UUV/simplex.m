%%1.00558575517182	0.900558575517182	1.00906003383658	103117.780439876	1.02791519500656	4560918.72699082	3	360
%% 1	4600000	0
%% 6	4	1.60000000000000
%% 2	103000	0
%% 5	1	248
%% 103	230	252	295
% function [data,usage_plan] = uuv_relaxation(nnum, indextemp, x_initial)
% clc
% clear
t1=clock;
global uuv
uuv = UnmannedUnderwaterVehicle();
global pastdistance
global pasttime
global pastenergy
global pastaccuracy
global ratio
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
log = [];
relax_list = [];
no_relax_list = [];
results =[];
x_pre = x_initial;
current_step = 1;
relax_num = 0;
% cond = load('condition.mat');
% name = 'condition' + string(nnum) + '.mat';
% cond = load(name);
x_relax=[];
need_replan = 0;
plan_num = length(indextemp);
index_cond = 1;
while(1)
    need_replan = 0;
    fprintf('uuv_relaxation: current step %d\n', current_step);
%     current_step
    if current_step >= 360 
        fprintf('last step');
        DS_A = (pastaccuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)
        DS_D = (pastdistance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)
        DS_E = (uuv.energy_budget - pastenergy) /(uuv.energy_budget - uuv.energy_target)
        data = [DS_A, pastaccuracy, DS_D, pastdistance, DS_E, pastenergy, relax_num, current_step];
        break
    end
    
%     if  plan_num > 0 && current_step == indextemp(index_cond)        
%         need_replan = 1;
%         plan_num = plan_num - 1;
%         if cond.condition(index_cond,1) == 1
%             uuv = EnergyBudget(uuv, cond.condition(index_cond,2));
%         elseif cond.condition(index_cond,1) == 2
%             uuv = DistanceBudget(uuv, cond.condition(index_cond,2));
%             elseif cond.condition(index_cond,1) == 3
%                 uuv = AccuracyBudget(uuv, cond.condition(index_cond,2));
%                 elseif cond.condition(index_cond,1) == 4
%                     uuv = SensorError(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
% %                     elseif cond.condition(index_cond,1) == 5
% %                         uuv = SensorFailure(uuv, cond.condition(index_cond,2));            
%                         elseif cond.condition(index_cond,1) == 5
%                             uuv = EnergyDisturbance(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
%         else
%              uuv = SpeedDisturbance(uuv, cond.condition(index_cond,2), cond.condition(index_cond,3));
%         end
%         index_cond = index_cond+1;
%     end
    
    if current_step == 1
        need_replan = 0;
        x_pre = x_initial;
    end

        if current_step == 100
        uuv = EnergyBudget(uuv, 5 * 1e6);
        need_replan = 1;
    end
    
    if current_step == 160
        uuv = DistanceBudget(uuv, 105*1000);
        need_replan = 1;
    end
    
    if current_step == 220
        uuv = SensorError(uuv, 3, 0.43);
        need_replan = 1;
    end
    
    if current_step == 290
        uuv = SensorFailure(uuv, 4);
        need_replan = 1;
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
%                 x0(i) = 1-unifrnd(0,0.2);
                x0(i) = unifrnd(0,1);
            end
%             x0 = x_pre(1:15);
            %%slash variable
            lb = [lb, 0, 0, 0];
            ub = [ub,uuv.acc_target-uuv.acc_budget, uuv.distance_target-uuv.distance_budget, uuv.energy_budget-uuv.energy_target];
            x0 = [x0, 0, 0, 0];
%           options=optimoptions(@fminsearch, 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
            optimset('Algorithm','sqp','MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );  
            [x,fval,exitflag,output,lambda]=fmincon(@objuuv,x0,[],[],[],[],lb,ub,@myconuuv);
%           flag = [flag,exitflag];
%           f_value = [f_value, fval];
%           x_plan = [x_plan;x];
    
            if exitflag > 0 || iternum > 50
                fprintf(2,'uuv_relaxation: have solution at current step: %d , %d\n',exitflag, current_step);
                flag = [flag,exitflag];
                f_value = [f_value, fval];
                x_pre = x;
                break
            end
                iternum = iternum+1;
        end

        if iternum > 50 && exitflag < 0
            fprintf(2,'uuv_relaxation: no solution at current step: %d , %d\n',exitflag, current_step);
            break;
        end

        %% relaxation
%         relax_list = [relax_list, relax_num];
%         no_relax_list = [no_relax_list, current_step];
        if fval > 1e-6
            fprintf(2,"need relexation!! %d %d\n" ,relax_num + 1, current_step);   
            relax_num = relax_num + 1;
            [acc_variance, acc_ratio, distance_variance, distance_ratio, energy_variance, energy_ratio] = relaxation_ratio(x);
            ratio = [acc_ratio, distance_ratio, energy_ratio];
            log = [log; [ratio, current_step]];
            
            exitflag_relax = 0;
            iternum_relax = 0;
            while exitflag_relax <= 0 
                lb_relax=[];
                ub_relax=[];
                x0_relax=[];
                for i = 1 : uuv.N_s % portion of time
                    lb_relax(i) = 0;
                    ub_relax(i) = 1;
%                     x0_relax(i) = 1/uuv.N_s + unifrnd(-1/uuv.N_s,1/uuv.N_s);
                    x0_relax(i) = unifrnd(0,1/uuv.N_s);
                end
                for i = uuv.N_s + 1 : 3*uuv.N_s % accuracy and speed exploition
                    lb_relax(i) = 0;
                    ub_relax(i) = 1;
%                     x0_relax(i) = 1- unifrnd(0,0.2);
                    x0_relax(i) = unifrnd(0,1);
                end 
%                 x0_relax = x_pre(1:15);
                goal = [];
                weight = [];
                for g = 1:length(ratio)
                    goal = [goal, -1];
%                   if ratio(g)>1e-6                  
%                       weight = [weight, 1-ratio(g)];
%                   else             
%                       weight = [weight, 1];
%                   end
                    weight = [weight, 1];
                end

                options_relax=optimoptions(@fgoalattain,'Display','final' ,'MaxIter',10000, 'tolx',1e-10,'tolfun',1e-10, 'TolCon',1e-10 ,'MaxFunEvals', 10000);
%                 [x_relax,fval_relax,attainfactor,exitflag_relax,output_relax,lambda_relax] = fgoalattain(@objuuv_relax,x0_relax,goal, weight,[],[],[],[],lb_relax,ub_relax,@myconuuv_relax, options_relax);
                [x_relax,fval_relax,exitflag_relax,output_relax,lambda_relax]=fmincon(@objuuv_relax,x0_relax,[],[],[],[],lb_relax,ub_relax,@myconuuv_relax);
        
                if exitflag_relax > 0 || iternum_relax > 50
                    flag_relax=[flag_relax, exitflag_relax];
                    f_value_relax = [f_value_relax; fval_relax];
                    x_pre = x_relax;
                end
                iternum_relax = iternum_relax + 1;
            end
        
            if iternum_relax > 50 && exitflag_relax < 0
                fprintf(2,'uuv_relaxation: no solution at current step: %d , %d\n',exitflag_relax, current_step);
                break;
            end
        end
    end

    %%update x
    if need_replan == 1 
        if fval > 1e-6
            %% distance
            speed_now = 0;
            for i = 1:uuv.N_s
                speed_now = speed_now + x_relax(i)*uuv.s_speed(i)*x_relax(i+uuv.N_s);
            end
            speed = [speed, speed_now];
            pastdistance = pastdistance + speed_now * uuv.time_step;
            distance_list = [distance_list, pastdistance];
            %% accuracy
            acc = 0;
            for i = 1:uuv.N_s
                acc = acc + x_relax(i)*uuv.s_accuracy(i)*x_relax(i+2*uuv.N_s);
            end
            acc_list = [acc_list, acc];
            pastaccuracy = (pastaccuracy * pasttime + acc * uuv.time_step) / (pasttime + uuv.time_step);       
            %% energy
            engy = 0;
            for i = 1:uuv.N_s
%               engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
                engy = engy + x_relax(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%               engy = engy + x_relax(i)*uuv.s_energy(i);
%               engy = engy + x_relax(i)*(x_relax(i + 2*uuv.N_s)+x_relax(i + uuv.N_s))/2*uuv.s_energy(i);
            end
            pastenergy = pastenergy + engy * uuv.time_step;
            energy_list = [energy_list, engy];          
            %% time
            pasttime = pasttime + uuv.time_step;          
            %% sensor usage
            index = 1;
            for i = 1:length(uuv.s_work)
                if uuv.s_work(i) == 1                  
                    usage_plan(current_step, i) = x_relax(index);
                    usage_plan(current_step, length(uuv.s_work) + i) = x_relax(uuv.N_s + index);
                    usage_plan(current_step, 2*length(uuv.s_work) + i) = x_relax(2*uuv.N_s + index);
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
%               engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
                engy = engy + x(i)*(exp(x_pre(i + 2*uuv.N_s)+x_pre(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%               engy = engy + x(i)*uuv.s_energy(i);
%               engy = engy + x(i)*(x(i + 2*uuv.N_s)+x(i + uuv.N_s))/2*uuv.s_energy(i);
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
        end
    else %% use preivious plan
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
%            engy = engy + x_pre(i)*uuv.s_energy(i);
%            engy = engy + x_pre(i)*(x_pre(i + 2*uuv.N_s)+x_pre(i + uuv.N_s))/2*uuv.s_energy(i);
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
    t2=clock;
    etime(t2,t1)
end
% end
