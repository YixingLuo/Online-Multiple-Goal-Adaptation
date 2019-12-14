[SR, PR,dis_o,dis_p] = caculate_risk(trajectory, env);
for i = 1:size(dis_o,1)
    for j = 1:size(dis_o,2)
        if dis_o(i,j)<0.7
            i,j,dis_o(i,j)
%             j
        end
    end
end

for i = 1:size(dis_p,1)
    for j = 1:size(dis_p,2)
        if dis_p(i,j)<0.7
            i,j,dis_p(i,j)
%             j
        end
    end
end