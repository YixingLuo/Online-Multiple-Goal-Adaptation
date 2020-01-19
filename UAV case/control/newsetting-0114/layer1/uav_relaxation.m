% clc
% clear
% num_map = 29;
% num_condition = 4;
% indextemp = [15,18,29];
function [data, trajectory,velocity_history,planning_time, rate_list, tag_list] = uav_relaxation(num_map)
global env
global env_known
global configure
global eplison
global ratio
configure = Configure();
% eplison = 0;
current_step = 0;
start_point = [configure.start_point(1),configure.start_point(2),configure.start_point(3),configure.start_point(4)];
end_point = [configure.end_point(1),configure.end_point(2),configure.end_point(3),configure.end_point(4)];

global current_point
current_point = start_point;
global trajectory
trajectory = [current_point];
% trajectory = [];
global plan_con
global time
global information
global energy
global past_distance
global velocity_history
velocity_history=[];
time = 0;
information = 0;
energy = 0;
past_distance = 0;
global initial_N
initial_N = configure.N;
flag=[];
flag_relax=[];
f_lambda=[];
plan_con = zeros(100, 100);
following_plan = []; %% the initial plan and update online
following_point = [start_point];
relax_num = 0;
plan_num = 0;
planning_time = [];
data = zeros(1,12);
rate_list = [];
tag_list = [];
no_solution_flag = 0;
env = Environment();
name = 'gridmap-' + string(num_map) + '.mat';
gridmap = load(name);
env = gridmap.map;
env_known = Environment();

% if num_map > 0
%     name_con = 'condition' + string(num_condition) + '.mat';
%     cond = load(name_con);
%     index_cond = 1;
% end

for k = 1: (configure.N+1) 
    for i = 1:3
        if configure.start_point(i) > configure.end_point(i)
            following_plan(k,i) = configure.velocity_min;
        else
            following_plan(k,i) = configure.velocity_max;
        end
    end
    following_plan(k,4) = 1;
end

for k = 2: configure.N
    following_point = [following_point;following_point(k-1,1)+following_plan(k-1,1)*configure.Time_step, following_point(k-1,2)+following_plan(k-1,2)*configure.Time_step, following_point(k-1,3)+following_plan(k-1,3)*configure.Time_step, following_point(k-1,4)];
end
following_point = [following_point; end_point];


while (1)
    needplan = 0;
    
%     if num_map > 0
%         if  index_cond <= length(indextemp) && current_step == indextemp(index_cond)        
%             needplan = 1;
%             if cond.condition(index_cond,1) == 1
%                 configure = EnergyTarget(configure, cond.condition(index_cond,2));
%                 elseif cond.condition(index_cond,1) == 2
%                     configure = TimeTarget(configure, cond.condition(index_cond,2));
%                 elseif cond.condition(index_cond,1) == 3
%                     configure = AccuracyTarget(configure, cond.condition(index_cond,2));
%                 elseif cond.condition(index_cond,1) == 4
% %                     configure = ViewDisturbance(configure, cond.condition(index_cond,2));
%                     configure = EnergyDisturbance(configure, cond.condition(index_cond,2), cond.condition(index_cond,3));
%                 elseif cond.condition(index_cond,1) == 5
%                     configure = SpeedDisturbance(configure, cond.condition(index_cond,2));
%                 elseif cond.condition(index_cond,1) == 6
%                     configure = AccuracyDisturbance(configure, cond.condition(index_cond,2));
%             end
%             index_cond = index_cond+1;
%         end
%     end
    
    fprintf(2,'uav_relaxation: current step %d %d\n', current_step, num_map);
    exitflag = 0;
    exitflag_relax = 0;
    
    if current_point(1) == end_point(1) && current_point(2) == end_point(2) && current_point(3) == end_point(3)
        fprintf(2,'reach the destination!\n')
        DS_i = [information, min(1,(information - configure.forensic_budget)/(configure.forensic_target - configure.forensic_budget))];
        DS_t = [time,min(1,(configure.Time_budget - time)/(configure.Time_budget - configure.Time_target))];
        DS_e = [energy,min(1,(configure.battery_budget - energy) /(configure.battery_budget - configure.battery_target))];
        [SR, DS_SR, PR, DS_PR, DS_acc] = caculate_risk(trajectory, env);
        data = [DS_i, DS_t, DS_e, SR, DS_SR, PR, DS_PR, plan_num, relax_num, DS_acc];
