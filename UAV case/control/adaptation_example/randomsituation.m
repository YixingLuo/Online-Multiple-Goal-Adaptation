
function [condition, index] = randomsituation(num,k)
% disturb = randperm(7);
global configure
l = [3];
flag = 0;
while flag == 0
  disturb = randi([1,6],1,l(k));  
  if disturb(1)~=4 && disturb(2)~=4 && disturb(3)~= 4
     flag = 1;
  end
end


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
        energy = 25 + unidrnd(4); 
        condition(i,:) = [1,energy];
    elseif disturb(i) == 2
        time = 15 + unidrnd(4);
        condition(i,:) = [2,time];
    elseif disturb(i) == 3
        accuracy = (90 + unidrnd(5))/100;
        condition(i,:) = [3,accuracy];
    elseif disturb(i) == 4
        viewradius = (16 + unidrnd(8))/10;
        condition(i,:) = [4,viewradius];
    elseif disturb(i) == 5
        speed = (80 + unidrnd(20))/100;
        condition(i,:) = [5,speed];
    elseif disturb(i) == 6
        acc = (80 + unidrnd(20))/100;
        condition(i,:) = [6,acc];
    end    
end
name = 'condition' + string(num) + '.mat';
save(name, 'condition');



