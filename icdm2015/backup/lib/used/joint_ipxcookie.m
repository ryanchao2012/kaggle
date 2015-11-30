clc;
close all;

if(!exist('ip', 'var'))
	load 'joint/ip.joint';  % ip feature_ip
end

if(!exist('cookie_array', 'var'))
	load 'refine/id_in_idxip.stat';
end

if(!exist('refine_list', 'var'))
	load 'refine/ip_in_idxip.ref' 
end

ip_num = length(ip);
ck_num = size(cookie_array, 2);
% ip_cookie_member = cell(ip_num, 1);

s = 1200001;
e = ck_num;

for i = s : e

	ip_buff = refine_list{i}(1, :);
	[dummy idx] = ismember(ip_buff, ip);
	idx(find(dummy == 0)) = [];
	n = length(idx);
	for j = 1 : n
		ip_cookie_member{idx(j)} = [ip_cookie_member{idx(j)} cookie_array(1, i)];
	end

	if(mod(i, 1000) == 0)
		fprintf('%d lines join...\r', i);
		fflush(stdout);
	end

end


fprintf('\n');


