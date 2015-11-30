% clear; clc;

% load 'refine/device_in_device.stat';  % device_array
% load 'refine/cookie_in_cookie.stat';  % cookie_array


% load 'statistics/rest_in_cookie.stat';
% cookie_rest = rest_list;
% load 'statistics/rest_in_device.stat';
% dev_rest = rest_list;
% clear rest_list;


% if(!exist('cookie', 'var'))   % cookie ip_refine_cookie
% 	load 'joint/cookie_ip_light.joint';
% end

% if(!exist('device', 'var'))  % device ip_member_device ip_feature_device
% 	load 'joint/device_ip_light.joint';
% end


fprintf('... Env prepared ...\n');
fflush(stdout);

dev_num = length(device);
ck_num = length(cookie);
rest_num = length(cookie_rest);
% basic_device = zeros(dev_num, 9);
% basic_cookie = zeros(ck_num, 9);


% for i = 1 : dev_num
% 	temp = [regexp([dev_rest{i} ','], '(-?\d+),', 'tokens'){:}];
% 	basic_device(i, :) = [cellfun('str2num', temp, 'UniformOutput', false){:}];

% 	if(mod(i, 1000) == 0)
% 		fprintf('%d device processed...\r', i);
% 		fflush(stdout);
% 	end
% end

% fprintf('\n');
% fflush(stdout);


for i = 1 : rest_num
	temp = [regexp([cookie_rest{i} ','], '(-?\d+),', 'tokens'){:}];
	basic_cookie(i, :) = [cellfun('str2num', temp, 'UniformOutput', false){:}];

	if(mod(i, 1000) == 0)
		fprintf('%d cookie processed...\r', i);
		fflush(stdout);
	end
end

fprintf('\n');
fflush(stdout);


% save -binary 'joint/device_light.joint' device ip_member_device ip_feature_device basic_device
% save -binary 'joint/cookie_light.joint' cookie ip_refine_cookie basic_cookie
