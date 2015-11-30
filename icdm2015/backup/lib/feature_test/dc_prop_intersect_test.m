% clear; clc;
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
sample_num = 5000;


fprintf('... Randomly select %d positive/negative samples ...\n\r', sample_num);
fflush(stdout);


n = 2 * sample_num;
false_positive = zeros(1, test_num);
false_negative = zeros(1, test_num);


for j = 1 : test_num
	sample = sample_extract(handle, member, device, cookie, sample_num);
	prop_inter_num = zeros(n, 1);
	for i = 1 : n
		prop_dev = prop_member_device{sample(i, 3)};
		prop_ck = prop_member_cookie{sample(i, 4)};
		prop_inter_num(i) = length(intersect(prop_dev, prop_ck));
	end
	false_positive(j) = 100 * sum(prop_inter_num(sample_num + 1 : end) != 0)/sample_num;
	false_negative(j) = 100 * sum(prop_inter_num(1 : sample_num) == 0) / sample_num;

	fprintf('... The %d-th test finished ...\n\r', j);
	fflush(stdout);
end

hold on;
grid on;
% plot(false_positive, 'b-', 'LineWidth', 2);
% plot(false_negative, 'r-', 'LineWidth', 2);
% legend('False Positive', 'False Negative');
% xlabel('Test Number');
% ylabel('Percentage(%)');

y = zeros(sample_num, 1);
plot(prop_inter_num(1 : sample_num), y, 'bo');
plot(prop_inter_num(sample_num + 1 : end), y, 'rx');




