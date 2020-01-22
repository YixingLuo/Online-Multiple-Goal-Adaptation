num_failure2 = 0;
for i = 1:100
    if data2(i,8)==-1 || data2(i,10)==-1 || data2(i,5)>30
        num_failure2 = num_failure2 + 1;
    end
end
num_failure2 

num_failure3 = 0;
for i = 1:100
    if data3(i,8)==-1 || data3(i,10)==-1
        num_failure3 = num_failure3 + 1;
    end
end
num_failure3 