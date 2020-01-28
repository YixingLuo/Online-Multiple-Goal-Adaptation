k = [0.99, 1.99, 2.98, 3.98, 4.97];

figure,
subplot(2,2,1)
% figure, 

xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,1),xx,'PCHIP');
yi = smooth(SR(:,1)) ;
% h1 = plot(k,SR(:,1), '-^','linewidth',1.2,'MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,1),'-^','linewidth',1.2,'Color',[0.86667, 0.62745, 0.86667],'MarkerFaceColor',[0.86667, 0.62745, 0.86667],'MarkerEdgeColor',[0.86667, 0.62745, 0.86667])
hold on

xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,2),xx,'PCHIP');
% h2 =plot(k,SR(:,2),'linewidth',1.2,':s','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,2),':s','linewidth',2,'Color',[0.8549,0.43922, 0.83922],'MarkerFaceColor',[0.8549,0.43922, 0.83922],'MarkerEdgeColor',[0.8549,0.43922, 0.83922])
hold on

% plot(k, relax_for_52(:,3), '-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,3),xx,'PCHIP');
% h3 = plot(k,SR(:,3),'linewidth',1.2, '--d','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
% hold on
plot(k,SR(:,3),'--d','linewidth',1.2,'Color',[0.6, 0.19608, 0.8],'MarkerFaceColor',[0.6, 0.19608, 0.8],'MarkerEdgeColor',[0.6, 0.19608, 0.8])
hold on
axis([0, 6, 0, 2])
hlegend = legend('MOpt','GRelax','GAdapt','location','northwest');
h = xlabel({'\rho_o[%]'},'Fontname', 'Times New Roman');
ylabel('Accumulated Safety Risk','Fontname', 'Times New Roman');
set(hlegend,'box','off')
grid on
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)-xlim(1))*0.13,ylim(1)])
title('$(a) \quad \rho_c = 2.01\%$','Interpreter', 'latex');

subplot(2,2,2)
% figure, 

plot(k,PR(:,1),'-^','linewidth',1.2,'Color',[1,0.62745, 0.47843],'MarkerFaceColor',[1,0.62745, 0.47843],'MarkerEdgeColor',[1,0.62745, 0.47843])
hold on

plot(k,PR(:,2),':s','linewidth',2,'Color',[1,0.64706, 0],'MarkerFaceColor',[1,0.64706, 0],'MarkerEdgeColor',[1,0.64706, 0])
hold on

plot(k,PR(:,3),'--d','linewidth',1.2,'Color',[1, 0.49804, 0.31373],'MarkerFaceColor',[1, 0.49804, 0.31373],'MarkerEdgeColor',[1, 0.49804, 0.31373])
hold on

hlegend = legend('MOpt','GRelax','GAdapt','location','northwest');
h = xlabel({'\rho_o[%]'},'Fontname', 'Times New Roman');
ylabel('Accumulated Privacy Risk','Fontname', 'Times New Roman');
set(hlegend,'box','off')
grid on
axis([0, 6, 0, 2])
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.13,ylim(1)])
title('$(b) \quad \rho_c = 2.01\%$','Interpreter', 'latex');

%% WITH SET OBSTACLE
k2 = [1, 2.01,3.02,4.02,5.03];
subplot(2,2,3)

xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,1),xx,'PCHIP');
yi = smooth(SR2(:,1)) ;
plot(k2,SR2(:,1),'-^','linewidth',1.2,'Color',[0.86667, 0.62745, 0.86667],'MarkerFaceColor',[0.86667, 0.62745, 0.86667],'MarkerEdgeColor',[0.86667, 0.62745, 0.86667])
hold on

xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,2),xx,'PCHIP');
plot(k2,SR2(:,2),':s','linewidth',2,'Color',[0.8549,0.43922, 0.83922],'MarkerFaceColor',[0.8549,0.43922, 0.83922],'MarkerEdgeColor',[0.8549,0.43922, 0.83922])
hold on

xx=linspace(k2(end),k2(1));
yy=interp1(k2,SR2(:,3),xx,'PCHIP');
plot(k2,SR2(:,3),'--d','linewidth',1.2,'Color',[0.6, 0.19608, 0.8],'MarkerFaceColor',[0.6, 0.19608, 0.8],'MarkerEdgeColor',[0.6, 0.19608, 0.8])
hold on
axis([0, 6, 0, 2])
hlegend = legend('MOpt','GRelax','GAdapt','location','northwest');
h = xlabel({'\rho_c[%]'},'Fontname', 'Times New Roman');
ylabel('Accumulated Safety Risk','Fontname', 'Times New Roman');
set(hlegend,'box','off')
grid on
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)-xlim(1))*0.13,ylim(1)])
title('$(c) \quad \rho_o = 0.99\%$','Interpreter', 'latex');

subplot(2,2,4)

plot(k2,PR2(:,1),'-^','linewidth',1.2,'Color',[1,0.62745, 0.47843],'MarkerFaceColor',[1,0.62745, 0.47843],'MarkerEdgeColor',[1,0.62745, 0.47843])
hold on

plot(k2,PR2(:,2),':s','linewidth',2,'Color',[1,0.64706, 0],'MarkerFaceColor',[1,0.64706, 0],'MarkerEdgeColor',[1,0.64706, 0])
hold on

plot(k2,PR2(:,3),'--d','linewidth',1.2,'Color',[1, 0.49804, 0.31373],'MarkerFaceColor',[1, 0.49804, 0.31373],'MarkerEdgeColor',[1, 0.49804, 0.31373])
hold on

hlegend = legend('MOpt','GRelax','GAdapt','location','northwest');

h = xlabel({'\rho_c[%]'},'Fontname', 'Times New Roman');
ylabel('Accumulated Privacy Risk','Fontname', 'Times New Roman');
set(hlegend,'box','off')
grid on
axis([0, 6, 0, 2])
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
set(h,'Position',[xlim(2)+(xlim(2)+xlim(1))*0.13,ylim(1)])
title('$(d) \quad \rho_o = 0.99\%$','Interpreter', 'latex');