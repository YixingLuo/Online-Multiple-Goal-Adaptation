% 1: uuv = EnergyBudget(uuv, 5 * 1e6);
% 2: uuv = DistanceBudget(uuv, 105*1000);
% 3: uuv = AccuracyBudget(uuv, 0.85);
% 4: uuv = SensorError(uuv, 3, 0.43);
% 5: uuv = SensorFailure(uuv, 4);
% 6: uuv = EnergyDisturbance(uuv, 1, 190);
function [condition, index] = randomsituation(num,k)
% disturb = randperm(7);
global uuv
% uuv = UnmannedUnderwaterVehicle();
l = [3,6,9,12,15,18,21];
disturb = randi([1,6],1,l(k));
% if k == 1
%     disturb = [4,5,6];   
% elseif k ==2
%     disturb = [1,2,3,4,5,6];   
% elseif k ==3
%     disturb = [1,2,3,4,5,6,4,5,6];
% elseif k ==4   
%     disturb = [1,2,3,4,5,6,1,2,3,4,5,6];
% elseif k ==5
%     disturb = [1,2,3,4,5,6,1,2,3,4,5,6,4,5,6];
% elseif k ==6
%     disturb = [1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6];
% end
% disturb2 = [3,6,3,1,1,4,5,2,2];
a=2:359;
K=randperm(length(a));
N=length(disturb);
index1 = a(K(1:N));
% index1 = randperm(359,length(disturb));
index = sort(index1);

% disturb = [];
% while (1)
%     disturb = randperm(9);
%     if find(disturb==7) < find(disturb==1)
%         continue
%     elseif find(disturb==8) < find(disturb==2)
%         continue
%     elseif find(disturb==9) < find(disturb==3)
%         continue
%     else
%         break
%     end
% end
condition = [];
for i = 1: length(disturb)
    if disturb(i) == 1
        energy_ratio = 45 + unidrnd(10);
        energy = energy_ratio * 1e5;
%         energy_ratio = 45;
%         energy = energy_ratio * 1e5;
%         energy = min(uuv.energy_target* energy_ratio/100,uuv.energy_budget - 1);
        condition(i,:) = [1,energy,0];
    elseif disturb(i) == 2
        distance_ratio = 100 + unidrnd(10);
        distance = distance_ratio * 1e3;
%         distance_ratio = 110;
%         distance = distance_ratio * 1e3;
%         distance = max(uuv.distance_target*distance_ratio/100,uuv.distance_budget + 1);
        condition(i,:) = [2,distance,0];
    elseif disturb(i) == 3
        acc = 85 + unidrnd(10);
        condition(i,:) = [3,acc/100,0];
%         acc = 92;
%         condition(i,:) = [3,acc/100,0];
%         acc_ratio = 95 + unidrnd(10);
%         acc = min(uuv.acc_target*acc_ratio/100,0.99);
%         acc = max(uuv.acc_target*acc_ratio/100,uuv.acc_budget + 0.01);
%         condition(i,:) = [3,acc,0];
    elseif disturb(i) == 4
        idx = unidrnd(5); 
        acc = 20 + unidrnd(30);
        condition(i,:) = [4,idx,acc/100];    
%         acc_ratio = 50 + unidrnd(50);
%         acc = uuv.s_accuracy(idx)*acc_ratio/100;
%         condition(i,:) = [4,idx,acc];

%     elseif disturb(i) == 5
%         idx = unidrnd(5);
%         condition(i,:) = [5,idx,0];
    elseif disturb(i) == 5
        idx = unidrnd(5);
        energy = 200 + unidrnd(50);
        condition(i,:) = [5,idx,energy];
%         energy_ratio = 100 + unidrnd(50);
%         energy = uuv.s_energy(idx)*energy_ratio/100;
%         condition(i,:) = [5,idx,energy];
   elseif disturb(i) == 6
        idx = unidrnd(5);
        speed = 10 + unidrnd(15);
        condition(i,:) = [6,idx,speed/10];
%         speed_ratio = 50 + unidrnd(50);
%         idx = unidrnd(5);
%         speed = uuv.s_speed(idx)*speed_ratio/100;
%         condition(i,:) = [6,idx,speed];
    end    
end
name = 'condition' + string(num) + '.mat';
save(name, 'condition');



