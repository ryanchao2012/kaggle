clc;
close all;

if(!exist('ip_light', 'var'))   % ip_light feature_ip_light shared_cookies
	load 'joint/ip_light.joint';
end

if(!exist('device', 'var'))  % device ip_member_device ip_feature_device
	load 'joint/device_ip_light.join';
end

dev_num = length(device);

if(!exist('dc_filter_new_list', 'var')) 
	dc_filter_new_list = cell(dev_num, 1);
end


fprintf('... Env prepared ...\n');
fflush(stdout);

s = 1;
e = dev_num;

for i = s : e

	ip_buff = ip_member_device{i};
	[dummy idx] = ismember(ip_buff, ip_light);
	idx(!dummy) = [];

	dc_filter_new_list{i} = [shared_cookies{idx}];


	if(mod(i, 1000) == 0)
		fprintf('%d devices filtered...\r', i);
		fflush(stdout);
	end

end

fprintf('\n');

save -binary 'joint/filter_new.joint' dc_filter_new_list;







