
% time = planning_time;
% a = mean(time);
% c = std(time);
% now_time = [];
% num = find(time>(a+3*c)|time<(a-3*c));
% for i = 1:length(time)
%     if find(num==i)
%         continue
%     else
%         now_time= [now_time;time(i)];
%     end
% end
% a = mean(now_time);
% c = std(now_time);
% [counts,centers] = hist(now_time(:,1),3);
% figure,
% bar(centers, counts / sum(counts),'FaceColor',[0 .5 .5],'LineWidth',1)
% axis([0, 1, 0, 1])


%% plot with time
k = 0.5:0.5:length(planning_time)/2;
figure, 
plot(k, planning_time, 'r-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])