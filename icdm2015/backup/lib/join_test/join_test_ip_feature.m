clc;
close all;


if(!exist('test_device', 'var'))  % test_device test_device_ip_member
	load 'joint/test_device.joint';
end


if(!exist('ip_array', 'var'))  % ip_array
	load 'statistics/ip_in_ipagg.stat';
end


if(!exist('rest_list', 'var'))  % rest_list
	load 'statistics/rest_in_ipagg.stat';
end

test_ip_all = unique([test_device_ip_member{:}]);
ip_num = length(test_ip_all);
test_ip_feature = zeros(ip_num, 5);
[dummy ip_idx] = ismember(test_ip_all, ip_array(1, :));


for i = 1 : ip_num
	test_ip_feature(i, :) = str2num(rest_list{ip_idx(i)});

	if(mod(i, 500) == 0)
		fprintf('%d test-ip feature joined...\r', i);
		fflush(stdout);
	end

end


fprintf('\n');


save -binary 'joint/test_ip.joint' test_ip_all test_ip_feature;






