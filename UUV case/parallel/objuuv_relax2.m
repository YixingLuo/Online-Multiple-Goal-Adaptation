function f = objuuv_relax2(x)
global uuv
global eplison
% acc = 0;
% for i = 1:length(x)
%     acc = acc + x(i)*uuv.s_accuracy(i);
% end
% f =  x(end-2)*100 + x(end-1)/1e3 + x(end)/1e7;
% f = 0;
% if x(end-2) > eplison
%     f = f + x(end-2)/(uuv.acc_target-uuv.acc_budget) + 10;
% end
% if x(end-1) > eplison
%     f = f + x(end-1)/(uuv.distance_target-uuv.distance_budget) + 10;
% end
% if x(end) > eplison
%     f = f + x(end)/(uuv.energy_budget-uuv.energy_target) + 10;
% end
% f = x(end-2) + x(end-1) +  x(end);
% y = [0,0,0];
% for i = 1:3
%     if (x(end-3+1)>0.5)
%         y(i) = 1;
%     end
% end
f = x(end-2) + x(end-1)/uuv.distance_max + x(end)/uuv.energy_budget;
% f = y(1)*x(end-2-3)/1 + y(2)*x(end-1-3)/uuv.distance_max + y(3)* x(end-3)/uuv.energy_budget;