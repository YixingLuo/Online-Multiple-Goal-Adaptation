%% overhead 1
time1=[];
for i = 2:size(planning_time1,1)
    for j = 1:size(planning_time1,2)
        if planning_time1(i,j)>0
            time1=[time1;planning_time1(i,j)];
        end
    end
end

a1 = mean(time1);
c1 = std(time1);

now_time1 = [];
num1 = find(time1>(a1+1*c1)|time1<(a1-1*c1));
for i = 1:length(time1)
    if find(num1==i)
        continue
    else
        now_time1= [now_time1;time1(i)];
    end
end
a1 = mean(now_time1);
c1 = std(now_time1);

%% overhead 2
time2=[];
for i = 2:size(planning_time2,1)
    for j = 1:size(planning_time2,2)
        if planning_time2(i,j)>0
            time2=[time2;planning_time2(i,j)];
        end
    end
end

a2 = mean(time2);
c2 = std(time2);

now_time2 = [];
num2 = find(time2>(a2+1*c2)|time2<(a2-1*c2));
for i = 1:length(time2)
    if find(num2==i)
        continue
    else
        now_time2= [now_time2;time2(i)];
    end
end
a2 = mean(now_time2);
c2 = std(now_time2);

%% overhead 3
time3=[];
for i = 2:size(planning_time3,1)
    for j = 1:size(planning_time3,2)
        if planning_time3(i,j)>0
            time3=[time3;planning_time3(i,j)];
        end
    end
end

a3 = mean(time3);
c3 = std(time3);

now_time3 = [];
num3 = find(time3>(a3+1*c3)|time3<(a3-1*c3));
for i = 1:length(time3)
    if find(num3==i)
        continue
    else
        now_time3= [now_time3;time3(i)];
    end
end
a3 = mean(now_time3);
c3 = std(now_time3);
% [counts,centers] = hist(now_time2,5);
% figure,
% bar(centers, counts / sum(counts),'FaceColor',[0 .5 .5],'LineWidth',1)
% axis([0, 1, 0, 1])

statistic_time_data = [a1,c1;a2,c2;a3,c3]



% time1=[];
% for i = 1:10
%     for j = 1:50
%         if planning_time1(i,j)>0
%             time1(i,j)=planning_time1(i,j);
%         end
%     end
% end
% 
% a1 = mean(time1,1);
% 
% time2=[];
% for i = 2:size(planning_time2,1)
%     for j = 1:size(planning_time2,2)
%         if planning_time2(i,j)>0
%             time2(i,j)=planning_time2(i,j);
%         end
%     end
% end
% 
% a2 = mean(time2,1);
% 
% time3=[];
% for i = 2:size(planning_time3,1)
%     for j = 1:size(planning_time3,2)
%         if planning_time3(i,j)>0
%             time3(i,j)=planning_time3(i,j);
%         end
%     end
% end
% 
% a3 = mean(time3,1);
% 
% for i = 1:50
%     if  a3(i) < a1(i)
%         i
%     end
% end



