function [c,ceq] = myconuuv_relaxation(x)
c=[];
ceq=[];
global uuv
global pastdistance
global pasttime
global pastenergy
global pastaccuracy
global ratio
global eplison
%% time
time_left = uuv.time_target - pasttime;

%% accuracy
acc = 0;
for i = 1:uuv.N_s
   acc = acc + x(i)*uuv.s_accuracy(i)*x(i+2*uuv.N_s);
end
accuracy  = (pastaccuracy * pasttime + acc * time_left) / (pasttime + time_left);

%% distance
speed = 0;
for i = 1:uuv.N_s
     speed = speed + x(i)*uuv.s_speed(i)*x(i+uuv.N_s);
end
distance = pastdistance + time_left * speed;

%% energy
engy = 0;
for i = 1:uuv.N_s
%   engy = engy + (exp((x(i)+x(i + uuv.N_s))/2)-1)*uuv.s_energy(i);
%             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%            engy = engy + x(i)*uuv.s_energy(i);
%              engy = engy + x(i)*(x(i + 2*uuv.N_s)+x(i + uuv.N_s))/2*uuv.s_energy(i);
end
energy = pastenergy + time_left * engy;

uuv.energy_target; uuv.distance_budget;
% c = [c, accuracy - 1];
% c = [c, - accuracy + uuv.acc_budget];
% c = [c, - distance + uuv.distance_budget];
% c = [c, energy - uuv.energy_budget];
% c = [c, - energy + 0];
% c=[c, (uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)-1];
% c=[c, -(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)];
% c=[c,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)-1];
% c=[c,-(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)];
% c=[c,(acc - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)-1];
% c=[c,-(acc - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)];

if ratio(1)> eplison
    c = [c, - accuracy + uuv.acc_budget];
else
    c = [c, - accuracy + uuv.acc_target];    
end

if ratio(2)> eplison
    c = [c, - distance + uuv.distance_budget];
else
    c = [c, - distance + uuv.distance_target];    
end

if ratio(3)> eplison
    c = [c, energy - uuv.energy_budget];
else
    c = [c, energy - uuv.energy_target];    
end    



sum = 0;
for i = 1:uuv.N_s
    sum = sum + x(i);
end
ceq = [ceq, sum-1];
% c = [c, sum - 1];
% sum = 0;
% for i = uuv.N_s + 1:2*uuv.N_s
%     sum = sum + x(i);
% end
% % ceq = [sum-1];
% c = [c, sum - 1];
