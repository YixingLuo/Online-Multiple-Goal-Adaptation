%%map initialize
function [map] = map_initialize(num, num_o)
global configure
configure = Configure();
map = Environment();
name = 'gridmap-0.mat';
gridmap = load(name);
gridmap = gridmap.map;
privacy_list = gridmap.privacy_list;
map = map_initial_with_privacy(map, num_o, privacy_list);
name = 'gridmap-' + string(num) + '.mat';
save(name, 'map');



% map = Environment();
% map = map_initial3(map, 0, 4);
% name = 'gridmap-' + string(0) + '.mat';
% save(name, 'map');
% [data, trajectory,velocity_history,planning_time, rate_list, tag_list] = uav_relaxation(0)