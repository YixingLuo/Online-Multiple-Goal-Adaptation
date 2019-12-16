classdef Configure
    properties 
grid_x = 50
grid_y = 50
grid_z = 10
obstacle_likelihood = 0.7
privacy_likelihood = 0.3
map_likehood = 1
obstacle_radius = 0.5
privacy_radius = 0.5
obstacle_max = 0.5  %R_max
privacy_max = 1 % R_high
battery_budget = 400
battery_target = 200
battery_per = 0.5
battery_per2 = 0.2
forensic_target = 0.9
forensic_budget = 0.5
Time_target = 180
Time_budget = 300
viewradius = 2
velocity_max = 0.5
velocity_min = -0.5
sensor_accuracy = 1
radius = 0.2
Time_step = 0.5
battery_initial = 0
delay = 0
N;
start_point = [0,0,0,0]
end_point = [49,49,0.5,1]
    end
 methods
        function config = Configure(config)
%             config.N = floor(config.viewradius) / (config.Time_step * config.velocity_max);
            config.N = 4;
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


        