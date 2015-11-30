clc;
close all;


if(!exist('test_device', 'var'))  % test_device ...
	load 'joint/test_device.joint';
end


if(!exist('device_array', 'var'))  % device_array cookie_array
	load 'refine/id_in_idxip.stat';
end


if(!exist('refine_list', 'var'))  % refine_list
	load 'refine/ip_in_idxip.ref';
end


test_device_num = length(test_device);
test_device_ip_member = cell(test_device_num, 1);
[dummy dev_idx] = ismember(test_device, device_array(1, :));

for i = 1 : test_device_num
	ip_idx = device_array(2, dev_idx(i)) - 1;
	test_device_ip_member{i} = refine_list{ip_idx}(1, :);

	if(mod(i, 500) == 0)
		fprintf('%d test-ip joined...\r', i);
		fflush(stdout);
	end

end


fprintf('\n');

save -binary 'joint/test_device.joint' test_device_ip_member test_device;

