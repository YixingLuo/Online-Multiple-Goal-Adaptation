k = [0.99, 1.99, 2.98, 3.98, 4.97];
% k=[1,2,3,4,5];

figure(1)
% figure, 

yyaxis left
xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,1),xx,'PCHIP');
% yi = smooth(SR(:,1)) ;
% h1 = plot(k,SR(:,1), '-^','linewidth',1.2,'MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,1),':*','MarkerSize',8,'linewidth',4,'Color',[0.52941 0.80784 0.98],'MarkerFaceColor',[0.52941 0.80784 0.98],'MarkerEdgeColor',[0.52941 0.80784 0.98])
hold on

xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,2),xx,'PCHIP');
% h2 =plot(k,SR(:,2),'linewidth',1.2,':s','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,2),'--*','MarkerSize',8,'linewidth',4,'Color',[0 0.74 1],'MarkerFaceColor',[0 0.74 1],'MarkerEdgeColor',[0 0.74 1])
hold on

% plot(k, relax_for_52(:,3), '-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,3),xx,'PCHIP');
% h3 = plot(k,SR(:,3),'linewidth',1.2, '--d','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,3),'-*','MarkerSize',8,'linewidth',4,'Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',[0 0.4470 0.7410])
hold on
axis([0, 6, -2, 4])
% hlegend = legend('AMOCS-MA','GSlack','Captain','location','northwest');
h = xlabel({'\rho_o[%]'},'Fontname', 'Times New Roman');
% set(hlegend,'box','off')
grid on
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times','FontSize',20);
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)-xlim(1))*0.1,ylim(1)])
% title('$(a) \quad \rho_c = 2\%$','Interpreter', 'latex','position',[3,-3],'FontSize',18);
ylabel({'Accumulated Safety Risk (SR)'},'Fontname', 'Times New Roman','FontSize',22);

yyaxis right

plot(k,PR(:,1),':*','MarkerSize',8,'linewidth',4,'Color',[1,0.62745, 0.47843],'MarkerFaceColor',[1,0.62745, 0.47843],'MarkerEdgeColor',[1,0.62745, 0.47843])
hold on

plot(k,PR(:,2),'--*','MarkerSize',8,'linewidth',4,'Color',[1,0.64706, 0],'MarkerFaceColor',[1,0.64706, 0],'MarkerEdgeColor',[1,0.64706, 0])
hold on

plot(k,PR(:,3),'-*','MarkerSize',8,'linewidth',4,'Color',[1, 0.388, 0.278],'MarkerFaceColor',[1, 0.388, 0.278],'MarkerEdgeColor',[1, 0.388, 0.278])
hold on

% hlegend = legend('AMOCS-MA','GSlack','Captain','location','northwest');
h = xlabel({'\rho_o[%]'},'Fontname', 'Times New Roman');
ylabel({'Accumulated Privacy Risk (PR)'},'Fontname', 'Times New Roman','FontSize',22);
% set(hlegend,'box','off')
grid on
axis([0, 6, 0, 4])
set(gca,'ytick',0:1:4);
hlegend = legend('AMOCS-MA(SR)','GSlack(SR)','Captain(SR)','AMOCS-MA(PR)','GSlack(PR)','Captain(PR)','location','northwest');
set(hlegend,'box','off')

% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% xlim = get(gca,'XLim');
% ylim = get(gca,'YLim');
% set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.13,ylim(1)])
% title('$(b) \quad \rho_c = 2.01\%$','Interpreter', 'latex');

%% WITH SET OBSTACLE
k2 = [1, 2.01,3.02,4.02,5.03];
% k2 = [1,2,3,4,5];
figure(2)

yyaxis left
xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,1),xx,'PCHIP');
% yi = smooth(SR2(:,1)) ;
plot(k2,SR2(:,1),':*','MarkerSize',8,'linewidth',4,'Color',[0.52941 0.80784 0.98],'MarkerFaceColor',[0.52941 0.80784 0.98],'MarkerEdgeColor',[0.52941 0.80784 0.98])
hold on

xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,2),xx,'PCHIP');
plot(k2,SR2(:,2),'--*','MarkerSize',8,'linewidth',4,'Color',[0 0.74 1],'MarkerFaceColor',[0 0.74 1],'MarkerEdgeColor',[0 0.74 1])
hold on

xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,3),xx,'PCHIP');
plot(k2,SR2(:,3),'-*','MarkerSize',8,'linewidth',4,'Color',[0 0.4470 0.7410],'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',[0 0.4470 0.7410])
hold on
axis([0, 6, 0, 4])

h = xlabel({'\rho_c[%]'},'Fontname', 'Times New Roman');

grid on
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times','FontSize',20);
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)-xlim(1))*0.1,ylim(1)])
% title('$(b) \quad \rho_o = 2\%$','Interpreter', 'latex','position',[3,-0.7],'FontSize',18);
ylabel({'Accumulated Safety Risk (SR)'},'Fontname', 'Times New Roman','FontSize',22);
set(gca,'ytick',0:1:4);

yyaxis right
plot(k2,PR2(:,1),':*','MarkerSize',8,'linewidth',4,'Color',[1,0.62745, 0.47843],'MarkerFaceColor',[1,0.62745, 0.47843],'MarkerEdgeColor',[1,0.62745, 0.47843])
hold on

plot(k2,PR2(:,2),'--*','MarkerSize',8,'linewidth',4,'Color',[1,0.64706, 0],'MarkerFaceColor',[1,0.64706, 0],'MarkerEdgeColor',[1,0.64706, 0])
hold on

plot(k2,PR2(:,3),'-*','MarkerSize',8,'linewidth',4,'Color',[1, 0.388, 0.278],'MarkerFaceColor',[1, 0.388, 0.278],'MarkerEdgeColor',[1, 0.388, 0.278])
hold on

hlegend = legend('AMOCS-MA','GSlack','Captain','location','northwest');

h = xlabel({'\rho_c[%]'},'Fontname', 'Times New Roman');
ylabel({'Accumulated Privacy Risk (PR)'},'Fontname', 'Times New Roman','FontSize',24);
set(hlegend,'box','off')
grid on
axis([0, 6, -2, 4])

hlegend = legend('AMOCS-MA(SR)','GSlack(SR)','Captain(SR)','AMOCS-MA(PR)','GSlack(PR)','Captain(PR)','location','northwest');
set(hlegend,'box','off')
% set(gca,'gridLineStyle', '-.');
% set(gca,'fontname','Times');
% xlim = get(gca,'XLim');
% ylim = get(gca,'YLim');
% set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.13,ylim(1)])
% title('$(d) \quad \rho_o = 1.99\%$','Interpreter', 'latex');

std(SR,0,1)
std(PR,0,1)
std(SR2,0,1)
std(PR2,0,1)

