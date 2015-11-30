clc;
close all;


if(!exist('ip_light', 'var'))
	load 'joint/ip_light.joint';  % ip_light feature_ip_light
end

if(!exist('cookie_array', 'var'))
	load 'refine/id_in_idxip.stat'  % cookie_array device_array
end

if(!exist('refine_list', 'var'))
	load 'refine/ip_in_idxip.ref'  % refine_list
end


fprintf('... Env prepared ...\n');
fflush(stdout);



ipl_num = length(ip_light);
shared_cookies = cell(ipl_num, 1);
ck_num = size(cookie_array, 2);

cookie = -1 * ones(ck_num, 1);
ip_refine_cookie = cell(ck_num, 1);

ck_idx = 1;
for i = 1 : ck_num

	ip_buff = refine_list{i}(1, :);

	[bool ip_idx] = ismember(ip_buff, ip_light);

	if(sum(bool) == 0)
		continue;
	end

	cookie(ck_idx) = cookie_array(1, i);
	ip_refine_cookie{ck_idx++} = [refine_list{i}(:, bool)]';

	ip_idx(!bool) = [];
	n = length(ip_idx);

	for j = 1 : n
		shared_cookies{ip_idx(j)} = [shared_cookies{ip_idx(j)} cookie_array(1, i)];
	end

	if(mod(i, 500) == 0)
		fprintf('%d cookies joined...\r', i);
		fflush(stdout);
	end

end


fprintf('\n');

cookie(ck_idx : end) = [];
ip_refine_cookie(ck_idx : end) = [];


save -binary 'joint/ip_light.joint' ip_light feature_ip_light shared_cookies;
save -binary 'joint/cookie_ip_light.join' cookie ip_refine_cookie;










