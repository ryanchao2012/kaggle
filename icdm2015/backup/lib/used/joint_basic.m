clc;
close all;

if(!exist('cookie', 'var'))   % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end

if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end

if(!exist('handle', 'var'))  % handle member
	load 'joint/handle.joint';
end

dev_num = length(device);
ck_num = length(cookie);
hd_num = length(handle);

if(!exist('basic_device', 'var')) 
	basic_device = cell(dev_num, 1);
end

if(!exist('basic_cookie', 'var')) 
	basic_cookie = cell(ck_num, 1);
end

fprintf('... Env prepared ...\r\n');
fflush(stdout);

checkSum_dev = 0;
checkSum_ck = 0;

for i = 1 : hd_num
	_mem = member{i};
	idx_fea_dev = find(_mem(:, 2) == 0);
	idx_fea_ck = find(_mem(:, 2) == 1);
	_dev = _mem(idx_fea_dev, 1);
	_ck = _mem(idx_fea_ck, 1);

	[dummy idx_dev] = ismember(_dev, device);
	[dummy idx_ck] = ismember(_ck, cookie);

	n_dev = length(idx_dev);
	n_ck = length(idx_ck);

	for j = 1 : n_dev
		basic_device{idx_dev(j)} = feature_basic{i}(idx_fea_dev(j), :);
		checkSum_dev++;
	end

	for k = 1 : n_ck
		basic_cookie{idx_ck(k)} = feature_basic{i}(idx_fea_ck(k), :);
		checkSum_ck++;
	end

	if(mod(i, 1000) == 0)
		fprintf('%d handles processed...\r', i);
		fflush(stdout);
	end
end

fprintf('\n');


save -binary 'joint/device.joint' device ip_member_device ip_feature_device prop_member_device prop_feature_device basic_device
save -binary 'joint/cookie.joint' cookie ip_member_cookie ip_feature_cookie prop_member_cookie prop_feature_cookie basic_cookie