%         name1 = 'planningtime_relaxation.mat';
%         save(name1, 'planning_time');
%         name2 = 'trajectory_relaxation.mat';
%         save(name2, 'trajectory');
%         name3 = 'velocity_history_relaxation.mat';
%         save(name3, 'velocity_history');
        break
    end
    
    if current_step > configure.Time_budget/configure.Time_step
        fprintf(2,'no solution \n');
        break
    end
    
    fprintf('initial current point: [%f , %f, %f, %f]\n', current_point)
%     if current_point(1) > end_point(1) && current_point(2) > end_point(2) && current_point(3) > end_point(3)
%         break
%     end
%     following_plan, following_point
    if size(following_plan, 1) == 1
        current_step = current_step + 1;
        fprintf(2,'the last step!\n')
        dis = sqrt((current_point(1)-end_point(1))^2 + (current_point(2)-end_point(2))^2 + (current_point(3)-end_point(3))^2);
%         t_x = (end_point(1)-current_point(1))/configure.velocity_max;
%         t_y = (end_point(2)-current_point(2))/configure.velocity_max;
%         t_z = (end_point(3)-current_point(3))/configure.velocity_max;
        last_t = dis/sqrt(following_plan(1,1)^2 + following_plan(1,2)^2 + following_plan(1,3)^2);
%         information = (information * past_distance + following_plan(1,4) * dis) / (past_distance + dis);
        information = (information * time + following_plan(1,4) * last_t)/(time + last_t);
        time = time + last_t;
        %         energy = energy + configure.battery_per * dis;
        energy = energy + configure.battery_per * dis * following_plan(1,4);
        past_distance = past_distance + dis;
        current_point = [end_point(1), end_point(2), end_point(3), following_plan(1,4)];
        traj = [trajectory; current_point];
        trajectory = traj;
        velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];
        continue
    end
           
    length_o = 0;
    width_o = 0;
    length_p = 0;
    width_p = 0;
    [length_o, width_o] = size(env.obstacle_list);
    [length_p, width_p] = size(env.privacy_list);
    %% 1114
%     env_known = remove_obstacle(env_known);
%     env_known = remove_privacy(env_known);
    for oo = 1:length_o
        if sqrt((env.obstacle_list(oo, 1)-current_point(1)).^2+(env.obstacle_list(oo, 2)-current_point(2)).^2+(env.obstacle_list(oo, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
            if isempty(env_known.obstacle_list) || isempty(find(env_known.obstacle_list==env.obstacle_list(oo,:)))               
                env_known = add_obstacle(env_known, env.obstacle_list(oo, 1), env.obstacle_list(oo, 2), env.obstacle_list(oo, 3));
            end
        end
    end
    
    for pp = 1:length_p
        if sqrt((env.privacy_list(pp, 1)-current_point(1)).^2+(env.privacy_list(pp, 2)-current_point(2)).^2+(env.privacy_list(pp, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
            if isempty(env_known.privacy_list) || isempty(find(env_known.privacy_list==env.privacy_list(pp,:)))               
                env_known = add_privacy(env_known, env.privacy_list(pp, 1), env.privacy_list(pp, 2), env.privacy_list(pp, 3));
            end
        end
    end

    if needplan == 0
        nowp_x = [];
        nowp_y = [];
        nowp_z = [];
        ws = [];
        nowp_x(1) = current_point(1);
        nowp_y(1) = current_point(2);
        nowp_z(1) = current_point(3);
        ws(1) = current_point(4);
        for i = 1: size(following_plan,1) - 1
%             nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.end_point(1));
%             nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.end_point(2));
%             nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.end_point(3));
            %% 1113
            nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x-configure.radius);
            nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y-configure.radius);
            nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z-configure.radius);
            nowp_x(i+1) = max(nowp_x(i+1), 0);
            nowp_y(i+1) = max(nowp_y(i+1), 0);
            nowp_z(i+1) = max(nowp_z(i+1), 0);
            ws(i+1) = following_plan(i,4);
        end
        nowp_x = [nowp_x, configure.end_point(1)];
        nowp_y = [nowp_y, configure.end_point(2)];
        nowp_z = [nowp_z, configure.end_point(3)];
        ws = [ws, following_plan(end,4)];
        for i = 1 : length(nowp_x)
            following_point(i,:) = [nowp_x(i),nowp_y(i),nowp_z(i), ws(i)];
        end
        % following_point
