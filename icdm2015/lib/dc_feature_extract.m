clc;
% clear;
close all;


load 'new_join/c1c2_pair.join';  % device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1 cookie_c2

if(!exist('ip_light', 'var'))  % ip_light feature_ip_light shared_cookies_light shared_num_light
	load 'new_join/ip_light_train.join';
end


if(!exist('device', 'var'))  % device ip_refine_device basic_device ip_refine_device_idx cx_index_device
	load 'new_join/device_train.join';
end


if(!exist('cookie', 'var'))   % cookie ip_refine_cookie basic_cookie cx_index_cookie
	load 'new_join/cookie_train.join';
end


if(!exist('dc_filter_light_train', 'var'))   % dc_filter_light_train
	load 'new_join/dc_filter_light_train.join'; 
end

if(!exist('member', 'var'))
	load 'new_join/handle.join';  % member handle void_idx
end


if(!exist('category_tf_device', 'var'))
	load 'new_join/category_refine_devie.join'; % category_tf_device category_df_device
end


if(!exist('category_tf_cookie', 'var'))
	load 'new_join/category_refine_cookie.join'; % category_tf_cookie category_df_cookie
end


if(exist('training_data/training_set.join'))
	load 'training_data/training_set.join';
else
	training_set = double([]);
	curr_index = 1;
	% skip_num = 0;
	save -binary 'training_data/training_set.join' curr_index training_set;
end

% % warning('off', 'Octave:broadcast');
fprintf('... Env prepared ...\n');
fflush(stdout);


h_num = length(handle);
ck_train_num = length(cookie);

ck_c1_num = rows(cookie_c1);
ck_c1_df_mean = mean(cookie_c1(:, 2));

ck_c2_num = rows(cookie_c2);
ck_c2_df_mean = mean(cookie_c2(:, 2));


batch_buffer = [];

s = curr_index;
e = curr_index + 10000;
if(e > h_num)
	e = h_num;
end

% e = randperm(h_num)(1)
% e = 98477;
% e = 114627;
% e = 96035
tic;
for i = s : e

	m_t = member{i};

	ck_temp = m_t(m_t(:, 2) == 1, [1 3]);
	bool = (ck_temp(:, 2) != -1);
	if(sum(bool) == 0)
		fprintf('\n... Empty pos-ck(handle idx: %d) ... \n', i);
		fflush(stdout);
		continue;
	end

	ck_pos = ck_temp(bool, 1);

	dev_num = sum(m_t(:, 2) == 0);

	for j = 1 : dev_num

		dev = m_t(j, 1);


		dev_idx = m_t(j, 3);
		ip_dev_ref = ip_refine_device{dev_idx};

		ip_idx = ip_refine_device_idx{dev_idx};

		if(sum(ip_idx) == 0)
			fprintf('\n... Empty dev-ip info(handle/device idx: %d, %d) ... \n', i, j);
			fflush(stdout);
			% skip_num++;
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

		feat_ip_agg = double(feature_ip_light(ip_idx, :));
		feat_ip_agg = feat_ip_agg ./ ( ones(rows(feat_ip_agg), 1) * (max(feat_ip_agg) + 0.1));
		feat_ip_agg = log10(feat_ip_agg * 10 + 1);

		c1c2_dev_idx = cx_index_device(dev_idx, :);
	

		ck_cand = dc_filter_light_train{dev_idx};
		ck_num = columns(ck_cand);
		% ck_rep_num = ck_cand(2, :);
		% max(ck_rep_num)	
		ck_idx = ck_cand(3, :);
		ck_cand = ck_cand(1, :);
		ip_ck_ref = ip_refine_cookie(ck_idx, :); % this is a cell

		% c1c2_ck = basic_cookie(ck_idx, [5 6]);
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
		% 	% c1_df = c1_df / ck_train_num;

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



		% cat_tf_dev = double(category_tf_device(dev_idx, :)) / 255;
		% cat_df_dev = double(category_df_device(dev_idx, :)) / 255;

		% cat_tf_ck = double(category_tf_cookie(ck_idx, :)) / 255;
		% cat_df_ck = double(category_df_cookie(ck_idx, :)) / 255;

		% if(sum(cat_df_dev) != 0)
		% 	cat_tf_dev = cat_tf_dev ./ cat_df_dev;
		% end
		
		% a = sum(cat_df_ck, 2);
		% b = a != 0;

		% cat_tf_ck(b, :) = cat_tf_ck(b, :) ./ cat_df_ck(b, :);


		% cat_tf_dev = cat_tf_dev / (cat_tf_dev * cat_tf_dev')^0.5;
		% cat_tf_ck(b, :) = cat_tf_ck(b, :) ./ ((sum(cat_tf_ck(b, :) .* cat_tf_ck(b, :), 2).^0.5) * ones(1, 443));

		% cat_feat = cat_tf_ck * cat_tf_dev';
		% if(sum(cat_tf_dev) > 0)
		% 	cat_tf_dot = cat_tf_ck * cat_tf_dev';
		% else
		% 	cat_tf_dot = -1 * ones(rows(cat_tf_ck), 1);
		% end


		% if(sum(cat_df_dev) > 0)
		% 	cat_df_dot = cat_df_ck * cat_df_dev';
		% else
		% 	cat_df_dot = -1 * ones(rows(cat_df_ck), 1);
		% end


		% cat_feat = [cat_tf_dot cat_df_dot];


		[bool ck_pos_idx] = ismember(ck_pos, ck_cand);
		ck_pos_idx = ck_pos_idx(bool);
		% dev_bsc = double(basic_device(dev_idx, [4 7 8 9]));
		% ck_bsc = [c1_score(:) c2_score(:) double(basic_cookie(ck_idx, [4 7 8 9]))];


		[ip_feature_pos ip_feature_neg] = dc_filter(ip_dev_ref, ip_ck_ref, ...
													ck_pos_idx, feat_ip_agg, ip_shared_num);

		% ip_feature_pos
		% if(length(ip_feature_neg) > 5)
		% 	ip_feature_neg(1:5)
		% else
		% 	ip_feature_neg
		% end
		

		if(isempty(ip_feature_pos) && isempty(ip_feature_neg))
			continue;
		end

		temp1 = [ip_feature_pos ip_feature_neg];
		temp2 = cellfun('mean', temp1, {1}, 'UniformOutput', false);
		temp2 = [temp2{:}];
		temp2 = reshape(temp2, 18, length(temp2)/18)';
		each_len = cellfun('rows', temp1)(:);


		temp2(:, end + 1) = each_len;
		% % % % % % % % % % % % % % % 
		% temp2 = temp2 + 1;
		% mu = mean(temp2, 1);
		% len = length(each_len);
		% MU = (ones(len, 1) * mu);
		% temp3 = temp2 ./ MU;
		% % % % % % % % % % % % % % % 

		lab = [ones(length(ip_feature_pos), 1); zeros(length(ip_feature_neg), 1)];

		batch_buffer = [batch_buffer ; [temp2 lab]];

	end

	curr_index = i + 1;

	if(mod(i, 50) == 0)
		fprintf('... training sample recorded from the %d handle ...\r', i);
		fflush(stdout);
		training_set = [training_set ; batch_buffer];
		batch_buffer = [];
	end


end


training_set = [training_set ; batch_buffer];

fprintf('\n');
toc;


save -binary 'training_data/training_set.join' curr_index training_set;














