clc; clear;
close all;

% refine basice-feature of device-test set
% load 'refine/id_in_idxip.stat';  % device_array cookie_array;
% if(!exist('refine_list', 'var'))
% 	load 'refine/ip_in_idxip.ref'; 	% refine_list;
% end
% load 'new_join/device_test.join';   % device_test basic_device_test ip_refine_device_test cx_index_device
% load 'new_join/ip_test.join';    % ip_test feature_ip_test
% load 'new_join/c1c2_pair.join'; % device_c1_id device_c2_id ....
load 'new_join/dc_filter_test.join'; % dc_filter_test
load 'refine/cookie_light_in_cookie.ref'; % cookie_light_array
% load 'new_join/cookie_test.join'; % cookie_test ip_refine_cookie_test basic_cookie_test;
% load 'statistics/cookie_in_cookie.stat'; % cookie_array
% load 'statistics/rest_in_cookie.stat'; % rest_list
% load 'new_join/ip_test.join'; % ip_test
% load 'refine/ip_in_ipagg.stat'; % ip_array
% load 'statistics/rest_in_ipagg.stat';
% load 'new_join/ip_test_light.join'; % ip_test_light feature_ip_test_light shared_num_light shared_cookies_light


fprintf('... Env prepared ...\n');
fflush(stdout);



dev_num = length(dc_filter_test);
dc_filter_light_test = cell(dev_num, 1);
col = cellfun('columns', dc_filter_test);
ck = [dc_filter_test{:}];
ck = ck(1, :);
bool = ismember(ck, cookie_light_array(1, :));

e = 0;
for i = 1 : dev_num
	s = e + 1;
	e = e + col(i);
	dc_filter_light_test{i} = dc_filter_test{i}(:, bool(s : e));


 	if(mod(i, 500) == 0)
		fprintf('... %d filter-light refined ...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');

save -binary 'new_join/dc_filter_light_test.join' dc_filter_light_test;

% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 



% dev_num = length(device_test);
% ip_refine_device_idx = cell(dev_num, 1);



% for i = 1 : dev_num
% 	ip_dev = ip_refine_device_test{i}(:, 1);

% 	[bool ip_idx] = ismember(ip_dev, ip_test_light);
% 	ip_refine_device_idx{i} = ip_idx;


