% 1: uuv = EnergyBudget(uuv, 5 * 1e6);
% 2: uuv = DistanceBudget(uuv, 105*1000);
% 3: uuv = AccuracyBudget(uuv, 0.85);
% 4: uuv = SensorError(uuv, 3, 0.43);
% 5: uuv = SensorFailure(uuv, 4);
% 6: uuv = EnergyDisturbance(uuv, 1, 190);
function [condition, index] = randomsituation(num,k)
% disturb = randperm(7);
global configure
l = [2,4,6];
disturb = randi([1,3],1,l(k));

a=2:(configure.Time_target/configure.Time_step-1);
K=randperm(length(a));
N=length(disturb);
index1 = a(K(1:N));
index = sort(index1);
condition = [];

% for i = 1: length(disturb)
%     if disturb(i) == 1
%         energy = configure.battery_budget;
%         condition(i,:) = [1,energy];
%     elseif disturb(i) == 2
%         time = configure.Time_budget;
%         condition(i,:) = [2,time];
%     elseif disturb(i) == 3
%         accuracy = configure.forensic_budget;
%         condition(i,:) = [3,accuracy];
%     end    
% end


for i = 1: length(disturb)
    if disturb(i) == 1
        rate = unifrnd (0,1);
        energy = 15 + unidrnd(10); 
        condition(i,:) = [1,energy];
    elseif disturb(i) == 2
        rate = unifrnd (0,1);
        time = 12 + unidrnd(6);
        condition(i,:) = [2,time];
    elseif disturb(i) == 3
        rate = unifrnd (0,1);
        accuracy = (85 + unidrnd(10))/100;
        condition(i,:) = [3,accuracy];
    elseif disturb(i) == 4
        viewradius = (15 + unidrnd(10))/10;
        condition(i,:) = [4,viewradius];
    elseif disturb(i) == 5
        speed = (5 + unidrnd(5))/10;
        condition(i,:) = [5,speed];
    elseif disturb(i) == 6
        acc = (50 + unidrnd(50))/100;
        condition(i,:) = [6,acc];
    end    
end
name = 'condition' + string(num) + '.mat';
save(name, 'condition');


