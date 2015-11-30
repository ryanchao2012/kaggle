clc; close all;

% % % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % %
if(!exist('device', 'var'))
	load 'new_join/device_train.join'; % device ip_refine_device basic_device
end

if(!exist('cookie', 'var'))
	load 'new_join/cookie_train.join'; % cookie ip_refine_cookie basic_cookie
end

if(!exist('property_list', 'var'))
	load 'statistics/property_in_idxproperty.stat';   % property_list
end

if(!exist('cookie_array', 'var') || !exist('device_array', 'var'))
	load 'statistics/id_in_idxproperty.stat'; % cookie_array, device_array
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

dev_num = length(device);
ck_num = length(cookie);

% % % % % % % % % % % % % % % % - target - % % % % % % % % % % % % % % % % % % % % %
% if(exist('new_join/property_device.join'))
% 	load 'new_join/property_device.join'; % property_member_device property_feature_device prop_idx_dev curr_idx_dev
% else
% 	property_member_device = cell(dev_num, 1);
% 	property_feature_device = cell(dev_num, 1);
% 	[t prop_idx_dev] = ismember(device, device_array(1, :));
% 	curr_idx_dev = 1;
% 	clear t;
% 	save -binary 'new_join/property_device.join' property_member_device property_feature_device prop_idx_dev curr_idx_dev;
% end


if(exist('new_join/property_cookie.join'))
	load 'new_join/property_cookie.join'; % property_member_cookie property_feature_cookie prop_idx_ck curr_idx_ck
else
	property_member_cookie = cell(ck_num, 1);
	property_feature_cookie = cell(ck_num, 1);
	[t prop_idx_ck] = ismember(cookie, cookie_array(1, :));
	curr_idx_ck = 1;
	clear t;
	save -binary 'new_join/property_cookie.join' property_member_cookie property_feature_cookie prop_idx_ck curr_idx_ck;
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

fprintf('... Env prepared ...\n');
fflush(stdout);



s = curr_idx_ck;
e = curr_idx_ck + 1500000;
if(e > ck_num)
	e = ck_num;
end

for i = s : e
	if(prop_idx_ck(i) == 0)
		curr_idx_ck++;
		continue;
	end
	buff = property_list{cookie_array(2, prop_idx_ck(i)) - 1};
	buff = [regexp(buff, '_(\d+),(\d+)', 'tokens'){:}];
	buff = [cellfun('sscanf', buff, {'%d'}, 'UniformOutput', false){:}];

	property_member_cookie{i} = int32(buff(1:2:end));
	property_feature_cookie{i} = int8(buff(2:2:end));
	curr_idx_ck++;
	if(mod(i, 500) == 0)
		fprintf('%d cookie processed...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');



% s = curr_idx_dev;
% e = curr_idx_dev + 50000;
% if(e > dev_num)
% 	e = dev_num;
% end

% for i = s : e
% 	if(prop_idx_dev(i) == 0)
% 		curr_idx_dev++;
% 		continue;
% 	end
% 	buff = property_list{device_array(2, prop_idx_dev(i)) - 1};
% 	buff = [regexp(buff, '_(\d+),(\d+)', 'tokens'){:}];
% 	buff = [cellfun('sscanf', buff, {'%d'}, 'UniformOutput', false){:}];

% 	property_member_device{i} = int32(buff(1:2:end));
% 	property_feature_device{i} = int8(buff(2:2:end));
% 	curr_idx_dev++;
% 	if(mod(i, 500) == 0)
% 		fprintf('%d device processed...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% save -binary 'new_join/property_device.join' property_member_device property_feature_device prop_idx_dev curr_idx_dev;
save -binary 'new_join/property_cookie.join' property_member_cookie property_feature_cookie prop_idx_ck curr_idx_ck;





