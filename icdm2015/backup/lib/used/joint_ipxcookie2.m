clc;
close all;

if(!exist('ip', 'var'))
	load 'joint/ip.joint';  % ip feature_ip
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint'; % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
end

ip_num = length(ip);
ck_num = length(cookie);

if(!exist('share_cookie', 'var'))
	shared_cookie = cell(ip_num, 1);
end

fprintf('Env prepared...\r\n');
fflush(stdout);

s = 1;
e = ck_num;

for i = s : e

	ip_buff = ip_member_cookie{i};
	[dummy idx] = ismember(ip_buff, ip);
	idx(find(dummy == 0)) = [];
	n = length(idx);

	for j = 1 : n
		shared_cookie{idx(j)} = [shared_cookie{idx(j)} cookie(i)];
	end

	if(mod(i, 1000) == 0)
		fprintf('%d cookies joined...\r', i);
		fflush(stdout);
	end

end


fprintf('\n');

save -binary 'joint/ip.joint' ip feature_ip shared_cookie;

