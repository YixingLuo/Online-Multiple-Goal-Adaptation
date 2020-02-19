function f = objuuv_normal(x)
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
%   engy = engy + (exp((x(i)+x(i + uuv.N_s))/2)-1)*uuv.s_energy(i);
%             engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)))/(exp(2))*uuv.s_energy(i);
              engy = engy + x(i)*(exp(x(i + 2*uuv.N_s)+x(i + uuv.N_s)) - 1)/(exp(2)-1)*uuv.s_energy(i);
%                          engy = engy + x(i)*uuv.s_energy(i);
% engy = engy + x(i)*(x(i + 2*uuv.N_s)+x(i + uuv.N_s))/2*uuv.s_energy(i);
end
energy = pastenergy + time_left * engy;

%% DS (max, accuracy, distance, energy)
% if ratio(1)>1e-6
%     f = [f, -min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget))];
% else
%     f = [f, -1];
% end
% if ratio(2)>1e-6
%     f = [f, -min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget))];
% else
%     f = [f, -1];
% end
% if ratio(3)>1e-6
%     f = [f, -min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target))];
% else
%     f = [f, -1];
% end

% f = -(min(1,(accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget)) + min(1,(distance - uuv.distance_budget)/(uuv.distance_target-uuv.distance_budget)) + min(1,(uuv.energy_budget - energy) /(uuv.energy_budget - uuv.energy_target)));
% f = -min(1,((accuracy - uuv.acc_budget)/(uuv.acc_target-uuv.acc_budget))) - min(1,((distance - uuv.distance_budget) / (uuv.distance_target-uuv.distance_budget))) - min(1,((uuv.energy_budget - energy) / (uuv.energy_budget - uuv.energy_target)));
f = ((accuracy - uuv.acc_target)/(uuv.acc_target-uuv.acc_budget)).^2 + ((distance - uuv.distance_target) / (uuv.distance_target-uuv.distance_budget)).^2 + ((uuv.energy_target - energy) / (uuv.energy_budget - uuv.energy_target)).^2;
% f = - accuracy/(uuv.acc_target-uuv.acc_budget) - distance / (uuv.distance_target-uuv.distance_budget) + energy/ (uuv.energy_budget - uuv.energy_target);
% f = max(0,(uuv.acc_target-accuracy)/(uuv.acc_target-uuv.acc_budget)) +  max(0,(uuv.distance_target-distance)/ (uuv.distance_target-uuv.distance_budget)) + max(0,(energy -  uuv.energy_target)/ (uuv.energy_budget - uuv.energy_target)); 
