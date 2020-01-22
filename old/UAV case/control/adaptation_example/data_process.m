env = Environment();
name = 'gridmap-29.mat';
gridmap = load(name);
env = gridmap.map;
a = load('trajectory.mat');
trajectory = a.trajectory;
[SR, PR,dis_o,dis_p] = caculate_risk(trajectory, env);
for i = 1:size(dis_o,1)
    for j = 1:size(dis_o,2)
        if dis_o(i,j)<0.2 + 0.5 + 0.5
            fprintf('obstacle')
            i,j,dis_o(i,j)
%             j
        end
    end
end

for i = 1:size(dis_p,1)
    for j = 1:size(dis_p,2)
        if dis_p(i,j)<0.2+ 0.8 + 1
           fprintf('privacy')
            i,j,dis_p(i,j)
%             j
        end
    end
end