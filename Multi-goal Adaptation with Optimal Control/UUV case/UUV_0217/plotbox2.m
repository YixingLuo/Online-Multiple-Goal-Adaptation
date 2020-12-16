

% x1 = [data1(:,1)/1000,data2(:,1)/1000,data3(:,1)/1000];
% x2 = [data1(:,2)/1000,data2(:,2)/1000,data3(:,2)/1000];
% x3 = [data1(:,3)/1000,data2(:,3)/1000,data3(:,3)/1000];
% x4 = [data1(:,4)/1000,data2(:,4)/1000,data3(:,4)/1000];
% x5 = [data1(:,5)/1000,data2(:,5)/1000,data3(:,5)/1000];

x1 = [data1(:,1)/1000,data3(:,1)/1000];
x2 = [data1(:,2)/1000,data3(:,2)/1000];
x3 = [data1(:,3)/1000,data3(:,3)/1000];
x4 = [data1(:,4)/1000,data3(:,4)/1000];
x5 = [data1(:,5)/1000,data3(:,5)/1000];

f=figure,
x = [x1;x2;x3;x4;x5]; x = x(:);

g1 = [ones(size(x1)); 2*ones(size(x2)); 3*ones(size(x3));4*ones(size(x4));...
    5*ones(size(x5));]; g1 = g1(:);
% g2 = repmat(1:3,1000*5,1); g2 = g2(:);
g2 = repmat(1:2,1000*5,1); g2 = g2(:);
% positions = [[1:5],[6:10],[11:15]];
positions = [[1:5],[6:10]];
bh=boxplot(x, {g2,g1},'notch','on','whisker',1,'colorgroup',g1, 'factorgap',[8 1],'symbol','','outliersize',4,'widths',0.6,'positions',positions);
xlabel('# of incidents','Fontname', 'Times New Roman');
ylabel('Scanning Distance [km]','Fontname', 'Times New Roman');
grid on
set(gca,'YLim',[80,120],'gridLineStyle', '-.');
set(bh,'linewidth',1.2);
set(gca,'fontname','Times');
color = ['c', 'y', 'g', 'b','o', 'b','c', 'y', 'g', 'b','o', 'b'];
mk=findobj(gca,'tag','Outliers'); % Get handles for outlier lines.

hLegend = legend(findall(gca,'Tag','Box'), {'15','12','9','6','3'},'Location','SouthWest','Box','off');
h = findobj(gca,'Tag','Box');
% set(gca,'xtick',[6.5,13.5])
set(gca,'xtick',[6.5])
set(gca,'XTickLabel',{' '})


annotation(f,'textbox',...
    [0.3 0.075 0.035 0.075],...
    'String','SCMP',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

annotation(f,'textbox',...
    [0.7 0.075 0.035 0.075],...
    'String','ACMP',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

% annotation(f,'textbox',...
%     [0.73 0.075 0.035 0.075],...
%     'String','ACMP',...
%     'FitBoxToText','off',...
%     'Fontname', 'Times New Roman',...
%     'EdgeColor','none');
