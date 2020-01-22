maplabel = importdata('maplabel_privacy.txt');
map_height = importdata('maplabel_height_update.txt');
obstacle_c = [];
privacy_c = [];
map = Environment();
[a1,b1] = size(maplabel);

for i = 1:a1
    for j = 1:b1
        if maplabel(i,j) == 1
            height = map_height(i,j)/10;
            for k = 1:ceil(height)
                map = map.add_obstacle(i-0.5, j-0.5, k-0.5);
            end
        elseif maplabel(i,j) == 2 || maplabel(i,j) == 3 || maplabel(i,j) == 4
            height = map_height(i,j)/10;
            for k = 1:ceil(height)
                map = map.add_privacy(i-0.5, j-0.5, k-0.5);
            end
        end
    end
end

name = 'gridmap-100.mat';
save(name, 'map');
