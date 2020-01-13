% cla
% load accidents hwydata                             % load data
% 
% long = -hwydata(:,2);                              % longitude data
% lat = hwydata(:,3);                                % latitude data
% rural = 100 - hwydata(:,17);                       % percent rural data
% fatalities = hwydata(:,11);                        % fatalities data

DS_A = data3(:,1);
pastaccuracy = data3(:,2)*100;
DS_D = data3(:,3);
pastdistance = data3(:,4);
DS_E = data3(:,5);
pastenergy = data3(:,6);

eplison = 0:0.01:1;
figure,
% scatter3(DS_A,DS_D,DS_E,40,eplison,'filled')    % draw the scatter plot
scatter3(pastaccuracy,pastdistance,pastenergy,40,eplison,'filled')    % draw the scatter plot
ax = gca;
ax.ZDir = 'reverse';
% view(-31,14)
xlabel('Accuracy [%]')
ylabel('Scanning Distance [km]')
zlabel('Energy Consumption [MJ]')

% figure,
cb = colorbar;                                     % create and label the colorbar
cb.Label.String = 'Error Tolerance';
set(gca,'gridLineStyle', '-.');
set(gca,'fontname','Times');
% xslice = [0 1];                               % define the cross sections to view
% yslice = 0.5;
% zslice = ([0 1]);
% slice(DS_A,DS_D,DS_E, eplison, xslice, yslice, zslice)    % display the slices
% ylim([-3 3])
% view(-34,24)

% cb = colorbar;                                  % create and label the colorbar
% cb.Label.String = 'Temperature, C';