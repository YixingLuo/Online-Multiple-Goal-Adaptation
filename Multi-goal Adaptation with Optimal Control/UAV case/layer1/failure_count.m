
configure = Configure();
num_failure2 = 0;
for i = 1:1000
%     if data2(i,8)==-1 || data2(i,7)>1e-6 || data2(i,10)==-1 || data2(i,9)>1e-6 || data2(i,3)-15>1e-6 || 0.9-data2(i,1)>1e-6 || data2(i,1)==0
     if data2(i,8)==-1 || data2(i,10)==-1 || data2(i,1)==0 || data2(i,1)< configure.forensic_budget || data2(i,3) > configure.Time_budget || data2(i,5) > configure.battery_budget
%         || data2(i,5) > 30
        num_failure2 = num_failure2 + 1; 
    end
end
num_failure2 

num_failure3 = 0;
for i = 1:1000
    if data3(i,8)==-1 || data3(i,10)==-1 || data3(i,1)==0 || data3(i,1)< configure.forensic_budget || data3(i,3) > configure.Time_budget || data3(i,5) > configure.battery_budget
        num_failure3 = num_failure3 + 1;
    end
end
num_failure3 