clc;
close all;

if(!exist('ip', 'var'))   % ip feature_ip shared_cookie
	load 'joint/ip.joint';
end

if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end

dev_num = length(device);
% ip_num = length(ip);

if(!exist('dc_filter_list', 'var')) 
	dc_filter_list = cell(dev_num, 1);
end


fprintf('... Env prepared ...\r\n');
fflush(stdout);

s = 1;
e = dev_num;

for i = s : e

	ip_buff = ip_member_device{i};
	[dummy idx] = ismember(ip_buff, ip);
	idx(find(dummy == 0)) = [];

	dc_filter_list{i} = [shared_cookie{idx}];


	if(mod(i, 1000) == 0)
		fprintf('%d devices filtered...\r', i);
		fflush(stdout);
	end

end

fprintf('\r\n');

save -binary 'joint/filter.joint' dc_filter_list;







