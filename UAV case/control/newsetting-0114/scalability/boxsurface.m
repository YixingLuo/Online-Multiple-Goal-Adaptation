
function boxsurface(p0,l,colorflag)
[x,y,z]=planarsurface(p0,p0+[0 0 l(3)],p0+[0 l(2) 0]);
surf(x,y,z)
hold on
[x,y,z]=planarsurface(p0+[l(1) 0 0],p0+[l(1) 0 l(3)],p0+[l(1) l(2) 0]);
surf(x,y,z)
[x,y,z]=planarsurface(p0,p0+[0 0 l(3)],p0+[l(1) 0 0]);
surf(x,y,z)
[x,y,z]=planarsurface(p0+[0 l(2) 0],p0+[0 l(2) l(3)],p0+[l(1) l(2) 0]);
surf(x,y,z)
[x,y,z]=planarsurface(p0,p0+[l(1) 0 0],p0+[0 l(2) 0]);
surf(x,y,z)
[x,y,z]=planarsurface(p0+[0 0 l(3)],p0+[l(1) 0 l(3)],p0+[0 l(2) l(3)]);
surf(x,y,z)
% if colorflag == 1
%     colormap([1 0 0;1 0 0])
% else
%     colormap([0 1 1;0 1 1])
% end
colorbar
% axis equal
% axis off


function [xx,yy,zz,l]=planarsurface(p0,p1,p2)
v=p1-p0;
w=p2-p0;
s=0:1:1;
l=length(s);
[s,t]=meshgrid(s,s);
xx=p0(1)+s*v(1)+t*w(1);
yy=p0(2)+s*v(2)+t*w(2);
zz=p0(3)+s*v(3)+t*w(3);