%         following_point = [following_point;nowp_x']; following_point = [following_point;nowp_y']; following_point = [following_point;nowp_z'];
        next_point = following_point(2,:);
        current_point = next_point;
        fprintf(2,'contiue the previous plan!!\n')
        fprintf('next point: [%f , %f, %f, %f]\n', current_point)
        traj = [trajectory; current_point];
        trajectory = traj;
        velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];
        [a, b] = size(trajectory); %% to caculate the source used
        distance = 0;
        info = 0;
        engy = 0;
        for i = 1: a-1
             distance = distance + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
%              info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
             info = info + trajectory(i+1,4)*configure.Time_step;
             engy = engy + configure.battery_per *configure.Time_step * trajectory(i+1,4) + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
        end
        for i = 1: size(velocity_history,1)-1
             engy = engy + configure.battery_per2 * sqrt((velocity_history(i+1,1)-velocity_history(i,1)).^2+(velocity_history(i+1,2)-velocity_history(i,2)).^2+(velocity_history(i+1,3)-velocity_history(i,3)).^2);
        end        
        energy = engy;
        past_distance = distance;
        time = configure.Time_step * (a-1);
        if time == 0
            information = 0;
        else
            information = info/time;
        end   
        current_step = current_step + 1;
        
%         fprintf(2,'with planning: following_point previous:\n')
%         following_point, following_plan
        following_plan([1],:)=[]; %%update the following plan
        following_point([1],:)=[];
        
        tt = sqrt((nowp_x(end)-nowp_x(end-1)).^2+(nowp_y(end)-nowp_y(end-1)).^2+(nowp_z(end)-nowp_z(end-1)).^2) / sqrt(following_plan(end,1).^2+following_plan(end,2).^2+following_plan(end,3).^2);
        if tt > configure.Time_step           
            following_plan(end+1,:)=following_plan(end,:);
            following_point(end,:) = [min(following_point(end-1,1)+following_plan(end,1)*configure.Time_step, end_point(1)), min(following_point(end-1,2)+following_plan(end,2)*configure.Time_step, end_point(2)), min(following_point(end-1,3)+following_plan(end,3)*configure.Time_step,end_point(3)), following_point(end,4)];
        end
        if following_point(end,1) ~= end_point(1) || following_point(end,2) ~= end_point(2) || following_point(end,3) ~= end_point(3)
            following_point(end+1,:) = [end_point(1),end_point(2),end_point(3),following_point(end, 4)];
        end
        continue
    end

    iternum = 0;
    while exitflag <=0 && iternum <= 10
%         infeasible = 1;
%         while infeasible
            lb=[];
            ub=[];
            x0=[];
    
            initial_N = size(following_plan,1)-1;
    
            for i = 1 : (initial_N+1) * 3
                lb(i) = configure.velocity_min; %% negative velocity
                ub(i) = configure.velocity_max;
                x0(i) = ub(i) - iternum * 2/30;
%                 x0(i) = unifrnd(lb(i),ub(i));
            end
        
            for i = 1: 3 %% velocity constraint for the last point
                index = (initial_N+1) * i;
                lb(index) = configure.velocity_min;
                ub(index) = configure.velocity_max;
                if (following_point(end,i)-following_point(end-1,i)) > 0
                    ub(index) = min(configure.velocity_max, (following_point(end,i)-following_point(end-1,i))/configure.Time_step);
                else
                    lb(index) = max(configure.velocity_min, (following_point(end,i)-following_point(end-1,i))/configure.Time_step);
                end
                ub(index) = max(lb(index),ub(index)); 
                x0(index) = max(lb(index),ub(index));
            end
        
            for i = (initial_N+1) * 3 + 1 : (initial_N+1) * 4
                lb(i) = configure.forensic_budget;
                ub(i) = configure.sensor_accuracy;
                x0(i) = configure.forensic_target;
