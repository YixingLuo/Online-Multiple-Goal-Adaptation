D_c = 4.5;
pr1 = 0;
for i= 2:size(trajectory,1)
    for j = 1:size(privacy,1)
        dis = (trajectory(i,1)- privacy(j,1)).^2+(trajectory(i,2)- privacy(j,2)).^2+(trajectory(i,3)- privacy(j,3)).^2;
        pr1 = pr1 + max(0,1-sqrt(dis)/D_c);
    end
end

pr2 = 0;
for i= 2:size(trajectory2,1)
    for j = 1:size(privacy,1)
        dis = (trajectory2(i,1)- privacy(j,1)).^2+(trajectory2(i,2)- privacy(j,2)).^2+(trajectory2(i,3)- privacy(j,3)).^2;
        pr2 = pr2 + max(0,1-sqrt(dis)/D_c);
    end
end

pr3 = 0;
for i= 2:size(trajectory3,1)
    for j = 1:size(privacy,1)
        dis = (trajectory3(i,1)- privacy(j,1)).^2+(trajectory3(i,2)- privacy(j,2)).^2+(trajectory3(i,3)- privacy(j,3)).^2;
        pr3 = pr3 + max(0,1-sqrt(dis)/D_c);
    end
end
pr1,pr2,pr2*120/180,pr3