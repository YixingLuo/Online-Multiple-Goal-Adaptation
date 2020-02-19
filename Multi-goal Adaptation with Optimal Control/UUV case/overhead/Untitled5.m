A = [16 20 15 17 22 19 17]';
B = [22 15 16 16 16 18]';
C = [23 9 15 18 13 27 17 14 16 15 21 19 17]';
% Calculate means
meanOfA = mean(A);
meanOfB = mean(B);
meanOfC = mean(C);
group = [ ones(size(A));
      2 * ones(size(B));
      3;
      4 * ones(size(C))
       ];

figure;
boxplot([A; B; NaN; C],group);
set(gca,'XTickLabel',{'A','B','','C'});
% Find handle for median line and set visibility off
h = findobj(gca,'Tag','Median');
set(h,'Visible','off');
%plot means as black asterisks.
hold on
plot(1,meanOfA, 'k*')
plot(2,meanOfB, 'k*')
plot(4,meanOfC, 'k*')
h = findobj(gca,'Tag','Median');
set(h,'Visible','on');