%                 x0(i) = unifrnd(lb(i), ub(i));
            end
    
            length_o = 0;
            width_o = 0;
            length_p = 0;
            width_p = 0;
            [length_o, width_o] = size(env_known.obstacle_list);
            [length_p, width_p] = size(env_known.privacy_list);
            bound_o = length_o * (initial_N+1);
            bound_p = length_p * (initial_N+1);
    
            for i = 1:bound_o %% safe
                lb = [lb,0];
                ub = [ub,configure.obstacle_max];
                x0 = [x0,0];
            end
    
            for i = 1:bound_p %% privacy
                lb = [lb,0];
                ub = [ub,configure.privacy_max];
                x0 = [x0,0];
            end
            lb = [lb, 0, 0];
            ub = [ub, configure.Time_budget-configure.Time_target, configure.battery_budget-configure.battery_target];
            x0 = [x0, 0, 0];


        %interior-point, active-set, trust-region-reflective, sqp, sqp-legacy
%         options.StepTolerance = 1e-10;
%         options.MaxFunctionEvaluations = 100000;
        options.algorithm = 'sqp';
%         options.tolx = 1e-10;
%         options.tolfun = 1e-10;
%         options.TolCon = 1e-10;
        options.Display = 'off';
%         options.algorithm = 'interior-point-convex'; 
%         options.MaxIter = 10000;
%         options.MaxFunEvals = 100000;
%         options=optimoptions(@fmincon,'Algorithm', 'sqp', 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
        tic;
        [x,fval,exitflag]=fmincon(@objuav,x0,[],[],[],[],lb,ub,@myconuav,options);
        t2_1 = toc;
        tau = configure.Time_step;

        iternum = iternum + 1;
        [safety_variance, safety_ratio, privacy_variance, privacy_ratio, info_variance, info_ratio, time_variance, time_ratio, energy_variance, energy_ratio] = goal_selection(x);
        ratio = [safety_ratio, privacy_ratio, info_ratio, time_ratio, energy_ratio];
%         ratio = [safety_ratio,1,1,1,1];
        
        if exitflag > 0 
            break
        end
    end
    
    %% RELAXATION
    if ratio(1) > eplison || ratio(2) > eplison
       rate_list = [rate_list, ratio'];
       tag = [0,0,0,0,0];
%        tag = [0];
        for kk = 1:length(ratio)
            if ratio(kk) > eplison
                tag(kk)=1;
            end
        end
        tag_list = [tag_list, tag'];
       fprintf(2,"need relexation!! %d %d\n" ,relax_num + 1, current_step);   
       exitflag_relax = 0;
       iternum_relax = 0;
       while exitflag_relax <= 0 && iternum_relax<=10
            infeasible = 1;
            iternum_relax = iternum_relax+1;
%             while infeasible
                
               lb_relax=[];
               ub_relax=[];
               x0_relax=[];
               for i = 1 : (initial_N+1) * 3
                   lb_relax(i) = configure.velocity_min; %% negative velocity
                   ub_relax(i) = configure.velocity_max;
                   x0_relax(i) = ub_relax(i) - iternum_relax * 2/30;    
%                    x0_relax(i) = unifrnd(lb_relax(i), ub_relax(i));
               end        
               for i = 1: 3 %% velocity constraint for the last point                
                    index = (initial_N+1) * i;
                    lb_relax(index) = configure.velocity_min;
                    ub_relax(index) = configure.velocity_max;
                    if (following_point(end,i)-following_point(end-1,i)) > 0
                        ub_relax(index) = min(configure.velocity_max, (following_point(end,i)-following_point(end-1,i))/configure.Time_step);
                    else
                        lb_relax(index) = max(configure.velocity_min, (following_point(end,i)-following_point(end-1,i))/configure.Time_step);
                    end
                    ub_relax(index) = max(lb_relax(index),ub_relax(index)); 
                    x0_relax(index) = max(lb_relax(index),ub_relax(index));
                end        
                for i = (initial_N+1) * 3 + 1 : (initial_N+1) * 4
                    if ratio(3)> eplison
                        lb_relax(i) = configure.forensic_budget;
                    else
                        lb_relax(i) = configure.forensic_target;
                    end
                    ub_relax(i) = configure.sensor_accuracy;
                    x0_relax(i) = configure.forensic_target;
%                     x0_relax(i) = unifrnd(lb_relax(i), ub_relax(i));
                end

%             options_relax=optimoptions(@fgoalattain,'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );   
%             [x_relax,fval_relax,attainfactor,exitflag_relax,output_relax,lambda_relax] = fgoalattain(@obj_relax,x0_relax,goal, weight,[],[],[],[],lb_relax,ub_relax,@mycon_relax, options_relax);
%             options=optimoptions(@fmincon,'Algorithm', 'sqp', 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
            options.algorithm = 'sqp';
%             options.display = 'off';
%             options.tolx = 1e-10;
%             options.tolfun = 1e-10;
%             options.TolCon = 1e-10;           
%             options.algorithm = 'interior-point-convex'; 
%             options.MaxIter = 10000;
%             options.MaxFunEvals = 100000;
            tic;
            [x_relax,fval_relax,exitflag_relax] = fmincon(@objuav_relaxation,x0_relax,[],[],[],[],lb_relax,ub_relax,@myconuav_relaxation,options);  
            t2_2 = toc;
            if exitflag_relax > 0 
                break           
            end
       end
       if exitflag_relax > 0
               relax_num = relax_num + 1;
                planning_time = [planning_time; t2_1 + t2_2];
                flag_relax = [flag_relax, exitflag_relax];
                fprintf(2,"there is a solution for relax!!%d, %d\n",exitflag_relax,current_step)

                for k = 1: (initial_N+1) 
                    following_plan (k,:) = [x(k), x(k + initial_N + 1), x(k + 2 *(initial_N + 1)), x(k + 3 *(initial_N + 1))];
                end
                nowp_x = [];
                nowp_y = [];
                nowp_z = [];
                ws = [];
                nowp_x(1) = current_point(1);
                nowp_y(1) = current_point(2);
                nowp_z(1) = current_point(3);
                ws(1) = current_point(4);
                for i = 1: size(following_plan,1) - 1
                    %% 1113
                    nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x-configure.radius);
                    nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y-configure.radius);
                    nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z-configure.radius);
                    nowp_x(i+1) = max(nowp_x(i+1), 0);
                    nowp_y(i+1) = max(nowp_y(i+1), 0);
                    nowp_z(i+1) = max(nowp_z(i+1), 0);
                    ws(i+1) = following_plan(i,4);
                end
                nowp_x = [nowp_x, configure.end_point(1)];
                nowp_y = [nowp_y, configure.end_point(2)];
                nowp_z = [nowp_z, configure.end_point(3)];
                ws = [ws, following_plan(end,4)];
                for i = 1 : length(nowp_x)
                    following_point(i,:) = [nowp_x(i),nowp_y(i),nowp_z(i), ws(i)];
                end
                next_point = following_point(2,:);

                current_point = next_point;
                fprintf('next point: [%f , %f, %f, %f]\n', current_point)
                traj = [trajectory; current_point];
                trajectory = traj;
                velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];

                [a, b] = size(trajectory); %% to caculate the source used
                distance = 0;
                info = 0;
                engy = 0;
                for i = 1: a-1
                    distance = distance + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
%                   info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                    info = info + trajectory(i+1,4)*configure.Time_step;
                    engy = engy + configure.battery_per *configure.Time_step * trajectory(i+1,4) + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                end
                for i = 1: size(velocity_history,1)-1
                     engy = engy + configure.battery_per2 * sqrt((velocity_history(i+1,1)-velocity_history(i,1)).^2+(velocity_history(i+1,2)-velocity_history(i,2)).^2+(velocity_history(i+1,3)-velocity_history(i,3)).^2);
                end
                energy =  engy;
                past_distance = distance;
                time = configure.Time_step * (a-1);
                if time == 0
                    information = 0;
                else
                    information = info/time;
                end 
                current_step = current_step + 1;
            
                following_plan([1],:)=[]; %%update the following plan
                following_point([1],:)=[];
                tt = sqrt((nowp_x(end)-nowp_x(end-1)).^2+(nowp_y(end)-nowp_y(end-1)).^2+(nowp_z(end)-nowp_z(end-1)).^2) / sqrt(following_plan(end,1).^2+following_plan(end,2).^2+following_plan(end,3).^2);
                if tt > configure.Time_step           
                    following_plan(end+1,:) = following_plan(end,:);
                    following_point(end,:) = [min(following_point(end-1,1)+following_plan(end,1)*configure.Time_step, end_point(1)), min(following_point(end-1,2)+following_plan(end,2)*configure.Time_step, end_point(2)), min(following_point(end-1,3)+following_plan(end,3)*configure.Time_step,end_point(3)), following_point(end,4)];
                end
                if following_point(end,1) ~= end_point(1) || following_point(end,2) ~= end_point(2) || following_point(end,3) ~= end_point(3)
                    following_point(end+1,:) = [end_point(1),end_point(2),end_point(3),following_point(end, 4)];
                end
       elseif exitflag > 0
                plan_num = plan_num + 1;
                fprintf('no need replanning')
                planning_time = [planning_time; t2_1];
                flag = [flag, exitflag];
                fprintf(2,"there is a solution!!%d, %d\n",exitflag,current_step)

                for k = 1: (initial_N+1) 
                    following_plan (k,:) = [x(k), x(k + initial_N + 1), x(k + 2 *(initial_N + 1)), x(k + 3 *(initial_N + 1))];
                end
                nowp_x = [];
                nowp_y = [];
                nowp_z = [];
                ws = [];
                nowp_x(1) = current_point(1);
                nowp_y(1) = current_point(2);
                nowp_z(1) = current_point(3);
                ws(1) = current_point(4);
                for i = 1: size(following_plan,1) - 1
                    %% 1113
                    nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x-configure.radius);
                    nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y-configure.radius);
                    nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z-configure.radius);
                    nowp_x(i+1) = max(nowp_x(i+1), 0);
                    nowp_y(i+1) = max(nowp_y(i+1), 0);
                    nowp_z(i+1) = max(nowp_z(i+1), 0);
                    ws(i+1) = following_plan(i,4);
                end
                nowp_x = [nowp_x, configure.end_point(1)];
                nowp_y = [nowp_y, configure.end_point(2)];
                nowp_z = [nowp_z, configure.end_point(3)];
                ws = [ws, following_plan(end,4)];
                for i = 1 : length(nowp_x)
                    following_point(i,:) = [nowp_x(i),nowp_y(i),nowp_z(i), ws(i)];
                end
                next_point = following_point(2,:);

                current_point = next_point;
                fprintf('next point: [%f , %f, %f, %f]\n', current_point)
                traj = [trajectory; current_point];
                trajectory = traj;
                velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];
                [a, b] = size(trajectory); %% to caculate the source used
                distance = 0;
                info = 0;
                engy = 0;
                for i = 1: a-1
                    distance = distance + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
     %              info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                    info = info + trajectory(i+1,4)*configure.Time_step;
                    engy = engy + configure.battery_per *configure.Time_step * trajectory(i+1,4) + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                end
                for i = 1: size(velocity_history,1)-1
                    engy = engy + configure.battery_per2 * sqrt((velocity_history(i+1,1)-velocity_history(i,1)).^2+(velocity_history(i+1,2)-velocity_history(i,2)).^2+(velocity_history(i+1,3)-velocity_history(i,3)).^2);
                end
                energy = engy;
                past_distance = distance;
                time = configure.Time_step * (a-1);
                if time == 0
                    information = 0;
                else
                    information = info/time;
                end 
                current_step = current_step + 1;

                following_plan([1],:)=[]; %%update the following plan
                following_point([1],:)=[];
                tt = sqrt((nowp_x(end)-nowp_x(end-1)).^2+(nowp_y(end)-nowp_y(end-1)).^2+(nowp_z(end)-nowp_z(end-1)).^2) / sqrt(following_plan(end,1).^2+following_plan(end,2).^2+following_plan(end,3).^2);
                if tt > configure.Time_step           
                    following_plan(end+1,:) = following_plan(end,:);
                    following_point(end,:) = [min(following_point(end-1,1)+following_plan(end,1)*configure.Time_step, end_point(1)), min(following_point(end-1,2)+following_plan(end,2)*configure.Time_step, end_point(2)), min(following_point(end-1,3)+following_plan(end,3)*configure.Time_step,end_point(3)), following_point(end,4)];
                end
                if following_point(end,1) ~= end_point(1) || following_point(end,2) ~= end_point(2) || following_point(end,3) ~= end_point(3)
                    following_point(end+1,:) = [end_point(1),end_point(2),end_point(3),following_point(end, 4)];
                end
       end
    elseif exitflag > 0 
            plan_num = plan_num + 1;
            fprintf('no need replanning')
            planning_time = [planning_time; t2_1];
            flag = [flag, exitflag];
            fprintf(2,"there is a solution!!%d, %d\n",exitflag,current_step)

            for k = 1: (initial_N+1) 
                following_plan (k,:) = [x(k), x(k + initial_N + 1), x(k + 2 *(initial_N + 1)), x(k + 3 *(initial_N + 1))];
            end
            nowp_x = [];
            nowp_y = [];
            nowp_z = [];
            ws = [];
            nowp_x(1) = current_point(1);
            nowp_y(1) = current_point(2);
            nowp_z(1) = current_point(3);
            ws(1) = current_point(4);
            for i = 1: size(following_plan,1) - 1
                %% 1113
                nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x-configure.radius);
                nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y-configure.radius);
                nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z-configure.radius);
                nowp_x(i+1) = max(nowp_x(i+1), 0);
                nowp_y(i+1) = max(nowp_y(i+1), 0);
                nowp_z(i+1) = max(nowp_z(i+1), 0);
                ws(i+1) = following_plan(i,4);
            end
            nowp_x = [nowp_x, configure.end_point(1)];
            nowp_y = [nowp_y, configure.end_point(2)];
            nowp_z = [nowp_z, configure.end_point(3)];
            ws = [ws, following_plan(end,4)];
            for i = 1 : length(nowp_x)
                following_point(i,:) = [nowp_x(i),nowp_y(i),nowp_z(i), ws(i)];
            end
            next_point = following_point(2,:);

            current_point = next_point;
            fprintf('next point: [%f , %f, %f, %f]\n', current_point)
            traj = [trajectory; current_point];
            trajectory = traj;
            velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];
            [a, b] = size(trajectory); %% to caculate the source used
            distance = 0;
            info = 0;
            engy = 0;
            for i = 1: a-1
                distance = distance + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
 %              info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                info = info + trajectory(i+1,4)*configure.Time_step;
                engy = engy + configure.battery_per *configure.Time_step * trajectory(i+1,4) + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
            end
            for i = 1: size(velocity_history,1)-1
                engy = engy + configure.battery_per2 * sqrt((velocity_history(i+1,1)-velocity_history(i,1)).^2+(velocity_history(i+1,2)-velocity_history(i,2)).^2+(velocity_history(i+1,3)-velocity_history(i,3)).^2);
            end
            energy = engy;
            past_distance = distance;
            time = configure.Time_step * (a-1);
            if time == 0
                information = 0;
            else
                information = info/time;
            end 
            current_step = current_step + 1;
            
            following_plan([1],:)=[]; %%update the following plan
            following_point([1],:)=[];
            tt = sqrt((nowp_x(end)-nowp_x(end-1)).^2+(nowp_y(end)-nowp_y(end-1)).^2+(nowp_z(end)-nowp_z(end-1)).^2) / sqrt(following_plan(end,1).^2+following_plan(end,2).^2+following_plan(end,3).^2);
            if tt > configure.Time_step           
                following_plan(end+1,:) = following_plan(end,:);
                following_point(end,:) = [min(following_point(end-1,1)+following_plan(end,1)*configure.Time_step, end_point(1)), min(following_point(end-1,2)+following_plan(end,2)*configure.Time_step, end_point(2)), min(following_point(end-1,3)+following_plan(end,3)*configure.Time_step,end_point(3)), following_point(end,4)];
            end
            if following_point(end,1) ~= end_point(1) || following_point(end,2) ~= end_point(2) || following_point(end,3) ~= end_point(3)
                following_point(end+1,:) = [end_point(1),end_point(2),end_point(3),following_point(end, 4)];
            end
    end
