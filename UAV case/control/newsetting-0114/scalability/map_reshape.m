name = 'gridmap-50.mat';
gridmap = load(name);
env = Environment();
env = gridmap.map;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);
for i = 1: length_o
    env.obstacle_list(i, 3) = env.obstacle_list(i, 3)*5;
end
for i = 1: length_p
    env.privacy_list(i, 3) = env.privacy_list(i, 3)*5;
end
name = 'gridmap-50_2.mat';
save(name, 'env');
