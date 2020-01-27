%% overhead 1
time1=[];
for i = 1:size(planning_time,1)
    for j = 1:size(planning_time,2)
        if planning_time(i,j)>0
            time1=[time1;planning_time(i,j)];
        end
    end
end

a1 = mean(time1)
c1 = std(time1)

now_time1 = [];
num1 = find(time1>(a1+c1)|time1<(a1-c1));
for i = 1:length(time1)
    if find(num1==i)
        continue
    else
        now_time1= [now_time1;time1(i)];
    end
end
a1 = mean(now_time1)
c1 = std(now_time1)

