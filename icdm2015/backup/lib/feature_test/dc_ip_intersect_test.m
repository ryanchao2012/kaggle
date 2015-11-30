% clear; 
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end

if(!exist('device', 'var'))
	load 'joint/device.joint';
end

test_num = 1;
nNum = 5000;
skew_ratio = 1;
pNum = 1 + round(skew_ratio * nNum);

fprintf('... Randomly select %d:%d(P:N) positive/negative samples ...\n\r', pNum, nNum);
fflush(stdout);


n = nNum + pNum;
PRE = zeros(1, test_num);
REC = zeros(1, test_num);
FSC = zeros(1, test_num);


for j = 1 : test_num
	
	sample = dc_sample_extract(handle, member, device, cookie, pNum, nNum);
	ip_inter_num = zeros(n, 1);
	for i = 1 : n
		ip_dev = ip_member_device{sample(i, 3)};
		ip_ck = ip_member_cookie{sample(i, 4)};
		ip_inter_num(i) = length(intersect(ip_dev, ip_ck));
	end
	FP = sum(ip_inter_num(sample_num + 1 : end) != 0)/ n;
	TN = - FP + sample_num / n;
	FN = sum(ip_inter_num(1 : sample_num) == 0) / n;
	TP = - FN + sample_num / n;
	REC(j) = 100 * TP / (TP + FN);
	PRE(j) = 100 * TP / (TP + FP);
	FSC(j) = 2 * REC(j) * PRE(j) / (PRE(j) + REC(j));
	% fprintf('precision \t recall \t F-score \t pNum \t\t nNum \r\n');
	% fprintf('%2.2f%% \t %2.2f%% \t %2.2f%% \t %d \t\t %d \r\n', ...
	% 	     PRE, REC, FSC, sample_num, sample_num);
	fprintf('... The %d-th test finished ...\n\r', j);
	fflush(stdout);
end

hold on;
grid on;
plot(PRE, 'b-', 'LineWidth', 2);
plot(REC, 'r-', 'LineWidth', 2);
plot(FSC, 'g-', 'LineWidth', 2);
legend('Precision', 'Recall', 'F-Score');
xlabel('Test Number');
ylabel('Percentage(%)');
title('IP Intersection Test(Device vs Cookie)');

% plot(ip_inter_num(1 : sample_num), y, 'bo');
% plot(ip_inter_num(sample_num + 1 : end), y, 'rx');

% fprintf('... %2.3f%% of positive samples have NO ip-intersection ...\n\r', ...
% 	    100 * sum(ip_inter_num(1 : sample_num) == 0) / sample_num);

% fprintf('... %2.3f%% of negative samples have    ip-intersection ...\n\r', ...
% 	    100 * sum(ip_inter_num(sample_num + 1 : end) != 0)/sample_num);




