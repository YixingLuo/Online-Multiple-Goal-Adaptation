% 1: uuv = EnergyBudget(uuv, 5 * 1e6);
% 2: uuv = DistanceBudget(uuv, 105*1000);
% 3: uuv = AccuracyBudget(uuv, 0.85);
% 4: uuv = SensorError(uuv, 3, 0.43);
% 5: uuv = SensorFailure(uuv, 4);
% 6: uuv = EnergyDisturbance(uuv, 1, 190);
function [condition, index] = randomsituation(num,k)
% disturb = randperm(7);
global configure
l = [3];
disturb = randi([4,6],1,l(k));

a=2:(configure.Time_target/configure.Time_step-1);
K=randperm(length(a));
N=length(disturb);
index1 = a(K(1:N));
index = sort(index1);

condition = [];
for i = 1: length(disturb)
    if disturb(i) == 1
        energy = 15 + unidrnd(10); 
        condition(i,:) = [1,energy];
    elseif disturb(i) == 2
        time = 12 + unidrnd(6);
        condition(i,:) = [2,time];
    elseif disturb(i) == 3
        accuracy = 85 + unidrnd(10);
        condition(i,:) = [3,accuracy/100];
    elseif disturb(i) == 4
        viewradius = 15 + unidrnd(10);
        condition(i,:) = [4,viewradius/10];
    elseif disturb(i) == 5
        speed = 5 + unidrnd(5);
        condition(i,:) = [5,speed/10];
    elseif disturb(i) == 6
        acc = 50 + unidrnd(50);
        condition(i,:) = [6,acc/100];
    end    
end
name = 'condition' + string(num) + '.mat';
save(name, 'condition');



