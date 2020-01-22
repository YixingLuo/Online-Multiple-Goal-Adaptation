clear all
clc
clf

%% outline
% plot tensor with value in one figure.

%% main

% point number --------------------------------
n=400;
% generate x,y,z  -----------------------------
z = linspace(0,4*pi,n)+rand(1,n)*0.2;
x = 2*cos(z) + [1:n]/50.*rand(1,n);
y = 2*sin(z) + [1:n]/80.*rand(1,n);

% point properties v1,v2,...,v8  --------------
v1 = (10*abs(z)+10).*rand(size(z));
v2 = z + 4	;
v3 = sin(z/2*0.2*pi)+2;
v4 = log(z+2);
v5 = cos((pi*0.1*y).^0.5) +2	;
v6 = y+2;
v7 = sin(pi*log(z+1))+2;
v8 = cos(pi*log(z+1))+2;

% plot parameter -------------------------------
xmin= -10;xmax = 15;
ymin= -10;ymax = 15;
zmin=	0;zmax = 15;

% view point ----------------------------------
vx = -50; vy = 20;

% fontsize ------------------------------------
mm_fz = 12;

% set fig size --------------------------------
fig_pos = [0.09 0.15 0.53 0.75];
axis_pos= [xmin xmax ymin ymax zmin zmax];

% plot 3D points ------------------------------
h=figure(1);
set(h, 'Position', [100, 100, 800, 500]);

% plot zeros plane ------------------------------
ax1 = axes;
set(ax1,'position',fig_pos );
h_1 = scatter3(ax1,x,y,zeros(size(x)),3*v3,v4,'o','filled');
box on
hidden off
axis(axis_pos );
view([vx,vy])
colormap(ax1,summer);
xlabel('IamX')
ylabel('IamY')
zlabel('IamZ')
title('IamTitle')


% plot x plane ------------------------------
ax2 = axes;
set(ax2,'position',fig_pos);
h_2 = scatter3(ax2,xmax*ones(size(x)),y,z,7*v5,v6,'s','filled');
box off
axis off
hidden off
axis(axis_pos );
view([vx,vy])
colormap(ax2,'pink');


% plot y plane ------------------------------
ax3 = axes;
set(ax3,'position',fig_pos);
h_3 = scatter3(ax3,x,ymax*ones(size(y)),z,8*v7,v8,'^','filled');
box off
axis off
hidden off
axis(axis_pos );
view([vx,vy])
colormap(ax3,'cool');

% plot xyz  ------------------------------
ax4 = axes;
set(ax4,'position',fig_pos);
h_4 = scatter3(ax4,x,y,z,1.1*v1,v2,'o','filled');
% box off
axis off
hidden off
axis(axis_pos );
view([vx,vy])
colormap(ax4,'jet');

% set colorbar --------------------------------
cb1 = colorbar(ax1,'Position',[.65	.15 .05 .6]);
cb2 = colorbar(ax2,'Position',[.74	.15 .05 .6]);
cb3 = colorbar(ax3,'Position',[.83	.15 .05 .6]);
cb3 = colorbar(ax4,'Position',[.92	.15 .05 .6]);

% set fontsize --------------------------------
set(ax1,'fontsize',mm_fz)
set(ax2,'fontsize',mm_fz)
set(ax3,'fontsize',mm_fz)
set(ax4,'fontsize',mm_fz)
