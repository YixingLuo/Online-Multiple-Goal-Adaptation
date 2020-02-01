function f = objuuv(x)
global uuv
% acc = 0;
% for i = 1:length(x)
%     acc = acc + x(i)*uuv.s_accuracy(i);
% end
% f =  x(end-2)*100 + x(end-1)/1e3 + x(end)/1e7;
% f = x(end-2) + x(end-1) +  x(end);
f = x(end-2)/(uuv.acc_target-uuv.acc_budget) + x(end-1)/(uuv.distance_target-uuv.distance_budget) + x(end)/(uuv.energy_budget-uuv.energy_target);
% f = x(end-2)/1 + x(end-1)/uuv.distance_max + x(end)/uuv.energy_budget;