% figure,
% hist(planning_time)
% h = findobj(gca,'Type','patch');
% h.FaceColor = [0 0.5 0.5];
% h.EdgeColor = 'w';
I=find(planning_time~=0);
planning_time1 = planning_time(I);
[counts,centers] = hist(planning_time1)
figure,
bar(centers, counts / sum(counts),'FaceColor',[0 .5 .5],'LineWidth',1)
axis([0, 3, 0, 1])
% figure_FontSize=8;
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','top');
% set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','top');
% set(findobj('FontSize',10),'FontSize',figure_FontSize);

% bar(y,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5)
mean(planning_time1)
std(planning_time1)