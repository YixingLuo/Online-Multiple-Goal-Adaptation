function [acc_variance, acc_ratio, distance_variance, distance_ratio, energy_variance, energy_ratio] = relaxation_ratio(x)
global uuv
acc_variance = x(end-2);
distance_variance = x(end-1);
energy_variance = x(end);

acc_ratio = x(end-2)/(uuv.acc_target-uuv.acc_budget);
distance_ratio = x(end-1)/(uuv.distance_target-uuv.distance_budget);
energy_ratio = x(end)/(uuv.energy_budget-uuv.energy_target);