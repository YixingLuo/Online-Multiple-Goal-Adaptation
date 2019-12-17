gridmap = load('gridmap-100.mat');
env = gridmap.map;
configure = Configure();
% figure('visible','off')
% figure,
r_o = configure.obstacle_radius;
r_p = configure.privacy_radius;

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


% plot parameter -------------------------------
% xmin= -10;xmax = 15;
% ymin= -10;ymax = 15;
% zmin=	0;zmax = 15;

% view point ----------------------------------
% vx = -50; vy = 20;

% fontsize ------------------------------------
% mm_fz = 12;

% set fig size --------------------------------
% fig_pos = [0.09 0.15 0.53 0.75];
axis_pos= [0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z];

h=figure(1);
% set(h, 'Position', [100, 100, 800, 500]);
% fig_pos = [0.09 0.15 0.53 0.75];
ax1 = axes;
% set(ax1,'position',fig_pos);
for i = 1: length_o
    r=r_o;
    ox0=env.obstacle_list(i,1);
    oy0=env.obstacle_list(i,2);
    oz0=env.obstacle_list(i,3);
    [ox,oy,oz]=sphere;
    mesh(ax1,ox0+r*ox,oy0+r*oy,oz0+r*oz);
    shading flat  
    hold on
end
box on
hidden off
axis(axis_pos );
colormap(ax1,winter);
xlabel('X')
ylabel('Y')
zlabel('Z')
set(gca,'fontname','Times');
ax2 = axes;
% set(ax2,'position',fig_pos);
for i = 1: length_p
    r=r_p;
    x0=env.privacy_list(i,1);
    y0=env.privacy_list(i,2);
    z0=env.privacy_list(i,3);
    [x,y,z]=sphere;
    mesh(ax2,x0+r*x,y0+r*y,z0+r*z)    
    hold on
end

box off
axis off
hidden off
axis(axis_pos );
colormap(ax2,autumn);
set(gca,'fontname','Times');

% set colorbar --------------------------------
% cb1 = colorbar(ax1,'Position',[.65	.15 .05 .6]);
% cb2 = colorbar(ax2,'Position',[.74	.15 .05 .6]);

% set fontsize --------------------------------
% mm_fz = 12;
% set(ax1,'fontsize',mm_fz)
% set(ax2,'fontsize',mm_fz)
% axis([0, configure.grid_x, 0, configure.grid_y, 0, configure.grid_z])
% grid on


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
