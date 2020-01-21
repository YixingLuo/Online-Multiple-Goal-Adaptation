classdef Configure
    properties 
grid_x = 10
grid_y = 10
grid_z = 10
obstacle_likelihood = 0.7
privacy_likelihood = 0.3
map_likehood = 1
obstacle_radius = 0.5
privacy_radius = 0.8
obstacle_max = 0.5  %R_max
privacy_max = 1 % R_high
battery_budget = 60
battery_target = 30
battery_per = 0.5
battery_per2 = 0.2
forensic_target = 0.9
forensic_budget = 0.8
Time_target = 20
Time_budget = 40
viewradius = 2.2
velocity_max = 1
velocity_min = -1
sensor_accuracy = 1
radius = 0.2
Time_step = 0.5
battery_initial = 0
delay = 0
N;
start_point = [0,0,0,0]
end_point = [9,9,9,1]
    end
 methods
        function config = Configure(config)
%             config.N = floor(config.viewradius) / (config.Time_step * config.velocity_max);
            config.N = 2;
        end
        function config = EnergyTarget(config, battery_target)
            config.battery_target = battery_target;
        end 
        function config = TimeTarget(config, time_target)
            config.Time_target = time_target;
        end 
        function config = AccuracyTarget(config, accuracy_target)
            config.forensic_target = accuracy_target;
        end
        function config = ViewDisturbance(config, view)
             config.viewradius = view;
        end
        function config = SpeedDisturbance(config, speed)
             config.velocity_max = speed;
             config.velocity_min = -speed;
        end
        function config = AccuracyDisturbance(config, accuracy)
             config.sensor_accuracy = accuracy;
        end       
 end
end


        