%          exitflag, exitflag_relax, ratio
       if exitflag <= 0 && exitflag_relax <= 0
           plan_num = plan_num + 1;
           fprintf(2,'no solution for relaxation \n');
           no_solution_flag = 1;
%            rate_list = [0;0;0;0;0];
%            tag_list = [0;0;0;0;0];
%            break;
        nowp_x = [];
        nowp_y = [];
        nowp_z = [];
        ws = [];
        nowp_x(1) = current_point(1);
        nowp_y(1) = current_point(2);
        nowp_z(1) = current_point(3);
        ws(1) = current_point(4);
        for i = 1: size(following_plan,1) - 1
            nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x-configure.radius);
            nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y-configure.radius);
            nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z-configure.radius);
            nowp_x(i+1) = max(nowp_x(i+1), 0);
            nowp_y(i+1) = max(nowp_y(i+1), 0);
            nowp_z(i+1) = max(nowp_z(i+1), 0);
            ws(i+1) = following_plan(i,4);
        end
        nowp_x = [nowp_x, configure.end_point(1)];
        nowp_y = [nowp_y, configure.end_point(2)];
        nowp_z = [nowp_z, configure.end_point(3)];
        ws = [ws, following_plan(end,4)];
        for i = 1 : length(nowp_x)
            following_point(i,:) = [nowp_x(i),nowp_y(i),nowp_z(i), ws(i)];
        end
        next_point = following_point(2,:);
        current_point = next_point;
        fprintf(2,'contiue the previous plan!!\n')
        fprintf('next point: [%f , %f, %f, %f]\n', current_point)
        traj = [trajectory; current_point];
        trajectory = traj;
        velocity_history = [velocity_history; following_plan(1,1), following_plan(1,2), following_plan(1,3), following_plan(1,4)];
        [a, b] = size(trajectory); %% to caculate the source used
        distance = 0;
        info = 0;
        engy = 0;
        for i = 1: a-1
             distance = distance + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
