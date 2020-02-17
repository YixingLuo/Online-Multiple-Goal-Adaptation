function tempf = objuuv_relaxation(x)
x;
sum = 0;
global uuv
global pastdistance
global pasttime
global pastenergy
global pastaccuracy
global ratio
global eplison

tempf=[];

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
if ratio(1)> eplison(1)
    tempf = tempf + max(0,(uuv.acc_target-accuracy)/(uuv.acc_target-uuv.acc_budget));
%     tempf = tempf + (uuv.acc_target-accuracy)/(uuv.acc_target-uuv.acc_budget);
%     tempf = tempf - min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget));
% else
%     tempf = tempf - 1;
end
if ratio(2)> eplison(2)
    tempf = tempf + max(0,(uuv.distance_target-distance)/ (uuv.distance_target-uuv.distance_budget));
%     tempf = tempf + (uuv.distance_target-distance)/ (uuv.distance_target-uuv.distance_budget);
%     tempf = tempf -min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget));
% else
%     tempf = tempf - 1;
end
if ratio(3)> eplison(3)
    tempf  = tempf  + max(0,(energy -  uuv.energy_target)/ (uuv.energy_budget - uuv.energy_target));
%     tempf  = tempf  + (energy -  uuv.energy_target)/ (uuv.energy_budget - uuv.energy_target);
%     tempf  = tempf -min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target));
% else
%     tempf = tempf - 1;
end
f = tempf;
% f=[];
% if ratio(1)> eplison
%     f = [f, -(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)];
% %     f = [f, -min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget))];
% else
%     f = [f, -1];
% %     f = [f, -((accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)).^2];
% end
% if ratio(2)> eplison
%     f = [f, -(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)];
% %     f = [f, -min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget))];
% else
%     f = [f, -1];
% %     f = [f, -((distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)).^2];
% end
% if ratio(3)> eplison
%     f = [f, -(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)];
% %     f = [f, -min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target))];
% else
%     f = [f, -1];
% %     f = [f, -((uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)).^2];
% end
% size(f)
