% 1: uuv = EnergyBudget(uuv, 5 * 1e6);
% 2: uuv = DistanceBudget(uuv, 105*1000);
% 3: uuv = AccuracyBudget(uuv, 0.85);
% 4: uuv = SensorError(uuv, 3, 0.43);
% 5: uuv = SensorFailure(uuv, 4);
% 6: uuv = EnergyDisturbance(uuv, 1, 190);
function [condition, index] = randomsituation(num,k)
% disturb = randperm(7);
global configure
configure = Configure();
l = [2,4,6];
disturb = randi([4,6],1,l(k));

a=2:(configure.Time_target/configure.Time_step-1);
K=randperm(length(a));
N=length(disturb);
index1 = a(K(1:N));
index = sort(index1);

condition = [];
for i = 1: length(disturb)
    if disturb(i) == 1
        energy = 16 + unidrnd(8); 
        condition(i,:) = [1,energy,0];
    elseif disturb(i) == 2
        time = 12 + unidrnd(6);
        condition(i,:) = [2,time,0];
    elseif disturb(i) == 3
        accuracy = 85 + unidrnd(10);
        condition(i,:) = [3,accuracy/100,0];
    elseif disturb(i) == 4
%         viewradius = (1 + unidrnd(5))/2;
%         condition(i,:) = [4,viewradius];
        engy1 = (45 + unidrnd(10))*0.01;
        engy2 = (18 + unidrnd(4))*0.01;
        condition(i,:) = [4, engy1, engy2];
        
    elseif disturb(i) == 5
        speed = (80 + unidrnd(20))/100;
        condition(i,:) = [5,speed,0];
    elseif disturb(i) == 6
        acc = (80 + unidrnd(20))/100;
        condition(i,:) = [6,acc,0];
    end     
end
name = 'condition' + string(num) + '.mat';
save(name, 'condition');
name = 'index' + string(num) + '.mat';
save(name, 'index');




