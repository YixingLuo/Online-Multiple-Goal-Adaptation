% x1 = [data1_1(:,1),data3_1(:,1)];
% x2 = [data1_1(:,2),data3_1(:,2)];
% x3 = [data1_1(:,3),data3_1(:,3)];
% x4 = [data1_1(:,4),data3_1(:,4)];
% x5 = [data1_1(:,5),data3_1(:,5)];
% x6 = [data1_1(:,6),data3_1(:,6)];
x1 = [data1_1(:,1),data2_1(:,1),data3_1(:,1)];
x2 = [data1_1(:,2),data2_1(:,2),data3_1(:,2)];
x3 = [data1_1(:,3),data2_1(:,3),data3_1(:,3)];
x4 = [data1_1(:,4),data2_1(:,4),data3_1(:,4)];
x5 = [data1_1(:,5),data2_1(:,5),data3_1(:,5)];
x6 = [data1_1(:,6),data2_1(:,6),data3_1(:,6)];

f=figure(1),
x = [x1;x2;x3;x4;x5;x6]; x = x(:);
g1 = [ones(size(x1)); 2*ones(size(x2)); 3*ones(size(x3));4*ones(size(x4));...
    5*ones(size(x5));6*ones(size(x6));]; g1 = g1(:);
% g2 = repmat(1:3,240,1); g2 = g2(:);
g2 = repmat(1:3,240,1); g2 = g2(:);
% g3 = repmat(2:3,300,1); g3 = g3(:);
% positions = [[1:6],[7:12]];
positions = [[1:6],[7:12],[13:18]];
bh=boxplot(x, {g2,g1},'notch','on','whisker',1,'colorgroup',g1, 'factorgap',[8 1],'symbol','.','outliersize',4,'widths',0.6,'positions',positions);
xlabel('Incident Probability [%]','Fontname', 'Times New Roman');
ylabel('Energy Consumption [MJ]','Fontname', 'Times New Roman');
grid on
set(gca,'YLim',[3,6],'gridLineStyle', '-.');
% 'YLim',[4,6],
set(bh,'linewidth',1.2);
set(gca,'fontname','Times');
color = ['c', 'y', 'g', 'b','o', 'b','c', 'y', 'g', 'b','o', 'b'];
h = findobj(gca,'Tag','Box');
mk=findobj(gca,'tag','Outliers'); % Get handles for outlier lines.
set(mk,'Marker','o'); % Change symbols for all the groups.
 for j=1:length(h)/2
    patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*j);
 end
  for j=(length(h)/2+1):length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(4),'FaceAlpha',0.01*(j-length(h)/2));
 end
hLegend = legend(findall(gca,'Tag','Box'), {'5.0%','4.2%','3.3%','2.5%','1.7%','0.8%'});
set(gca,'xtick',[8,16.5])
% set(gca,'xtick',[10])
% set(gca,'xtick',[]);
set(gca,'XTickLabel',{' '})
% legend('0.8','1.7','2.5','3.3','4.2','5.0')

annotation(f,'textbox',...
    [0.22 0.075 0.035 0.075],...
    'String','GMopt',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

annotation(f,'textbox',...
    [0.47 0.075 0.035 0.075],...
    'String','GRelax',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');

annotation(f,'textbox',...
    [0.73 0.075 0.035 0.075],...
    'String','GAdapt',...
    'FitBoxToText','off',...
    'Fontname', 'Times New Roman',...
    'EdgeColor','none');
