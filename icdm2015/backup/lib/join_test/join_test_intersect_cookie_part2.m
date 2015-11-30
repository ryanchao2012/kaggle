clc;
close all;

if(!exist('test_device', 'var'))  % test_device test_device_ip_member
	load 'joint/test_device.joint';
end


if(!exist('test_ip_all', 'var'))  % test_ip_all test_ip_feature test_ip_cookie_list
	load 'joint/test_ip.joint';
end



fprintf('... Env prepared ...\n');
fflush(stdout);


dev_num = length(test_device);

test_device_cookie_list = cell(dev_num, 1);

for i = 1 : dev_num

	[dummy ip_idx] = ismember(test_device_ip_member{i}, test_ip_all);
	test_device_cookie_list{i} = [test_ip_cookie_list{ip_idx}];

	if(mod(i, 500) == 0)
		fprintf('%d test-device cookie joined...\r', i);
		fflush(stdout);
	end

end

fprintf('\n... join finished ...\n');
fflush(stdout);


save -binary 'joint/test_device.joint' test_device_ip_member test_device test_device_cookie_list;



