global env
global configure
gridmap = load('gridmap-6.mat');
% env = gridmap.map;
% a = load('trajectory_normal.mat');
% trajectory = a.trajectory;

figure,
r_o = configure.obstacle_radius + configure.obstacle_max + configure.radius;
r_p = configure.privacy_radius + configure.privacy_max + configure.radius;

% r_o = configure.obstacle_radius + configure.radius;
% r_p = configure.privacy_radius + configure.radius;

% r_o = configure.obstacle_radius;
% r_p = configure.privacy_radius;


length_o = 0;
width_o = 0;
length_p = 0;
width_p = 0;
[length_o, width_o] = size(env.obstacle_list);
[length_p, width_p] = size(env.privacy_list);

for i = 1: length_o
    r=r_o;
    x0=env.obstacle_list(i,1);
    y0=env.obstacle_list(i,2);
    z0=env.obstacle_list(i,3);
    [x,y,z]=sphere;
    mesh(x0+r*x,y0+r*y,z0+r*z)
    hold on
end

for i = 1: length_p
    r=r_p;
    x0=env.privacy_list(i,1);
    y0=env.privacy_list(i,2);
    z0=env.privacy_list(i,3);
    [x,y,z]=sphere;
    mesh(x0+r*x,y0+r*y,z0+r*z)
    hold on
end

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
% 
% scatter3(xx,yy,zz,'k.')
% hold on
% plot3(xx,yy,zz,'r')
% axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])

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

scatter3(xx,yy,zz,'k.')
hold on
plot3(xx,yy,zz,'r')
axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])

