% for i = 1:6
%     data1_sorted(:,i) = sort(data1_1(:,i));
% end
% for i = 1:6
%     data2_sorted(:,i) = sort(data3_1(:,i));
% end
% for i = 1:6
%     data3_sorted(:,i) = sort(data3_1(:,i));
% end

% data1 = data1_sorted(21:480,:);
% data2 = data2_sorted(21:480,:);
% data3 = data3_sorted(21:480,:);

x1 = [data1(:,1)/1e6,data2(:,1)/1e6,data3(:,1)/1e6];
x2 = [data1(:,2)/1e6,data2(:,2)/1e6,data3(:,2)/1e6];
x3 = [data1(:,3)/1e6,data2(:,3)/1e6,data3(:,3)/1e6];
x4 = [data1(:,4)/1e6,data2(:,4)/1e6,data3(:,4)/1e6];
x5 = [data1(:,5)/1e6,data2(:,5)/1e6,data3(:,5)/1e6];
% x6 = [data1(:,6)/1e6,data2(:,6)/1e6,data3(:,6)/1e6];

f=figure,
x = [x1;x2;x3;x4;x5]; x = x(:);

g1 = [ones(size(x1)); 2*ones(size(x2)); 3*ones(size(x3));4*ones(size(x4));...
    5*ones(size(x5));]; g1 = g1(:);
% g2 = repmat(1:3,240,1); g2 = g2(:);
g2 = repmat(1:3,1000*5,1); g2 = g2(:);
% g3 = repmat(2:3,300,1); g3 = g3(:);
% positions = [[1:6],[7:12]];
positions = [[1:5],[6:10],[11:15]];
bh=boxplot(x, {g2,g1},'notch','on','whisker',1,'colorgroup',g1, 'factorgap',[8 1],'symbol','','outliersize',4,'widths',0.6,'positions',positions);
xlabel('# of incidents','Fontname', 'Times New Roman');
ylabel('Energy Consumption [MJ]','Fontname', 'Times New Roman');
grid on
set(gca,'YLim',[4,6],'gridLineStyle', '-.');
set(bh,'linewidth',1.2);
set(gca,'fontname','Times');
color = ['c', 'y', 'g', 'b','o', 'b','c', 'y', 'g', 'b','o', 'b'];
mk=findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
% set(mk,'Marker','o'); % Change symbols for all the groups.
%  for j=1:length(h)/2
%     patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*j);
%  end
%   for j=(length(h)/2+1):length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*(j-length(h)/2));
%  end
hLegend = legend(findall(gca,'Tag','Box'), {'15','12','9','6','3'},'Location','SouthWest','Box','off');
h = findobj(gca,'Tag','Box');
set(gca,'xtick',[6.5,13.5])
% set(gca,'xtick',[10])
% set(gca,'xtick',[]);
set(gca,'XTickLabel',{' '})
% legend('0.8','1.7','2.5','3.3','4.2','5.0')

annotation(f,'textbox',...
    [0.18 0.075 0.035 0.075],...
    'String','AMOCS-MA',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

annotation(f,'textbox',...
    [0.47 0.075 0.035 0.075],...
    'String','GSlack',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

annotation(f,'textbox',...
    [0.73 0.075 0.035 0.075],...
    'String','Captain',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');
