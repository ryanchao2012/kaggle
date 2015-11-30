clc;
close all;

if(!exist('test_device', 'var'))  % test_device_ip_member test_device test_device_cookie_list
	load 'joint/test_device.joint';
end


if(!exist('cookie_array', 'var'))  % device_array cookie_array
	load 'refine/id_in_idxip.stat';
end


if(!exist('test_ip_all', 'var'))  % test_ip_all test_ip_feature test_ip_cookie_list
	load 'joint/test_ip.joint';
end


if(!exist('refine_list', 'var'))  % refine_list
	load 'refine/ip_in_idxip.ref';
end


test_dev_num = length(test_device);

if(exist('training_data/test_set_raw_7.join'))
	load 'training_data/test_set_raw_7.join';
else
	test_set_raw_7 = cell(1156, 1);
	curr_index = 60001;
	save -binary 'training_data/test_set_raw_7.join' curr_index test_set_raw_7;
end


s_ck_arr = unique([test_device_cookie_list{:}]);
[dummy ck_arr_idx] = ismember(s_ck_arr, cookie_array(1, :));
sub_cookie_array = cookie_array(:, ck_arr_idx);
clear s_ck_arr ck_arr_idx dummy;


fprintf('... Env prepared ...\n');
fflush(stdout);

s = curr_index;
e = s + 10000 - 1;

if(e > test_dev_num)
	e = test_dev_num;
end

tic;

for i = s : e

	ck = test_device_cookie_list{i};
	[dummy ck_idx] = ismember(ck, sub_cookie_array(1, :));
	rf_idx = sub_cookie_array(2, ck_idx) - 1;

	[dummy ip_idx] = ismember(test_device_ip_member{i}, test_ip_all);
	test_set_raw_7{i - 60000} = test_sample_extract(refine_list(rf_idx), test_device_ip_member{i}, ...
										            test_ip_all(ip_idx), test_ip_feature(ip_idx, :));

	curr_index++;

	if(mod(i, 500) == 0)
		toc;
		fprintf('%d test set(raw) extracted...\r', i);
		fflush(stdout);
		tic;
	end

end

toc;
curr_index
% _temp(1:5)
% test_set_raw_7{1}(1:5)
fprintf('\n');



save -binary 'training_data/test_set_raw_7.join' curr_index test_set_raw_7;
clear curr_index test_set_raw_7;



