function [x_initial, flag] = uuv_initial()
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
flag = [];
f_value = [];

exitflag = 0;
iternum = 0;
while exitflag <= 0  
    lb=[];
    ub=[];
    x0=[];
    for i = 1 : uuv.N_s % portion of time
        lb(i) = 0;
        ub(i) = 1;
        x0(i) = unifrnd(0,1/uuv.N_s);
    end
    for i = uuv.N_s + 1 : 3*uuv.N_s % accuracy and speed exploition
        lb(i) = 0;
        ub(i) = 1;
        x0(i) = unifrnd(0,1);
    end
    %%slash variable
    lb = [lb, 0, 0, 0];
    ub = [ub,uuv.acc_target-uuv.acc_budget, uuv.distance_target-uuv.distance_budget, uuv.energy_budget-uuv.energy_target];
    x0 = [x0, 0, 0, 0];
    % options=optimoptions(@fminsearch, 'Display','final' ,'MaxIter',100000, 'tolx',1e-100,'tolfun',1e-100, 'TolCon',1e-100 ,'MaxFunEvals', 100000 );
    optimset('Algorithm','sqp');  
    [x,fval,exitflag]=fmincon(@objuuv,x0,[],[],[],[],lb,ub,@myconuuv);
    
    if exitflag > 0 
        fprintf(2,'uuv_initial: have solution at current step: %d \n',exitflag);
        flag = [flag,exitflag];
        f_value = [f_value, fval];
        x_initial = x(1:15);
        break
    end        
    iternum = iternum+1;
    end
    
    if iternum > 10 && exitflag < 0 
        fprintf(2,'uuv_initial: no solution at current step: %d , %d\n',exitflag, current_step);
        flag = 0;
    end    
end