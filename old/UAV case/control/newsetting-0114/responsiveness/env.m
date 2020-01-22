% [X,Y,Z] = sphere(16);
% x = [0.5*X(:); 0.75*X(:); X(:)];
% y = [0.5*Y(:); 0.75*Y(:); Y(:)];
% z = [0.5*Z(:); 0.75*Z(:); Z(:)];
% S = repmat([1,1,1],numel(X),1);
% C = repmat([1,2,3],numel(X),1);
% s = S(:);
% c = C(:);
% figure,
% h = scatter3(x,y,z,s,c);

xo = [];
yp = [];
PR=[];
for i = 0.1:0.2:0.9 
    for j = 1:14
        xo = [xo;i];
        yp = [yp;1-i];
    end
end
xo = [xo;xo;xo];
yp = [yp;yp;yp];
for i = 1:5
    for j = 1:14
        PR = [PR;PR_normal(j,i)];
    end
end

for i = 1:5
    for j = 1:14
        PR = [PR;PR_relax(j,i)];
    end
end

for i = 1:5
    for j = 1:14
        PR = [PR;PR_relaxation(j,i)];
    end
end

S = repmat([70,50,20],14*5,1);
C = repmat([1,2,3],14*5,1);
s = S(:);
c = C(:);
figure,
h = scatter3(xo,yp,PR,s,c);