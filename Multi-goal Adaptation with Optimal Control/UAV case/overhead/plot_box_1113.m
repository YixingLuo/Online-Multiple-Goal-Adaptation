% for i = 1:6
%     data1_sorted(:,i) = sort(data1_1(:,i));
% end
% for i = 1:6
%     data2_sorted(:,i) = sort(data3_1(:,i));
% end
% for i = 1:6
%     data3_sorted(:,i) = sort(data3_1(:,i));
% end

% data1 = sort(now_time1);
% data2 = sort(now_time2);
% data3 = sort(now_time3);

% data1_uuv = time1_uuv;
% data2_uuv = time2_uuv;
% data3_uuv = time3_uuv;

data1_uav = time1_uav;
data3_uav = time3_uav;


% x1 = [data1_uuv,data1_uav];
% x2 = [data2_uuv,data2_uav];
% x3 = [data3_uuv,data3_uav];


% figure,
% plot(ones(length(data1_uuv),1),data1_uuv,'bo')
% hold on
% plot(ones(length(data1_uav),1),data1_uav,'go')
% hold on
% plot(ones(length(data2_uuv),1),data2_uuv,'bo')
% hold on
% plot(ones(length(data2_uav),1),data2_uav,'go')
% hold on
% plot(ones(length(data3_uuv),1),data3_uuv,'bo')
% hold on
% plot(ones(length(data3_uav),1),data3_uav,'go')
% hold on
% boxplot(Pre,Pre_tmp,'symbol','');

% x3 = [data1,data2,data3];
% x4 = [data1,data2,data3];
% x5 = [data1,data2,data3];
% x6 = [data1,data2,data3];

f=figure,
% x = [x1;x2;x3;x4;x5;x6];
% x = [x1;x2];
% x = x(:);
% g1 = [ones(size(x1)); 2*ones(size(x2)); 3*ones(size(x3));4*ones(size(x4));...
%     5*ones(size(x5));6*ones(size(x6));];
% g1 = [ones(size(x1)); 2*ones(size(x2));];

Pre = [data1_uav',data3_uav'];
g1 = [ones(size(data1_uav)); 2*ones(size(data3_uav));];
g1 = g1(:);
% g2 = repmat(1:3,8977*6,1); 
g2 = [ones(size(data1_uav)); 2*ones(size(data3_uav));];
g2 = g2(:);

positions = [[1],[2]];
bh = boxplot(Pre, {g1,g2},'notch','on','whisker',0.5,'Color',[0.8500 0.3250 0.0980;0 0.4470 0.7410;0.4660 0.6740 0.1880], 'factorgap',[8 1],'symbol','','outliersize',4,'widths',0.6,'positions',positions);
% xlabel('# of incidents','Fontname', 'Times New Roman');
ylabel('Overhead [s]','Fontname', 'Times New Roman','Fontsize',12);
grid on
% set(gca,'YLim',[0,0.8]);
set(gca,'YLim',[0,0.6],'gridLineStyle', '-.');
set(bh,'linewidth',1.2);
set(gca,'fontname','Times');
color = ['c', 'y', 'b'];
h = findobj(gca,'Tag','Box');
mk=findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
% set(mk,'Marker','o'); % Change symbols for all the groups.
%  for j=1:length(h)/2
%     patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*j);
%  end
%   for j=(length(h)/2+1):length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*(j-length(h)/2));
%  end
% hLegend = legend(findall(gca,'Tag','Box'), {'AMOCS-MA','GSlack','Captain'});
% set(gca,'xtick',[8,16.5])
% set(gca,'xtick',[4.5])
% set(gca,'xtick',[]);
set(gca,'XTickLabel',{' '})
% legend('0.8','1.7','2.5','3.3','4.2','5.0')

h = findobj(gca,'Tag','Median');
set(h,'Visible','off');
hold on
% plot(1,0.0423,'Color',[0.6350 0.0780 0.1840],'Marker', '*')
% plot(2.4,0.0180,'Color',[0.6350 0.0780 0.1840],'Marker', '*')
% plot(3.8,0.0344,'Color',[0.6350 0.0780 0.1840],'Marker', '*')
x=0.7:0.1:1.3;
y=[0.2115,0.2115,0.2115,0.2115,0.2115,0.2115,0.2115];
plot(x,y, ':', 'Color',[0.6350 0.0780 0.1840],'linewidth',2)
x=1.78:0.1:2.38;
y=[0.0811,0.0811,0.0811,0.0811,0.0811,0.0811,0.0811];
plot(x,y, ':','Color',[0.6350 0.0780 0.1840],'linewidth',2)
% hLegend = legend(findall(gca,'Tag','Box'),{'Captain','GSlack','AMOCS-MA','Average'},'Box','off','Location','NorthWest');
legend({'Average'},'Box','off','Location','NorthWest','Fontsize',12);
h = findobj(gca,'Tag','Median');
set(h,'Visible','on');
% set(gca,'FontSize',14)


annotation(f,'textbox',...
    [0.245 0.075 0.3 0.075],...
    'String',{'AMOCS-MA'},...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none','Fontsize',12);

annotation(f,'textbox',...
    [0.65 0.075 0.035 0.075],...
    'String','Captain',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
   'EdgeColor','none','Fontsize',12)

% B = imrotate(f,-90);