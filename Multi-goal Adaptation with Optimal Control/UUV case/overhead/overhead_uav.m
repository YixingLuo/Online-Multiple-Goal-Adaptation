%% overhead 1
time1_uav=[];
for i = 1:size(planningtime1,1)
    for j = 1:size(planningtime1,2)
        if planningtime1(i,j)>0
            time1_uav=[time1_uav;planningtime1(i,j)];
        end
    end
end

a1 = mean(time1_uav);
c1 = std(time1_uav);

now_time1 = [];
num1 = find(time1_uav>(a1+1*c1)|time1_uav<(a1-1*c1));
for i = 1:length(time1_uav)
    if find(num1==i)
        continue
    else
        now_time1= [now_time1;time1_uav(i)];
    end
end
a1 = mean(now_time1);
c1 = std(now_time1);

%% overhead 2
time2_uav=[];
for i = 1:size(planningtime2,1)
    for j = 1:size(planningtime2,2)
        if planningtime2(i,j)>0
            time2_uav=[time2_uav;planningtime2(i,j)];
        end
    end
end

a2 = mean(time2_uav);
c2 = std(time2_uav);

now_time2 = [];
num2 = find(time2_uav>(a2+1*c2)|time2_uav<(a2-1*c2));
for i = 1:length(time2_uav)
    if find(num2==i)
        continue
    else
        now_time2= [now_time2;time2_uav(i)];
    end
end
a2 = mean(now_time2);
c2 = std(now_time2);

%% overhead 3
time3_uav=[];
for i = 1:size(planningtime3,1)
    for j = 1:size(planningtime3,2)
        if planningtime3(i,j)>0
            time3_uav=[time3_uav;planningtime3(i,j)];
        end
    end
end

a3 = mean(time3_uav);
c3 = std(time3_uav);

now_time3 = [];
num3 = find(time3_uav>(a3+1*c3)|time3_uav<(a3-1*c3));
for i = 1:length(time3_uav)
    if find(num3==i)
        continue
    else
        now_time3= [now_time3;time3_uav(i)];
    end
end
a3 = mean(now_time3);
c3 = std(now_time3);
% [counts,centers] = hist(now_time3,5);
% figure,
% bar(centers, counts / sum(counts),'FaceColor',[0 .5 .5],'LineWidth',1)
% axis([0, 1, 0, 1])

statistic_time_data = [a1,c1;a2,c2;a3,c3]
