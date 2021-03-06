% clc
% clear
% num = 1;
function [data, trajectory,velocity_history,planning_time] = uav_relax3(num)
global env
global env_known
global configure
configure = Configure();
global eplison 
% eplison = 0.01;
current_step = 1;
start_point = [configure.start_point(1),configure.start_point(2),configure.start_point(3),0];
end_point = [configure.end_point(1),configure.end_point(2),configure.end_point(3),0];

global current_point
current_point = start_point;
global trajectory
trajectory = [current_point];
% trajectory = [];
global plan_x
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
f_value=[];
f_lambda=[];
plan_con = zeros(100, 100);
plan_x = zeros(100, 100);
following_plan = []; %% the initial plan and update online
following_point = [start_point];
planning_time = [];
plan_num = 0;
data = zeros(1,11);

env = Environment();
name = 'gridmap-' + string(num) + '.mat';
gridmap = load(name);
% gridmap = load('gridmap.mat');
env = gridmap.map;
env_known = Environment();
env_view = Environment();

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
    fprintf(2,'uav_relax: current step %d\n', current_step);
%     following_point, following_plan
    t1=clock;
    if current_point(1) == end_point(1) && current_point(2) == end_point(2) && current_point(3) == end_point(3)
        fprintf(2,'reach the destination!\n')
        DS_i = [information, min(1,(information - configure.forensic_budget)/(configure.forensic_target - configure.forensic_budget))];
        DS_t = [time,min(1,(configure.Time_budget - time)/(configure.Time_budget - configure.Time_target))];
        DS_e = [energy,min(1,(configure.battery_budget - energy) /(configure.battery_budget - configure.battery_target))];
        [SR_unknown, PR_unknown] = caculate_risk(trajectory, env);
        [SR_known, PR_known] = caculate_risk(trajectory, env_known);
        data = [DS_i, DS_t, DS_e, SR_known, SR_unknown, PR_known, PR_unknown, plan_num];
%         name1 = 'planningtime.mat';
%         save(name1, 'planning_time');
%         name2 = 'trajectory.mat';
%         save(name2, 'trajectory');
%         name3 = 'velocity_history.mat';
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
        fprintf(2,'the last step!\n')
        dis = sqrt((current_point(1)-end_point(1))^2 + (current_point(2)-end_point(2))^2 + (current_point(3)-end_point(3))^2);
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
        
        t2=clock;
        planning_time = [planning_time; etime(t2,t1)];
        continue
    end
           
    length_o = 0;
    width_o = 0;
    length_p = 0;
    width_p = 0;
    [length_o, width_o] = size(env.obstacle_list);
    [length_p, width_p] = size(env.privacy_list);
    %% 1124
