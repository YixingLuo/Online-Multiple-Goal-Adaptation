D_c = 4.5;

% pr1 = 0;
% for i= 1:size(trajectory,1)
%     for j = 1:size(privacy,1)
%         dis = (trajectory(i,1)- privacy(j,1)).^2+(trajectory(i,2)- privacy(j,2)).^2+(trajectory(i,3)- privacy(j,3)).^2;
%         pr1 = pr1 + max(0,1-sqrt(dis)/D_c);
%     end
% end
% 
% pr2 = 0;
% for i= 1:size(trajectory2,1)
%     for j = 1:size(privacy,1)
%         dis = (trajectory2(i,1)- privacy(j,1)).^2+(trajectory2(i,2)- privacy(j,2)).^2+(trajectory2(i,3)- privacy(j,3)).^2;
%         pr2 = pr2 + max(0,1-sqrt(dis)/D_c);
%     end
% end
% 
% pr3 = 0;
% for i= 1:size(trajectory3,1)
%     for j = 1:size(privacy,1)
%         dis = (trajectory3(i,1)- privacy(j,1)).^2+(trajectory3(i,2)- privacy(j,2)).^2+(trajectory3(i,3)- privacy(j,3)).^2;
%         pr3 = pr3 + max(0,1-sqrt(dis)/D_c);
%     end
% end



length_p = 2;
T = 48;

P_list=[];
num_p = 0;
for i = 2:size(trajectory,1)   
    current_point = trajectory(i,:);  
    PR = 0;
    if length_p > 0
        for j = 1: length_p
            dis_p(1,j) = sqrt((current_point(1) - privacy(j,1)).^2 + (current_point(2) - privacy(j,2)).^2 + (current_point(3) - privacy(j,3)).^2);
        end
    end
    for j = 1: length_p
        disk_risk = max(0,((D_c +0.5 +0.2) - dis_p(1, j))/D_c);       
        omega = current_point(4);
        if omega == 2
            omega = 1/3;
        end
        if disk_risk > 0
            privacy_risk = disk_risk*omega;
            num_p = num_p + 1;
            i;
        else
            privacy_risk = 0;
        end
        PR = PR + privacy_risk;
    end
    DS_P = 1 - PR/2;
    P_list = [P_list; DS_P];
end

mean(P_list), 1-(24-24)/(T -24), num_p

P_list=[];
num_p = 0;
for i = 2:size(trajectory2,1)   
    current_point = trajectory2(i,:);  
    PR = 0;
    if length_p > 0
        for j = 1: length_p
            dis_p(1,j) = sqrt((current_point(1) - privacy(j,1)).^2 + (current_point(2) - privacy(j,2)).^2 + (current_point(3) - privacy(j,3)).^2);
        end
    end
    for j = 1: length_p
        disk_risk = max(0,(( D_c  +0.5 +0.2) - dis_p(1, j))/D_c);       
        omega = current_point(4);
        if omega == 2
            omega = 1/3;
        end
        if disk_risk > 0
            privacy_risk = disk_risk*omega;
            num_p = num_p + 1;
            i;
        else
            privacy_risk = 0;
        end
        PR = PR + privacy_risk;
    end
    DS_P = 1 - PR/2;
    P_list = [P_list; DS_P];
end

mean(P_list), 1-(26-24)/(T -24), num_p 

P_list=[];
num_p = 0;
for i = 2:size(trajectory3,1)   
    current_point = trajectory3(i,:);  
    PR = 0;
    if length_p > 0
        for j = 1: length_p
            dis_p(1,j) = sqrt((current_point(1) - privacy(j,1)).^2 + (current_point(2) - privacy(j,2)).^2 + (current_point(3) - privacy(j,3)).^2);
        end
    end
    for j = 1: length_p
        disk_risk = max(0,((D_c +0.5 +0.2) - dis_p(1, j))/D_c);       
        omega = current_point(4);
        if omega == 2
            omega = 1/3;
        end
        if disk_risk > 0
            privacy_risk = disk_risk*omega;
            num_p = num_p + 1;
            i;
        else
            privacy_risk = 0;
        end
        PR = PR + privacy_risk;
    end
    DS_P = 1 - PR/2;
    P_list = [P_list; DS_P];
end

mean(P_list), 1-(28-24)/(T - 24), num_p
