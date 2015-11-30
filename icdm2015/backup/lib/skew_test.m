% clear; 
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/label.joint';
end

test_num = 100;
rand_num = 100000;
expect_num = zeros(test_num, 1);
ck_num = length(cookie_label);
dev_num =length(device_label);

for i = 1 : test_num

	pos = [];
	neg = 0;
	ck_seq = floor(ck_num * rand(1, rand_num)) + 1;
	dev_seq = floor(dev_num * rand(1, rand_num)) + 1;

	for j = 1 : rand_num

		if(cookie_label(ck_seq(j)) == device_label(dev_seq(j)))
			pos = [pos j];
		else
			neg++;
		end
	end

	expect_num(i) = length(pos);

	fprintf('... The %d-th test finished ...\r', i);
	fflush(stdout);

end


plot(expect_num, 'b-', 'LineWidth', 2);
xlabel('Experiment times');
grid on;


