configure = Configure();
gridmap = load('gridmap-100.mat');
a = load('trajectory_100_2.mat');
trajectory = a.trajectory;
h=figure(1);
env = gridmap.map;
r_o = configure.obstacle_radius;
r_p = configure.privacy_radius;
% r_o = configure.obstacle_radius + configure.obstacle_max + configure.radius;
% r_p = configure.privacy_radius + configure.privacy_max + configure.radius;
length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);
axis_pos= [0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z];
ax1 = axes;
for i = 1: length_o
    r=r_o;
    ox0=env.obstacle_list(i,1);
    oy0=env.obstacle_list(i,2);
    oz0=env.obstacle_list(i,3);
    [ox,oy,oz]=sphere;
    mesh(ox0+r*ox,oy0+r*oy,oz0+r*oz);
    hold on
end
box on
% axis off
hidden off
axis(axis_pos);
colormap(ax1,winter);
xlabel('X')
ylabel('Y')
zlabel('Z')
set(gca,'fontname','Times')

ax2 = axes;
for i = 1: length_p
    r=r_p;
    px0=env.privacy_list(i,1);
    py0=env.privacy_list(i,2);
    pz0=env.privacy_list(i,3);
    [px,py,pz]=sphere;
    mesh(px0+r*px,py0+r*py,pz0+r*pz)
    hold on
end
% box off
axis off
hidden off
axis(axis_pos );
colormap(ax2,autumn);
set(gca,'fontname','Times');


% a=0;
% b=0;
% [a, b] = size(trajectory1);
% xx=[];
% yy=[];
% zz=[];
% dis = [];
% for i =1:a
%     xx = [xx, trajectory1(i,1)];
%     yy = [yy, trajectory1(i,2)];
%     zz = [zz, trajectory1(i,3)];             
% end

% scatter3(xx,yy,zz,'k.')
% hold on
% plot3(xx,yy,zz,'r')


% a=0;
% b=0;
% [a, b] = size(trajectory2);
% xx=[];
% yy=[];
% zz=[];
% dis = [];
% for i =1:a
%     xx = [xx, trajectory2(i,1)];
%     yy = [yy, trajectory2(i,2)];
%     zz = [zz, trajectory2(i,3)];              
% end
% 
% scatter3(xx,yy,zz,'k.')
% hold on
% plot3(xx,yy,zz,'r')
% axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])

% a=0;
% b=0;
% [a, b] = size(trajectory3);
% xx=[];
% yy=[];
% zz=[];
% dis = [];
% for i =1:a
%     xx = [xx, trajectory3(i,1)];
%     yy = [yy, trajectory3(i,2)];
%     zz = [zz, trajectory3(i,3)];           
% end
% 
% scatter3(xx,yy,zz,'k.')
% hold on
% plot3(xx,yy,zz,'r')
% axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])

a=0;
b=0;
[a, b] = size(trajectory);
xx=[];
yy=[];
zz=[];
dis = [];
for i =1:a
    xx = [xx, trajectory(i,1)];
    yy = [yy, trajectory(i,2)];
    zz = [zz, trajectory(i,3)];           
end

% scatter3(xx,yy,zz,'k.')
hold on
plot3(xx,yy,zz,'k','linewidth',2)
axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])
xlabel('X');
ylabel('Y');
zlabel('Z');
set(gca,'fontname','Times');
