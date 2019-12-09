%%map initialize
function [map] = map_initialize(num, k)
global configure
configure = Configure();
map = Environment();
% rand = unifrnd(0,1);
% for i = 1:k %% k is the num of obstacles and privavy regions
%     map = map_tools(map, configure.start_point(1), configure.start_point(2), configure.start_point(3));
% end
map = map_initial(map, k);
% save('gridmap.mat','map');
name = 'gridmap-' + string(num) + '.mat';
save(name, 'map');

