classdef Configure
    properties 
grid_x = 10
grid_y = 10
grid_z = 10
obstacle_likelihood = 0.7
privacy_likelihood = 0.3
map_likehood = 1
obstacle_radius = 0.5
privacy_radius = 0.5
obstacle_max = 0.5  %R_max
privacy_max = 1.5 % R_high
battery_budget = 30
battery_target = 15
battery_per = 1
forensic_target = 0.9
forensic_budget = 0.5
Time_target = 20
Time_budget = 40
viewradius = 2
velocity_max = 1
velocity_min = -1
radius = 0.5
Time_step = 0.5
battery_initial = 0
delay = 0
N;
start_point = [0,0,0,0]
end_point = [9,9,9,1]
    end
 methods
        function config = Configure(config)
            config.N = floor(config.viewradius) / (config.Time_step * config.velocity_max);
%             config.N = 5;
        end
 end
end


        