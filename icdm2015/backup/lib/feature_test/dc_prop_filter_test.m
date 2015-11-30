clc;
close all;


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


if(!exist('cookie_property_pairs', 'var'))   % cookie_property_pairs cookie_property_id device_property_id cookie_property_df
	load 'joint/property_pair.joint';
end


fprintf('... Env prepared ...\r\n');
fflush(stdout);



num = 1;

[prop_dev prop_pos_ck prop_neg_ck] = dc_prop_filter(device, cookie, device_label, cookie_label, ...
													prop_member_device, prop_member_cookie, ...
													prop_feature_device, prop_feature_cookie, ...
													 dc_filter_list, num);

prop_dev
temp = cookie_property_pairs{find(prop_dev == device_property_id)};
disp('========================== positive ==============================');
% prop_pos_ck
if(!isempty(prop_pos_ck))
	
	n = length(prop_pos_ck);
	for i = 1 : n
		if(isempty(prop_pos_ck{i}))
			continue;
		end

		tf = sum(prop_pos_ck{i} == temp) / length(unique(temp));
		idx = find(prop_pos_ck{i} == cookie_property_id);
		df = cookie_property_df(idx) / length(cookie);
		score = tf / df;
		fprintf('%d \t %f \t %f \t %f \n', prop_pos_ck{i}, tf, df, score);
	end
end
		

disp('========================== negative ============================');
% prop_neg_ck
if(!isempty(prop_neg_ck))
	temp = cookie_property_pairs{find(prop_dev == device_property_id)};
	n = length(prop_neg_ck);
	for i = 1 : n
		if(isempty(prop_neg_ck{i}))
			continue;
		end
		tf = sum(prop_neg_ck{i} == temp) / length(unique(temp));
		idx = find(prop_neg_ck{i} == cookie_property_id);
		df = cookie_property_df(idx) / length(cookie);
		score = tf / df;
		fprintf('%d \t %f \t %f \t %f \n', prop_neg_ck{i}, tf, df, score);
	end
end
disp('==============================================================');

if(!isempty(prop_pos_ck) && !isempty(prop_neg_ck))

end

