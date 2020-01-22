function f = objuuv_relax(x)
x;
sum = 0;
global uuv
global pastdistance
global pasttime
global pastenergy
global pastaccuracy
global ratio

f=[];

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
%             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
           engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%            engy = engy + x(i)*(x(i + 2*uuv.N_s)+x(i + uuv.N_s))/2*uuv.s_energy(i);
end
energy = pastenergy + time_left * engy;

%% DS (max, accuracy, distance, energy)
tempf = 0;
if ratio(1)>1e-6
    tempf = tempf -(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget);
end
if ratio(2)>1e-6
    tempf = tempf -(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget);
end
if ratio(3)>1e-6
    tempf  = tempf -(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target);
end
f = tempf;


% if ratio(1)>1e-6
%     f = [f, -(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)];
% %     f = [f, -min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget))];
% else
%     f = [f, -1];
% %     f = [f, -((accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)).^2];
% end
% if ratio(2)>1e-6
%     f = [f, -(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)];
% %     f = [f, -min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget))];
% else
%     f = [f, -1];
% %     f = [f, -((distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)).^2];
% end
% if ratio(3)>1e-6
%     f = [f, - (uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)];
% %     f = [f, -min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target))];
% else
%     f = [f, -1];
% %     f = [f, -((uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)).^2];
% end

% f = -(min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)) + min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)) + min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)));
% f = -(min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)));