%              info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
             info = info + trajectory(i+1,4)*configure.Time_step;
             engy = engy + configure.battery_per *configure.Time_step * trajectory(i+1,4) + sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
        end
        for i = 1: size(velocity_history,1)-1
             engy = engy + configure.battery_per2 * sqrt((velocity_history(i+1,1)-velocity_history(i,1)).^2+(velocity_history(i+1,2)-velocity_history(i,2)).^2+(velocity_history(i+1,3)-velocity_history(i,3)).^2);
        end        
        energy = engy;
        past_distance = distance;
        time = configure.Time_step * (a-1);
        if time == 0
            information = 0;
        else
            information = info/time;
        end   
        current_step = current_step + 1;
        following_plan([1],:)=[]; %%update the following plan
        following_point([1],:)=[];
        
        tt = sqrt((nowp_x(end)-nowp_x(end-1)).^2+(nowp_y(end)-nowp_y(end-1)).^2+(nowp_z(end)-nowp_z(end-1)).^2) / sqrt(following_plan(end,1).^2+following_plan(end,2).^2+following_plan(end,3).^2);
        if tt > configure.Time_step           
            following_plan(end+1,:)=following_plan(end,:);
            following_point(end,:) = [min(following_point(end-1,1)+following_plan(end,1)*configure.Time_step, end_point(1)), min(following_point(end-1,2)+following_plan(end,2)*configure.Time_step, end_point(2)), min(following_point(end-1,3)+following_plan(end,3)*configure.Time_step,end_point(3)), following_point(end,4)];
        end
        if following_point(end,1) ~= end_point(1) || following_point(end,2) ~= end_point(2) || following_point(end,3) ~= end_point(3)
            following_point(end+1,:) = [end_point(1),end_point(2),end_point(3),following_point(end, 4)];
        end     
       end
    
    end
end