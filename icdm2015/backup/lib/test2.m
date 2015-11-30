clc;clear;
close all;


if(!exist('ip', 'var'))  % ip feature_ip shared_cookie
	load 'joint/ip.joint';
end


if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end


if(!exist('cookie', 'var'))   % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end


if(!exist('cookie_label', 'var') || !exist('device_label', 'var'))   % cookie_label device_label
	load 'joint/label.joint'; 
end


if(!exist('dc_filter_list', 'var'))   % dc_filter_list
	load 'joint/filter.joint'; 
end




fprintf('... Env prepared ...\n');
fflush(stdout);


% dev_num = length(device);

% s = curr_index;
% e = curr_index + 10000;
% if(e > dev_num)
% 	e = dev_num;
% end
% idx_dev = find(device)
idx_dev = 84417;

[ip_feature_pos ip_feature_neg] = dc_ip_filter(device, cookie, device_label, cookie_label, ...
											  ip_member_device, ip_member_cookie, ip_feature_cookie, ...
										      ip, feature_ip, dc_filter_list, idx_dev);

ip_feature_pos
if(length(ip_feature_neg) > 10)
	ip_feature_neg(1:10)
else
	ip_feature_neg
end


% ip: 9035435
% cookie: 4506215 975792
% device: 1197115
% dev_idx =  6653

