

data1_uuv = time1_uuv;
data2_uuv = time2_uuv;
data3_uuv = time3_uuv;



f=figure,


Pre = [data1_uuv',data2_uuv',data3_uuv'];
g1 = [ones(size(data1_uuv)); 2*ones(size(data2_uuv)); 3*ones(size(data3_uuv));];
g1 = g1(:);
% g2 = repmat(1:3,8977*6,1); 
g2 = [ones(size(data1_uuv)); 2*ones(size(data2_uuv)); 3*ones(size(data3_uuv));];
g2 = g2(:);

positions = [[1],[2],[3]];
bh = boxplot(Pre, {g1,g2},'notch','on','whisker',0.5,'Color',[0.8500 0.3250 0.0980;0.4660 0.6740 0.1880;0 0.4470 0.7410], 'factorgap',[8 1],'symbol','','outliersize',4,'widths',0.6,'positions',positions);
% xlabel('# of incidents','Fontname', 'Times New Roman');
ylabel('Overhead [s]','Fontname', 'Times New Roman','Fontsize',12);
grid on
% set(gca,'YLim',[0,0.8]);
set(gca,'gridLineStyle', '-.');
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
y=[0.0423,0.0423,0.0423,0.0423,0.0423,0.0423,0.0423];
plot(x,y, ':', 'Color',[0.6350 0.0780 0.1840],'linewidth',2)
x=1.85:0.1:2.45;
y=[0.0180,0.0180,0.0180,0.0180,0.0180,0.0180,0.0180];
plot(x,y, ':','Color',[0.6350 0.0780 0.1840],'linewidth',2)
x=3.02:0.1:3.62;
y=[0.0344,0.0344,0.0344,0.0344,0.0344,0.0344,0.0344];
plot(x,y,':','Color',[0.6350 0.0780 0.1840],'linewidth',2)
% hLegend = legend(findall(gca,'Tag','Box'),{'Captain','GSlack','AMOCS-MA','Average'},'Box','off','Location','NorthWest');
legend({'Average'},'Box','off','Location','NorthWest','Fontsize',12);
h = findobj(gca,'Tag','Median');
set(h,'Visible','on');
% set(gca,'FontSize',14)


annotation(f,'textbox',...
    [0.18 0.075 0.3 0.075],...
    'String',{'AMOCS-MA'},...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none','Fontsize',12);

annotation(f,'textbox',...
    [0.46 0.075 0.3 0.075],...
    'String','GSlack',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none','Fontsize',12);

annotation(f,'textbox',...
    [0.71 0.075 0.035 0.075],...
    'String','Captain',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
   'EdgeColor','none','Fontsize',12)

% B = imrotate(f,-90);