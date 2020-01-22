k = 0.1:0.2:0.9;
figure, 

xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,1),xx,'PCHIP');
yi = smooth(SR(:,1)) ;
h1 = plot(k,yi, '-^','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
hold on
plot(xx,yy,'-','linewidth',1.2,'Color',[0.4940 0.1840 0.5560])
hold on

xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,2),xx,'PCHIP');
h2 =plot(k,SR(:,2), ':s','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
hold on
plot(xx,yy,':','linewidth',1.2,'Color',[0.4940 0.1840 0.5560])
hold on

% plot(k, relax_for_52(:,3), '-','linewidth',1.2,'Color',[0.8500 0.3250 0.0980])
xx=linspace(k(end),k(1));
yy=interp1(k,SR(:,3),xx,'PCHIP');
h3 = plot(k,SR(:,3), '--d','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
hold on
plot(xx,yy,'--','linewidth',1.2,'Color',[0.4940 0.1840 0.5560])
hold on
hlegend = legend([h1,h2,h3],'MOpt','GRelax','GAdapt');
h = xlabel({'\rho_o'},'Fontname', 'Times New Roman');
ylabel('Safety Risk','Fontname', 'Times New Roman');
set(hlegend,'box','off')
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');