%  	if(mod(i, 5000) == 0)
% 		fprintf('%d device processed...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% save -binary 'new_join/device_test.join' device_test basic_device_test ip_refine_device_test ip_refine_device_idx cx_index_device


% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 




% ck_num = length(cookie_test);
% ip_num = length(ip_test);
% shared_cookies = cell(ip_num, 1);

% for i = 1 : ck_num

% 	ip_ck = ip_refine_cookie_test{i}(:, 1);

% 	[bool ip_idx] = ismember(ip_ck, ip_test);

% 	ip_idx(!bool) = [];
% 	n = length(ip_idx);

% 	for j = 1 : n
% 		shared_cookies{ip_idx(j)} = [shared_cookies{ip_idx(j)} cookie_test(i)];
% 	end

% 	if(mod(i, 500) == 0)
% 		fprintf('%d cookies joined...\r', i);
% 		fflush(stdout);
% 	end

% end

% shared_num = cellfun('length', shared_cookies);


% save -binary 'new_join/ip_test.join' ip_test feature_ip_test shared_num shared_cookies;



% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 




% ck_num = length(cookie_test);
% [bool ck_idx] = ismember(cookie_test, cookie_array(1, :));
% basic_cookie_test = int32(zeros(ck_num, 9));

% for i = 1 : ck_num
% 	str = rest_list{cookie_array(2, ck_idx(i)) - 1};
% 	temp = [regexp([str ','], '(-?\d+),', 'tokens'){:}];
% 	temp = [cellfun('sscanf', temp, {'%d'}, 'UniformOutput', false){:}];

% 	basic_cookie_test(i, :) = int32(temp);

% 	if(mod(i, 1000) == 0)
% 		fprintf('%d cookie processed...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% save -binary 'new_join/cookie_test.join' cookie_test ip_refine_cookie_test basic_cookie_test;




% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 





% ip_refine_cookie_test = cell(ck_num, 1);
% [bool ck_idx] = ismember(cookie_test, cookie_array(1,:));
% ref_idx = cookie_array(2, ck_idx) - 1;

% for i = 1 : ck_num

% 		ip_refine_cookie_test{i} = refine_list{ref_idx(i)}';

% 		% ip_test = [ip_test ; ip_refine_device_test{i}(:, 1)];
% 		if(mod(i, 5000) == 0)
% 			fprintf('%d cookie processed...\r', i);
% 			fflush(stdout);
% 		end

% end
% fprintf('\n');


% save -binary 'new_join/cookie_test.join' cookie_test ip_refine_cookie_test;




% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 




% ip_num = length(ip_test);

% feature_ip_test = -1 * ones(ip_num, 5);

% [bool ip_idx] = ismember(ip_test, ip_array(1, :));

% for i = 1 : ip_num

% 	feature_ip_test(i, :) = sscanf(rest_list{ip_array(2, ip_idx(i)) - 1}, '%d,%d,%d,%d,%d')';

% 	if(mod(i, 1000) == 0)
% 		fprintf('... %d ip_test refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');
% % feature_ip_light(i_ip(i), :) = sscanf(rest_list{buf_ip(2, i) - 1}, '%d,%d,%d,%d,%d')';
% feature_ip_test = int32(feature_ip_test);

% save -binary 'new_join/ip_test.join' ip_test feature_ip_test;



% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 



% dev_num = length(dc_filter_test);
% standin = dc_filter_test;
% for i = 1 : dev_num

% 	temp = dc_filter_test{i};

% 	[U, ~, J] = unique(temp);
% 	R = accumarray(J', 1);
% 	[bool ck_idx] = ismember(U, cookie_test);

% 	standin{i} = int32([[U(:)]' ; [R(:)]' ; [ck_idx(:)]']);

% 	if(mod(i, 1000) == 0)
% 		fprintf('... %d dc_filter refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% dev_num = length(device_test);
% cx_index_device = int32(zeros(dev_num, 2));

% [bool idx] = ismember(basic_device_test(:, 5), device_c1_id);
% cx_index_device(:, 1) = idx(:);

% [bool idx] = ismember(basic_device_test(:, 6), device_c2_id);
% cx_index_device(:, 2) = idx(:);

% ip_refine_device_idx = cell(dev_num, 1);


% for i = 1 : dev_num
% 	ip_dev = ip_refine_device_test{i}(:, 1);

% 	[bool ip_idx] = ismember(ip_dev, ip_test);
% 	ip_refine_device_idx{i} = ip_idx;


%  	if(mod(i, 5000) == 0)
% 		fprintf('%d device processed...\r', i);
% 		fflush(stdout);
% 	end

% end




% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 




% [bool dev_idx] = ismember(device_test, device_array(1,:));
% ip_test = [];
% if(sum(bool) == dev_num)
% 	ip_refine_device_test = cell(dev_num, 1);
% 	ref_idx = device_array(2, dev_idx) - 1;

% 	for i = 1 : dev_num

% 		ip_refine_device_test{i} = refine_list{ref_idx(i)}';

% 		ip_test = [ip_test ; ip_refine_device_test{i}(:, 1)];
% 		if(mod(i, 5000) == 0)
% 			fprintf('%d device processed...\r', i);
% 			fflush(stdout);
% 		end

% 	end

% end

% fprintf('\n');
% ip_test = unique(ip_test);
% save -binary 'new_join/device_test.join' device_test basic_device_test ip_refine_device_test
% save -binary 'new_join/ip_test.join' ip_test;



% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 
% : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : : 






% fid = fopen('raw_data/dev_test_basic.csv');

% dev_num = 61156;
% device = int32(zeros(dev_num, 1));
% basic_device_test = int32(zeros(dev_num, 9));

% head = fgetl(fid);
% curr_idx = 1;
% while(true)
% 	str = fgetl(fid);
% 	if(isnumeric(str))
% 		break;
% 	end

% 	temp = [regexp([str ','], '(-?\d+),', 'tokens'){:}];
% 	temp = [cellfun('str2num', temp, 'UniformOutput', false){:}];

% 	device(curr_idx) = temp(2);
% 	basic_device_test(curr_idx++, :) = temp(3 : end);

% 	if(mod(curr_idx, 1000) == 0)
% 		fprintf('%d device processed...\r', i);
% 		fflush(stdout);
% 	end
% end


% fclose(fid);