%     env_view = remove_obstacle(env_view);
%     env_view = remove_privacy(env_view);
    for oo = 1:length_o
        if sqrt((env.obstacle_list(oo, 1)-current_point(1)).^2+(env.obstacle_list(oo, 2)-current_point(2)).^2+(env.obstacle_list(oo, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
%             env_view = add_obstacle(env_view, env.obstacle_list(oo, 1), env.obstacle_list(oo, 2), env.obstacle_list(oo, 3));
            if isempty(env_known.obstacle_list) || isempty(find(env_known.obstacle_list==env.obstacle_list(oo,:)))               
                env_known = add_obstacle(env_known, env.obstacle_list(oo, 1), env.obstacle_list(oo, 2), env.obstacle_list(oo, 3));
            end
        end
    end
    
    for pp = 1:length_p
        if sqrt((env.privacy_list(pp, 1)-current_point(1)).^2+(env.privacy_list(pp, 2)-current_point(2)).^2+(env.privacy_list(pp, 3)-current_point(3)).^2) <=configure.viewradius
            needplan = 1;
%             env_view = add_privacy(env_view, env.privacy_list(pp, 1), env.privacy_list(pp, 2), env.privacy_list(pp, 3));
            if isempty(env_known.privacy_list) || isempty(find(env_known.privacy_list==env.privacy_list(pp,:)))               
                env_known = add_privacy(env_known, env.privacy_list(pp, 1), env.privacy_list(pp, 2), env.privacy_list(pp, 3));
            end
        end
    end
%     %% 1122
%     if needplan == 1
%         plan_num = plan_num + 1;
%     end
%     %% 1120
%     if abs(following_plan(1,1) - 0) < 1e-6 && abs(following_plan(1,2) - 0) < 1e-6 && abs(following_plan(1,3) - 0) < 1e-6  || (mod(current_step,configure.N) == 0)
%         needplan = 1;
%     end
%     if length(env_known.obstacle_list) == 0 && length(env_known.privacy_list) == 0
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
            %% 1113
                nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x - 1);
                nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y - 1);
                nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z - 1);
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
%         following_point
%         following_point = [following_point;nowp_x']; following_point = [following_point;nowp_y']; following_point = [following_point;nowp_z'];
        next_point = following_point(2,:);
        if next_point(1) == current_point(1) && next_point(2) == current_point(2) && next_point(3) == current_point(3)
            needplan = 1;
            break;
        end
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
             engy = engy + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
        end
        %         energy = configure.battery_per * distance;
        energy = configure.battery_per * engy;
        past_distance = distance;
        time = configure.Time_step * (a-1);
        if time == 0
            information = 0;
        else
            information = info/time;
        end 
%         if distance == 0
%             information = 0;
%         else
%             information = info/distance;
%         end        

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

        t2=clock;
        planning_time = [planning_time; etime(t2,t1)];
        continue
    end
    
    exitflag = 0;
    iternum = 0;
    while exitflag <=0 && iternum <= 20
%         infeasible = 1;
%         while infeasible
            lb=[];
            ub=[];
            x0=[];
    
            initial_N = size(following_plan,1)-1;
    
            for i = 1 : (initial_N+1) * 3
                lb(i) = configure.velocity_min; %% negative velocity
                ub(i) = configure.velocity_max;
                x0(i) = unifrnd(lb(i),ub(i));
%                 x0(i) = ub(i);
%                 bound_index = ceil(i/(initial_N+1));
%                 if current_point(bound_index)> configure.end_point(bound_index)
%                     x0(i) = unifrnd(lb(i),0);
%                 else                   
%                     x0(i) = unifrnd(0,ub(i));
%                 end
            end
        
            for i = 1: 3 %% velocity constraint for the last point
                index = (initial_N+1) * i;
                lb(index) = configure.velocity_min;
%                 ub(index) = configure.velocity_max;
                ub(index) = min(configure.velocity_max, (following_point(end,i)-following_point(end-1,i))/configure.Time_step);
                ub(index) = max(lb(index),ub(index));
%                 x0(index) = max(lb(index),ub(index));
               if current_point(i)> configure.end_point(i)
                    x0(index) = unifrnd(lb(i),0);
               else                   
                    x0(index) = unifrnd(0,ub(i));
               end
            end
        
            for i = (initial_N+1) * 3 + 1 : (initial_N+1) * 4
                lb(i) = 0;
                ub(i) = 1;
                x0(i) = unifrnd(lb(i),ub(i));
            end
    
            length_o = 0;
            width_o = 0;
            length_p = 0;
            width_p = 0;
            [length_o, width_o] = size(env_known.obstacle_list);
            [length_p, width_p] = size(env_known.privacy_list); 
            bound_o = length_o * (initial_N+1);
            bound_p = length_p * (initial_N+1);
    
%             for i = 1:bound_o %% safe
%                 lb = [lb,0];
%                 ub = [ub,configure.obstacle_max];
%                 x0 = [x0,0];
%             end
%     
%             for i = 1:bound_p %% privacy
%                 lb = [lb,0];
%                 ub = [ub,configure.privacy_max];
%                 x0 = [x0,0];
%             end   

%             lb = [lb,0, 0, 0];
%             ub = [ub,configure.forensic_target-configure.forensic_budget, configure.Time_budget-configure.Time_target, configure.battery_budget-configure.battery_target];
%             x0 = [x0,0, 0, 0];

            lb = [lb,0,0,0, 0, 0];
            ub = [ub,configure.obstacle_max,configure.privacy_max,configure.forensic_target-configure.forensic_budget, configure.Time_budget-configure.Time_target, configure.battery_budget-configure.battery_target];
            x0 = [x0,0,0,0, 0, 0];
            
            %% 1125
            lb = [lb, 0, 0, 0, 0, 0];
            ub = [ub,1, 1, 1, 1, 1];
            x0 = [x0, 0, 0, 0, 0, 0];
            
%             constr = mycon(x0)
%             constr_value = constr(constr>=0);
%             if isempty(constr_value)
%                 infeasible = 0;
%                 break
%             end  
%         end
        %interior-point, active-set, trust-region-reflective, sqp, sqp-legacy
%         options.StepTolerance = 1e-10;
%         options.MaxFunctionEvaluations = 100000;
%         options=optimoptions(@fmincon,'Algorithm', 'sqp', 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
        options.algorithm = 'sqp';
%         options.MaxIter = 100000;
%         options.MaxFunEvals = 100000;
%         objuav_relax2(x0),myconuav_relax2(x0)
        [x,fval,exitflag,output,lambda]=fmincon(@objuav_relax3,x0,[],[],[],[],lb,ub,@myconuav_relax3,options);
       
        tau = configure.Time_step;

        iternum = iternum + 1;
        if exitflag > 0
            plan_num = plan_num + 1;
            plan_x (current_step,1) = length(x);
            for k = 1:length(x)
                plan_x (current_step,k+1) = x(k);
            end
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
                nowp_x(i+1) = min(following_plan(i,1)*configure.Time_step + nowp_x(i), configure.grid_x - 1);
                nowp_y(i+1) = min(following_plan(i,2)*configure.Time_step + nowp_y(i), configure.grid_y - 1);
                nowp_z(i+1) = min(following_plan(i,3)*configure.Time_step + nowp_z(i), configure.grid_z - 1);
                nowp_x(i+1) = max(nowp_x(i+1), 0);
                nowp_y(i+1) = max(nowp_y(i+1), 0);
                nowp_z(i+1) = max(nowp_z(i+1), 0);
%                 nowp_x(i+1) = following_plan(i,1)*configure.Time_step + nowp_x(i);
%                 nowp_y(i+1) = following_plan(i,2)*configure.Time_step + nowp_y(i);
%                 nowp_z(i+1) = following_plan(i,3)*configure.Time_step + nowp_z(i);
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
%                 info = info + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
                info = info + trajectory(i+1,4)*configure.Time_step;
                engy = engy + trajectory(i+1,4)*sqrt((trajectory(i+1,1)-trajectory(i,1)).^2+(trajectory(i+1,2)-trajectory(i,2)).^2+(trajectory(i+1,3)-trajectory(i,3)).^2);
            end
%             energy = configure.battery_per * distance;
            energy = configure.battery_per * engy ;
            time = configure.Time_step * (a-1);
            if time == 0
                information = 0;
            else
                information = info/time;
            end 
%             if distance == 0
%                 information = 0;
%             else
%                 information = info/distance;
%             end
            past_distance = distance;

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
            t2=clock;
            planning_time = [planning_time; etime(t2,t1)];
            break
        end
    end

    if iternum > 20 && exitflag<=0
        fprintf(2,'no solution \n');
        break;
    end
    end
end
