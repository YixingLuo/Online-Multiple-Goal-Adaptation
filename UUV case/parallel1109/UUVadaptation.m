

% k = 1: length(energy_list);
% figure, 
% plot(k, energy_list, 'k')
% axis([0, length(energy_list), 0, 200]);
% 
% k = 1: length(acc_list);
% figure, 
% plot(k, acc_list, 'k')
% axis([0, length(acc_list), 0, 1]);
% 
% for k = 1: length(speed)
%     if(speed(k))<0
%         k, speed(k)
%     end
% end
% k = 1: length(speed);
% figure, 
% plot(k, speed, 'k')
% axis([0, length(speed), 2.6, 3.6])

k = 1: 360;
% figure, 
% plot(k, distance_list, 'k')

% figure, 
% plot(k, usage_plan(:,1), 'm-')
% hold on
% plot(k, usage_plan(:,2), 'k--')
% hold on
% plot(k, usage_plan(:,3), 'g-.')
% hold on
% plot(k, usage_plan(:,4), 'r:')
% hold on
% plot(k, usage_plan(:,5), 'b')
% legend('sensor1','sensor2','sensor3','sensor4','sensor5')

figure, 
start = 360*3+1;
finish = start + 360-1;
plot(k, usage_plan1(start:finish,1), 'm-')
hold on
plot(k, usage_plan1(start:finish,2), 'k--')
hold on
plot(k, usage_plan1(start:finish,3), 'g-.')
hold on
plot(k, usage_plan1(start:finish,4), 'r:')
hold on
plot(k, usage_plan1(start:finish,5), 'b')
legend('sensor1','sensor2','sensor3','sensor4','sensor5')

figure, 
plot(k, usage_plan2(start:finish,1), 'm-')
hold on
plot(k, usage_plan2(start:finish,2), 'k--')
hold on
plot(k, usage_plan2(start:finish,3), 'g-.')
hold on
plot(k, usage_plan2(start:finish,4), 'r:')
hold on
plot(k, usage_plan2(start:finish,5), 'b')
legend('sensor1','sensor2','sensor3','sensor4','sensor5')

figure, 
plot(k, usage_plan3(start:finish,1), 'm-')
hold on
plot(k, usage_plan3(start:finish,2), 'k--')
hold on
plot(k, usage_plan3(start:finish,3), 'g-.')
hold on
plot(k, usage_plan3(start:finish,4), 'r:')
hold on
plot(k, usage_plan3(start:finish,5), 'b')
legend('sensor1','sensor2','sensor3','sensor4','sensor5')

% figure,
% plot(k, relax_list, 'b')
% hold on
% plot(k, no_relax_list, 'k')
% axis([0, length(speed), 0, 360])