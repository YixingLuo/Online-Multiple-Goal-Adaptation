function [pos, vel, acc] = tj_from_line(start_pos, end_pos,k_end, t_c)
global velocity_history
    k1 = k_end;
    vel = [velocity_history(k1,1);velocity_history(k1,2);velocity_history(k1,3)];
    pos = start_pos + t_c*vel;
    acc = [0;0;0];
%     v_max = (end_pos-start_pos)*2/time_ttl;
%     if t_c >= 0 & t_c < time_ttl/2
%         vel = v_max*t_c/(time_ttl/2);
%         pos = start_pos + t_c*vel/2;
%         acc = [0;0;0];
%     else
%         vel = v_max*(time_ttl-t_c)/(time_ttl/2);
%         pos = end_pos - (time_ttl-t_c)*vel/2;
%         acc = [0;0;0];
%     end
end