clc;
close all;


if(!exist('cookie_array', 'var'))  % device_array cookie_array
	load 'refine/id_in_idxip.stat';
end


if(!exist('refine_list', 'var'))  % refine_list
	load 'refine/ip_in_idxip.ref';
end


if(!exist('test_ip_all', 'var'))  % test_ip_all test_ip_feature
	load 'joint/test_ip.joint';
end



fprintf('... Env prepared ...\n');
fflush(stdout);


ck_num = length(cookie_array(1, :));
ip_num = length(test_ip_all);
test_ip_cookie_list = cell(ip_num, 1);


for i = 1 : ck_num

	ip_ck = refine_list{cookie_array(2, i) - 1}(1, :);
	[dummy ip_idx] = ismember(ip_ck, test_ip_all);
	ip_idx(find(dummy == 0)) = [];


	if(mod(i, 500) == 0)
		fprintf('%d test-ip cookie joined...\r', i);
		fflush(stdout);
	end

	if(isempty(ip_idx))
		continue;
	end

	for j = 1 : length(ip_idx)
		test_ip_cookie_list{ip_idx(j)} = [test_ip_cookie_list{ip_idx(j)} cookie_array(1, i)];
	end


end


fprintf('\n');



save -binary 'joint/test_ip.joint' test_ip_all test_ip_feature test_ip_cookie_list;





