clear; clc;
% % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
load 'statistics/ip_in_idxip.stat';   % ip_list
load 'statistics/id_in_idxip.stat'    % cookie_array, device_array
load 'joint/device.joint';            % device
load 'joint/cookie.joint';            % cookie
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('... Data loaded ...\n\r');
fflush(stdout);


key = ismember(cookie_array(1,:), cookie);
buf_ck = cookie_array(:, key);
[dump i_ck] = ismember(buf_ck(1,:), cookie);
num_ck = length(cookie);
ip_member_cookie = cell(1, num_ck);
ip_feature_cookie = cell(1, num_ck);

ip_cookie = int32([]);

for i = 1 : num_ck
	buf_ip = strsplit(ip_list{buf_ck(2, i) - 1}(3 : end - 2), '),(');
	buf_ip = cellfun('substr', buf_ip, {3}, 'UniformOutput', false);
	ip_mat = int32([cellfun('sscanf', buf_ip, {'%d'}, 'UniformOutput', false){:}]);
	head = cellfun('index', buf_ip, {','}, 'UniformOutput', false);
	buf_ip = cellfun('substr', buf_ip, head, 'UniformOutput', false);
	buf_ip = strvcat(cellfun('substr', buf_ip, {2}, 'UniformOutput', false));

	ip_member_cookie{i_ck(i)} = ip_mat;
	ip_feature_cookie{i_ck(i)} = buf_ip;

	if(mod(i, 500) == 0)
		fprintf('%d cookie-ip recorded...\r', i);
		fflush(stdout);
	end

	ip_cookie = [ip_cookie ip_mat];

end

fprintf('\n... cookie-ip finished ...\r\n');
fflush(stdout);


key = ismember(device_array(1,:), device);
buf_dev = device_array(:, key);
[dump i_dev] = ismember(buf_dev(1,:), device);
num_dev = length(device);
ip_member_device = cell(1, num_dev);
ip_feature_device = cell(1, num_dev);
ip_device = int32([]);

for i = 1 : num_dev
	buf_ip = strsplit(ip_list{buf_dev(2, i) - 1}(3 : end - 2), '),(');
	buf_ip = cellfun('substr', buf_ip, {3}, 'UniformOutput', false);
	ip_mat = int32([cellfun('sscanf', buf_ip, {'%d'}, 'UniformOutput', false){:}]);
	head = cellfun('index', buf_ip, {','}, 'UniformOutput', false);
	buf_ip = cellfun('substr', buf_ip, head, 'UniformOutput', false);
	buf_ip = strvcat(cellfun('substr', buf_ip, {2}, 'UniformOutput', false));

	ip_member_device{i_dev(i)} = ip_mat;
	ip_feature_device{i_dev(i)} = buf_ip;

	if(mod(i, 500) == 0)
		fprintf('%d device-ip recorded...\r', i);
		fflush(stdout);
	end

	ip_device = [ip_device ip_mat];

end

fprintf('\n... device-ip finished ...\r\n');
fflush(stdout);

ip_device = unique(ip_device);
ip_cookie = unique(ip_cookie);
ip = unique([ip_device ip_cookie]);

clear('buf_ck', 'buf_dev', 'num_ck', 'num_dev', 'dump', 'i_ck', 'i_dev', 'key');
clear('ip_mat', 'buf_ip', 'device_array', 'cookie_array', 'head', 'i');

save -binary 'joint/device.joint' device ip_member_device ip_member_cookie;
save -binary 'joint/cookie.joint' cookie ip_feature_device ip_feature_cookie;
save -binary 'joint/ip.joint' ip ip_device ip_cookie;


