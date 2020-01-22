maplabel = importdata('maplabel_privacy.txt');
map_height = importdata('maplabel_height_update.txt');
obstacle_s = [];
privacy_s = [];
obstacle_l = [];
privacy_l = [];
[a1,b1] = size(maplabel);

for i = 1:a1
    for j = 1:b1
        if maplabel(i,j) == 1
            height = map_height(i,j)/10;
            obstacle_s = [obstacle_s; i-1, j-1, 0];
            obstacle_l = [obstacle_l; 1, 1, height];
        elseif maplabel(i,j) == 2 || maplabel(i,j) == 3 || maplabel(i,j) == 4
            height = map_height(i,j)/10;
            privacy_s = [privacy_s; i-1, j-1, 0];
            privacy_l = [privacy_l; 1, 1, height];
        end
    end
end


figure,
[ao,bo] = size(obstacle_s);
[ap,bp] = size(privacy_s);
% obstacle_s(1),obstacle_l(1)
for i = 1:ao
    boxsurface(obstacle_s(i,:),obstacle_l(i,:),1)
    hold on
end
for i = 1:ap
    boxsurface(privacy_s(i,:),privacy_l(i,:),2)
    hold on
end
% boxsurface([0,0,0],[1 1 1])
% hold on
% boxsurface([1 0, 0],[1 1 1])
% hold off
% xlim=get(gca,'xlim');
% lx=xlim(2)-xlim(1);
% xlim(1)=xlim(1)-lx*0.2;
% xlim(2)=xlim(2)+lx*0.2;
% set(gca,'xlim',xlim);
% ylim=get(gca,'ylim');
% ly=ylim(2)-ylim(1);
% ylim(1)=ylim(1)-ly*0.2;
% ylim(2)=ylim(2)+ly*0.2;
% set(gca,'ylim',ylim);
% zlim=get(gca,'zlim');
% lz=zlim(2)-zlim(1);
% zlim(1)=zlim(1)-lz*0.2;
% zlim(2)=zlim(2)+lz*0.2;
% set(gca,'zlim',zlim);occ_grid-50
view(3)
