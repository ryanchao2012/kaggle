% clear; 
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end

if(!exist('device', 'var'))
	load 'joint/device.joint';
end

if(!exist('ip', 'var'))
	load 'joint/ip.joint';
end



handle_num = length(handle);
ip_inter_num = zeros(handle_num, 1);

for j = 1 : handle_num

	m_t = member{j};
	dev_id = m_t(find(m_t(:, 2) == 0), 1);
	ck_id = m_t(find(m_t(:, 2) == 1), 1);
	[dummy dev_idx] = ismember(dev_id, device);
	[dummy ck_idx] = ismember(ck_id, cookie);

	ip_pool_ck = [ip_member_cookie(ck_idx){:}];
	ip_pool_dev = [ip_member_device(dev_idx){:}];

	ip_inter_num(j) = length(intersect(ip_pool_ck, ip_pool_dev));

	if(mod(j, 100) == 0)
		fprintf('... The %d-th test finished ...\r', j);
		fflush(stdout);
	end

end

% length(find(ip_inter_num == 0)) -->     106
%               known handle_num  --> 139,419



