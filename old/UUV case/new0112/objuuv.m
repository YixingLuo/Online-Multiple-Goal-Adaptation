function f = objuuv(x)
global uuv
% acc = 0;
% for i = 1:length(x)
%     acc = acc + x(i)*uuv.s_accuracy(i);
% end
% f =  x(end-2)*100 + x(end-1)/1e3 + x(end)/1e7;
% f = x(end-2) + x(end-1) +  x(end);
f = x(end-2)/1 + x(end-1)/uuv.distance_max + x(end)/uuv.energy_budget;