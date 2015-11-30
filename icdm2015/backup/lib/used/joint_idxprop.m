% clear; clc;
% id_558314	1	{(property_66021	7)	(property_24444	1)	(property_285395	6)	(property_267459	1)	(property_197052	14)	(property_132313	1)	(property_110400	1)}	

% % % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
% load 'statistics/property_in_idxproperty.stat';   % prop_list
% load 'statistics/id_in_idxproperty.stat'    % cookie_array, device_array
% load 'joint/device.joint';            % device
% load 'joint/cookie.joint';            % cookie
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('... Data loaded ...\n\r');
fflush(stdout);


key = ismember(cookie_array(1,:), cookie);
buf_ck = cookie_array(:, key);
[dump i_ck] = ismember(buf_ck(1,:), cookie);
num_ck = length(buf_ck);
prop_member_cookie = cell(1, length(cookie));
prop_feature_cookie = cell(1, length(cookie));

prop_cookie = int32([]);


for i = 1 : num_ck
	buf_prop = strsplit(property_list{buf_ck(2, i) - 1}(3 : end - 2), '),(');
	buf_prop = cellfun('substr', buf_prop, {10}, 'UniformOutput', false);
	prop_mat = int32([cellfun('sscanf', buf_prop, {'%d'}, 'UniformOutput', false){:}]);
	head = cellfun('index', buf_prop, {','}, 'UniformOutput', false);
	buf_prop = cellfun('substr', buf_prop, head, 'UniformOutput', false);
	buf_prop = cellfun('substr', buf_prop, {2}, 'UniformOutput', false);
	buf_prop = int8([cellfun('sscanf', buf_prop, {'%d'}, 'UniformOutput', false){:}]);

	prop_member_cookie{i_ck(i)} = prop_mat;
	prop_feature_cookie{i_ck(i)} = buf_prop;

	prop_cookie = [prop_cookie prop_mat];

	if(mod(i, 500) == 0)
		fprintf('%d cookie-property recorded...\r', i);
		fflush(stdout);
		prop_cookie = unique(prop_cookie);
	end

end

prop_cookie = unique(prop_cookie);
fprintf('\n... cookie-property finished ...\r\n');
fflush(stdout);


key = ismember(device_array(1,:), device);
buf_dev = device_array(:, key);
[dump i_dev] = ismember(buf_dev(1,:), device);
num_dev = length(buf_dev);
prop_member_device = cell(1, length(device));
prop_feature_device = cell(1, length(device));

prop_device = int32([]);

for i = 1 : num_dev
	buf_prop = strsplit(property_list{buf_dev(2, i) - 1}(3 : end - 2), '),(');
	buf_prop = cellfun('substr', buf_prop, {10}, 'UniformOutput', false);
	prop_mat = int32([cellfun('sscanf', buf_prop, {'%d'}, 'UniformOutput', false){:}]);
	head = cellfun('index', buf_prop, {','}, 'UniformOutput', false);
	buf_prop = cellfun('substr', buf_prop, head, 'UniformOutput', false);
	buf_prop = cellfun('substr', buf_prop, {2}, 'UniformOutput', false);
	buf_prop = int8([cellfun('sscanf', buf_prop, {'%d'}, 'UniformOutput', false){:}]);

	prop_member_device{i_dev(i)} = prop_mat;
	prop_feature_device{i_dev(i)} = buf_prop;

	prop_device = [prop_device prop_mat];

	if(mod(i, 500) == 0)
		fprintf('%d device-property recorded...\r', i);
		fflush(stdout);
		prop_device = unique(prop_device);
	end

end

prop_device = unique(prop_device);

property = unique([prop_device prop_cookie]);

fprintf('\n... device-property finished ...\r\n');
fflush(stdout);


clear('buf_ck', 'buf_dev', 'num_ck', 'num_dev', 'dump', 'key');
clear('prop_mat', 'buf_prop', 'head', 'i_ck', 'i_dev', 'i');


save -binary 'joint/device.joint' device ip_member_device ip_feature_device prop_member_device prop_feature_device;
save -binary 'joint/cookie.joint' cookie ip_member_cookie ip_feature_cookie prop_member_cookie prop_feature_cookie;
save -binary 'joint/property.joint' property prop_device prop_cookie;




