function [data,usage_plan,planning_time,rate_list,tag_list] = uuv_relaxation(nnum, indextemp)
% clc
% clear
global eplison
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
rate = [];
planning_time = [];
rate_list = []; 
tag_list = [];
% x_pre = x_initial;
current_step = 1;
relax_num = 0;
% cond = load('condition.mat');
name = 'condition' + string(nnum) + '.mat';
cond = load(name);
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
        DS_A = min(1,(pastaccuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget));
        DS_D = min(1,(pastdistance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget));
        DS_E = min(1,(uuv.energy_budget - pastenergy) /(uuv.energy_budget - uuv.energy_target));
        data = [DS_A, pastaccuracy, DS_D, pastdistance, DS_E, pastenergy, relax_num, current_step];
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
        need_replan = 1;
%         x_pre = x_initial;
    end

    if need_replan == 1 
        t1=clock;
        exitflag = 0;
        iternum = 0;
        fval_pre = 1e6;
        for iternum= 0:50
%             while exitflag <= 0
            lb=[];
            ub=[];
            x0=[];
            for i = 1 : uuv.N_s % portion of time
                lb(i) = 0;
                ub(i) = 1;
%                 x0(i) = unifrnd(0,1/uuv.N_s);
                x0(i) = 1/uuv.N_s - 0.2/50*iternum;
            end
            for i = uuv.N_s + 1 : 3*uuv.N_s % accuracy and speed exploition
                lb(i) = 0;
                ub(i) = 1;
%                 x0(i) = 1- unifrnd(0,0.2);
                x0(i) = 1 - iternum * 1/50;
            end
%             x0 = x_pre(1:15);
            %%slash variable
            lb = [lb, 0, 0, 0];
            ub = [ub,uuv.acc_target-uuv.acc_budget, uuv.distance_target-uuv.distance_budget, uuv.energy_budget-uuv.energy_target];
            x0 = [x0, 0, 0, 0];
%           options=optimoptions(@fminsearch, 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
%             optimset('Algorithm','sqp','MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 ); 
            options.Algorithm = 'sqp';
            options.Display = 'off';
            tic;
%             options.MaxIter=100000;
%             options.MaxFunEvals=100000;
            [x,fval,exitflag]=fmincon(@objuuv,x0,[],[],[],[],lb,ub,@myconuuv,options);
            t2_1 = toc;
%           flag = [flag,exitflag];
%           f_value = [f_value, fval];
%           x_plan = [x_plan;x];
    
            if exitflag > 0 
%                 && fval < fval_pre
                fprintf(2,'uuv_relaxation: have solution at current step: %d , %d\n',exitflag, current_step);
%                 flag = [flag,exitflag];
%                 f_value = [f_value, fval];
%                 rate = [rate;x(16:18)]
                fval_pre = fval;
                x_pre = x;
                rate = x(16:18);
                break;
            end
        end

%         if iternum > 50 && exitflag < 0
%             fprintf(2,'uuv_relaxation: no solution at current step: %d , %d\n',exitflag, current_step);
%             break;
%         end

        %% relaxation
%         rate = mean(rate);
%         rate
%         rate = [rate(1)/(uuv.acc_target-uuv.acc_budget),rate(2)/(uuv.distance_target-uuv.distance_budget),rate(3)/(uuv.energy_budget-uuv.energy_target)];
        [acc_variance, acc_ratio, distance_variance, distance_ratio, energy_variance, energy_ratio] = relaxation_ratio(x_pre);
        ratio = [acc_ratio, distance_ratio, energy_ratio];  
%         if fval > 1e-6
        if ratio(1) > eplison(1) || ratio(2) > eplison(2) || ratio(3) > eplison(3)
            rate_list = [rate_list, ratio'];
            tag = [0,0,0];
            for kk = 1:3
                if ratio(kk) > eplison(kk)
                    tag(kk)=1;
                end
            end
            tag_list = [tag_list, tag'];
            fprintf(2,"need relexation!! %d %d\n" ,relax_num + 1, current_step);   
            relax_num = relax_num + 1;
%             ratio = [rate(1),rate(2),rate(3)];           
            exitflag_relax = 0;
            iternum_relax = 0;
            fval_pre_relax = 1e6;
            for  iternum_relax=0:50
                lb_relax=[];
                ub_relax=[];
                x0_relax=[];
                for i = 1 : uuv.N_s % portion of time
                    lb_relax(i) = 0;
                    ub_relax(i) = 1;
%                     x0_relax(i) = unifrnd(0,1/uuv.N_s);
                    x0_relax(i) = 1/uuv.N_s-0.2/50*iternum_relax;
                end
                for i = uuv.N_s + 1 : 3*uuv.N_s % accuracy and speed exploition
                    lb_relax(i) = 0;
                    ub_relax(i) = 1;
%                     x0_relax(i) = 1- unifrnd(0,0.2);
                    x0_relax(i) = 1 - iternum_relax * 1/50;
                end 
%                 x0_relax = x_pre(1:15);
%                 goal = [-3];
%                 weight = [3];
%                 for g = 1:length(ratio)
%                     goal = [goal, -1];
% %                   if ratio(g)>1e-6                  
% %                       weight = [weight, 1-ratio(g)];
% %                   else             
% %                       weight = [weight, 1];
% %                   end
%                     weight = [weight, 1];
%                 end
%                 size(goal)
%                 options_relax=optimoptions(@fgoalattain,'Display','final' ,'MaxIter',10000, 'tolx',1e-10,'tolfun',1e-10, 'TolCon',1e-10 ,'MaxFunEvals', 10000);
%                 [x_relax,fval_relax,attainfactor,exitflag_relax,output_relax,lambda_relax] = fgoalattain(@objuuv_relax,x0_relax,goal, weight,[],[],[],[],lb_relax,ub_relax,@myconuuv_relax, options_relax);
                
                options.Algorithm = 'sqp';  
                options.Display = 'off';
                tic;
                [x_relax,fval_relax,exitflag_relax]=fmincon(@objuuv_relaxation,x0_relax,[],[],[],[],lb_relax,ub_relax,@myconuuv_relaxation,options);
                t2_2 = toc;
                
                if exitflag_relax > 0  
%                     && fval_relax < fval_pre_relax
%                     flag_relax=[flag_relax, exitflag_relax];
%                     f_value_relax = [f_value_relax; fval_relax];
                    fprintf(2,'uuv_relaxation: have solution at current step: %d , %d\n',exitflag, current_step);
                    fval_pre_relax = fval_relax;
                    x_pre = x_relax;

                    break
                end

            end
        
%             if iternum_relax > 50 && fval < fval_pre
%                 fprintf(2,'uuv_relaxation: no solution at current step: %d , %d\n',exitflag_relax, current_step);
%                 break;
%             end
        end

    end

    %%update x
    if need_replan == 1 
%         if fval > 1e-6
        if (ratio(1) > eplison(1) || ratio(2) > eplison(2) || ratio(3) > eplison(3))&& exitflag_relax > 0  
            planning_time = [planning_time; t2_1 + t2_2];
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
%               engy = engy + x_relax(i)*(exp(x_relax(i + 2*uuv.N_s)+x_relax(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
                engy = engy + x_relax(i)*(exp(x_relax(i + 2*uuv.N_s)+x_relax(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
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
            planning_time = [planning_time; t2_1];
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
end
end








