clc;
close all;


load 'new_join/c1c2_pair.join';  % device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1 cookie_c2

if(!exist('ip_test_light', 'var'))  % ip_test_light feature_ip_test_light shared_cookies_light shared_num_light
	load 'new_join/ip_test_light.join';
end


if(!exist('device_test', 'var'))  % device_test ip_refine_device_test basic_device_test ip_refine_device_idx cx_index_device
	load 'new_join/device_test.join';
end


if(!exist('cookie_test', 'var'))   % cookie_test ip_refine_cookie_test basic_cookie_test cx_index_cookie
	load 'new_join/cookie_test.join';
end


if(!exist('dc_filter_light_test', 'var'))   % dc_filter_light_test
	load 'new_join/dc_filter_light_test.join'; 
end


fprintf('... Env prepared ...\n');
fflush(stdout);

dev_num = length(device_test);
ck_num = length(cookie_test);

ck_c1_num = rows(cookie_c1);
ck_c1_df_mean = mean(cookie_c1(:, 2));

ck_c2_num = rows(cookie_c2);
ck_c2_df_mean = mean(cookie_c2(:, 2));


test_set = cell(dev_num, 1);
candidate_set = cell(dev_num, 1);


for i = 1 : dev_num

	ip_dev_ref = ip_refine_device_test{i};

	ip_idx = ip_refine_device_idx{i};

	if(sum(ip_idx) == 0)
		fprintf('\n... Empty dev-ip info(device idx: %d) ... \n', i);
		fflush(stdout);
		continue;
	end

	bool = (ip_idx != 0);
	ip_idx = ip_idx(bool);

	ip_dev_ref = double(ip_dev_ref(bool, :));
	ip_dev_ref(:, 2 : end) = ip_dev_ref(:, 2 : end) ./ ( ones(rows(ip_dev_ref), 1) * (max(ip_dev_ref(:, 2 : end)) + 0.1));
	ip_dev_ref(:, 2 : end) = log10(ip_dev_ref(:, 2 : end) * 10 + 1);

	ip_shared_num = double(shared_num_light(ip_idx));
	ip_shared_num = ip_shared_num / (max(ip_shared_num) + 0.1);
	ip_shared_num = log10(ip_shared_num * 10 + 1);

	feat_ip_agg = double(feature_ip_test_light(ip_idx, :));
	feat_ip_agg = feat_ip_agg ./ ( ones(rows(feat_ip_agg), 1) * (max(feat_ip_agg) + 0.1));
	feat_ip_agg = log10(feat_ip_agg * 10 + 1);


	% c1c2_dev_idx = cx_index_device(i, :);
	

	ck_cand = dc_filter_light_test{i};
	ck_num = columns(ck_cand);

	ck_idx = ck_cand(3, :);
	ck_cand = ck_cand(1, :);
	ip_ck_ref = ip_refine_cookie_test(ck_idx, :); % this is a cell

	% c1c2_ck = basic_cookie_test(ck_idx, [5 6]);
	% c1c2_ck_idx = cx_index_cookie(ck_idx, :);
		
		
	% if(c1c2_dev_idx(1) > 0)
	% 	c1_known_idx = (c1c2_ck_idx(:, 1) != 0);
	% 	c1_tf = ones(ck_num, 1) / ck_c1_num;			
	% 	c1_tf(c1_known_idx) = 0;
	% 	[bool c1_idx] = ismember(c1c2_ck(:, 1), dc_c1_pairs{c1c2_dev_idx(1)}(1, :));
	% 	if(sum(bool) > 0)
	% 		c1_tf(bool) = dc_c1_pairs{c1c2_dev_idx(1)}(2, c1_idx(bool));
	% 	end
	% 	c1_tf = c1_tf / sum(dc_c1_pairs{c1c2_dev_idx(1)}(2, :));

	% 	c1_df = ones(ck_num, 1) * ck_c1_df_mean;
	% 	if(sum(c1_known_idx) > 0)
	% 		c1_df(c1_known_idx) = cookie_c1(c1c2_ck_idx(c1_known_idx, 1), 2);
	% 	end
	% 		% c1_df = c1_df / ck_train_num;

	% 	c1_score = c1_tf(:) ./ c1_df(:);
	% 	scale = max(c1_score);
	% 	if(scale > 0)
	% 		c1_score = log10(1 + 10 * (c1_score / scale));
	% 	end
	% else
	% 	c1_score = -1 * ones(ck_num, 1);

	% end


	% if(c1c2_dev_idx(2) > 0)
	% 	c2_known_idx = (c1c2_ck_idx(:, 2) != 0);
	% 	c2_tf = ones(ck_num, 1) / ck_c2_num;			
	% 	c2_tf(c2_known_idx) = 0;
	% 	[bool c2_idx] = ismember(c1c2_ck(:, 2), dc_c2_pairs{c1c2_dev_idx(2)}(1, :));
	% 	if(sum(bool) > 0)
	% 		c2_tf(bool) = dc_c2_pairs{c1c2_dev_idx(2)}(2, c2_idx(bool));
	% 	end
	% 	c2_tf = c2_tf / sum(dc_c2_pairs{c1c2_dev_idx(2)}(2, :));

	% 	c2_df = ones(ck_num, 1) * ck_c2_df_mean;
	% 	if(sum(c2_known_idx) > 0)
	% 		c2_df(c2_known_idx) = cookie_c2(c1c2_ck_idx(c2_known_idx, 2), 2);
	% 	end
	% 	% c2_df = c2_df / ck_train_num;
	% 	c2_score = c2_tf(:) ./ c2_df(:);
	% 	scale = max(c2_score);
	% 	if(scale > 0)
	% 		c2_score = log10(1 + 10 * (c2_score / scale));
	% 	end
	% else
	% 	c2_score = -1 * ones(ck_num, 1);
	% end


	% dev_bsc = double(basic_device_test(i, [4 7 8 9]));
	% ck_bsc = [c1_score(:) c2_score(:) double(basic_cookie_test(ck_idx, [4 7 8 9]))];


	[ip_feature cand_idx] = test_set_filter(ip_dev_ref, ip_ck_ref, ...
								  feat_ip_agg, ip_shared_num);


	if(isempty(ip_feature))
		continue;
	end

	temp2 = cellfun('mean', ip_feature, {1}, 'UniformOutput', false);
	temp2 = [temp2{:}];
	temp2 = reshape(temp2, 18, length(temp2)/18)';
	each_len = cellfun('rows', ip_feature)(:);

	temp2(:, end + 1) = each_len;
	test_set{i} = temp2;

	candidate_set{i} = ck_cand(cand_idx);

	if(mod(i, 50) == 0)
		fprintf('... %d test sample recorded ...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');



save -binary 'test_set/test_set.join' test_set;
save -binary 'test_set/candidate_set.join' candidate_set;



