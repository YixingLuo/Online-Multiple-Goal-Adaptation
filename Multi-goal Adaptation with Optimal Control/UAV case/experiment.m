t1=24;
t2=200;
N=2;
sd1 = 1-(24-t1)/(t2-t1) + 1-1.6427/(2*N)
sd1 = 1-(26-t1)/(t2-t1) + 1-0.2357/(2*N)
sd1 = 1-(28-t1)/(t2-t1) + 1-0.0314/(2*N)

R=4.5;
pr = 0;
for i = 1: size(trajectory_24,1)
    for j = 1:size(threat,1)
        risk = max(0,R-sqrt((trajectory_24(i,1) - threat(j,1)).^2 + (trajectory_24(i,2) - threat(j,2)).^2 + (trajectory_24(i,3) - threat(j,3)).^2))/R;
        if trajectory_24(i,4) == 1
            risk = risk /3;
        end
%         if risk > 0
%             i,j
%         end
        pr = pr + risk;
    end
end
pr

pr = 0;
for i = 1: size(trajectory_26,1)
    for j = 1:size(threat,1)
        risk = max(0,R-sqrt((trajectory_26(i,1) - threat(j,1)).^2 + (trajectory_26(i,2) - threat(j,2)).^2 + (trajectory_26(i,3) - threat(j,3)).^2))/R;
        if trajectory_26(i,4) == 1
            risk = risk /3;
        end
%         if risk > 0
%             i,j
%         end
        pr = pr + risk;
    end
end
pr

pr = 0;
for i = 1: size(trajectory_28,1)
    for j = 1:size(threat,1)
        risk = max(0,R-sqrt((trajectory_28(i,1) - threat(j,1)).^2 + (trajectory_28(i,2) - threat(j,2)).^2 + (trajectory_28(i,3) - threat(j,3)).^2))/R;
        if trajectory_28(i,4) == 1
            risk
            risk = risk /3;
        end
%         if risk > 0
%             i,j
%         end
        pr = pr + risk;
    end
end
pr

sd1 = 1-(24-t1)/(t2-t1) + 1-0.8312/(2*N)
sd1 = 1-(26-t1)/(t2-t1) + 1-0.3622/(2*N)
sd1 = 1-(28-t1)/(t2-t1) + 1-0.3150/(2*N)

% threat1 = [0,6,1];
% threat2 = [0,6,2];
% a1 = [4,4,0];
% a2 = [4,5,0];
% b1 = [3,5,0];
% b2 = [3,6,0];
% c1 = [4,4,0];
% c2 = [5,4,0];
% 
% max(0,4.5-norm(a1-threat1))/4.5/3 + max(0,4.5-norm(a1-threat2))/4.5/3 + max(0,4.5-norm(a2-threat1))/4.5/3 + max(0,4.5-norm(a2-threat2))/4.5/3
% 
% max(0,4.5-norm(b1-threat1))/4.5/3 + max(0,4.5-norm(b1-threat2))/4.5/3 + max(0,4.5-norm(b2-threat1))/4.5/3 + max(0,4.5-norm(b2-threat2))/4.5/3
% 
% max(0,4.5-norm(c1-threat1))/4.5/3 + max(0,4.5-norm(c1-threat2))/4.5/3 + max(0,4.5-norm(c2-threat1))/4.5 + max(0,4.5-norm(c2-threat2))/4.5
% 
% t1=24;
% t2=60;
% N=2;
% sd1 = 1-(24-t1)/(t2-t1) + 1-0.3092/(2*N)
% sd1 = 1-(26-t1)/(t2-t1) + 1-0.0191/(2*N)
% sd1 = 1-(28-t1)/(t2-t1) + 1-0/(2*N)