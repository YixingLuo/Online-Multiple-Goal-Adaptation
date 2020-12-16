function [ h_fig ] = plot_state( h_fig, state, time, name, type, view )
%PLOT_STATE visualize state data

if nargin < 6, view = 'sep'; end
if nargin < 5, type = 'vic'; end
if nargin < 4, name = 'pos'; end
if isempty(h_fig), h_fig = figure(); end
line_width = 2;

switch type
    case 'vic'
%         line_color = 'r';
        line_color = [0.8500 0.3250 0.0980];
    case 'des'
%         line_color = 'b';
        line_color = [0 0.4470 0.7410];
    case 'est'
        line_color = 'g';
end

switch name
    case 'pos'
        labels = {'x [m]', 'y [m]', 'z [m]', '\omega [%]'};
    case 'vel'
        labels = {'$v_x$ [10m/s]', '$v_y$ [10m/s]', '$v_z$ [10m/s]', '\omega [%]'};
    case 'euler'
        labels = {'roll [rad]', 'pitch [rad]', 'yaw [rad]'};
end

figure(h_fig)
if strcmp(view, 'sep')
    % Plot seperate
switch name
    case 'pos'
        for i = 1:4
            subplot(4, 1, i)
            hold on
            plot(time, state(i,:),'color', line_color, 'LineWidth', line_width);
            hold off
            xlim([time(1), time(end)])
            grid on
            if i == 4
                xlabel('Time instant $k$ [s]','Interpreter','latex')
            end
            ylabel(labels{i})
            set(gca,'fontname','Times','fontsize',12);
%             set(gca,'xtick',0:1:12);
    %         axis([0, 25, 0, 10]);
        end
    case 'vel'
        for i = 1:4
            subplot(4, 1, i)
            hold on
            plot(time, state(i,:),'color', line_color, 'LineWidth', line_width);
            hold off
            xlim([time(1), time(end)])
            grid on
            set(gca,'fontname','Times');
            if i == 4
                xlabel('Time instant $k$ [s]','Interpreter','latex')
%                 axis([0, 60.5, 0, 100]);
                axis([0, 102, 0, 100]);
            end
            if i < 4
                ylabel(labels{i},'Interpreter','latex')
%                 lgd = legend('PD controller output','Captain output','Box','off','location','southwest','FontSize',10);
            else
                ylabel(labels{i})
%                 lgd = legend('PD controller output','Captain output','Box','off','location','southwest','FontSize',10);
            end    
%             if i == 1
%                 lgd = legend('PD controller output','Captain output','Box','off','location','southwest','FontSize',12);
%             end
%             set(gca,'xtick',0:1:12);
%             lgd = legend('PD controller output','Captain output','Box','off','location','southwest','FontSize',10);
            set(gca,'fontname','Times','fontsize',12);
        end
end
elseif strcmp(view, '3d')
    % Plot 3d
    hold on
    plot3(state(1,:), state(2,:), state(3,:),'color', line_color, 'LineWidth', line_width)
    hold off
    grid on
    xlabel(labels{1});
    ylabel(labels{2});
    zlabel(labels{3});
    set(gca,'fontname','Times');
%     axis([0, 25, 0, 10]);
end

end