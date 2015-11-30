% clear; clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end

test_num = 40;
sample_num = 2000;
fprintf('... Randomly select %d positive/negative samples ...\n\r', sample_num);

n = 2 * sample_num;

false_positive = zeros(1, test_num);
false_negative = zeros(1, test_num);

for j = 1 : test_num
	sample = cc_sample_extract(handle, member, cookie, sample_num);
	ip_inter_num = zeros(n, 1);
	for i = 1 : n
		ip_ck1 = ip_member_cookie{sample(i, 3)};
		ip_ck2 = ip_member_cookie{sample(i, 4)};
		ip_inter_num(i) = length(intersect(ip_ck1, ip_ck2));
	end
	false_positive(j) = 100 * sum(ip_inter_num(sample_num + 1 : end) != 0)/ n;
	false_negative(j) = 100 * sum(ip_inter_num(1 : sample_num) == 0) / n;

	fprintf('... The %d-th test finished ...\n\r', j);
	fflush(stdout);
end

hold on;
grid on;
plot(false_positive, 'b-', 'LineWidth', 2);
plot(false_negative, 'r-', 'LineWidth', 2);
legend('False Positive', 'False Negative');
xlabel('Test Number');
ylabel('Percentage(%)');
title('IP intersection test(cookie vs cookie)');


% y = zeros(sample_num, 1);
% plot(ip_inter_num(1 : sample_num), y, 'bo');
% plot(ip_inter_num(sample_num + 1 : end), y, 'rx');

% fprintf('... %2.3f%% of positive samples have NO ip-intersection ...\n\r', ...
% 	    100 * sum(ip_inter_num(1 : sample_num) == 0) / sample_num);

% fprintf('... %2.3f%% of negative samples have    ip-intersection ...\n\r', ...
% 	    100 * sum(ip_inter_num(sample_num + 1 : end) != 0)/sample_num);




