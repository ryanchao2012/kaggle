clc;
% clear;
close all;


load 'joint/c1c2_pair.joint';  % device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1_id cookie_c2_id cookie_c1_df cookie_c2_df

if(!exist('ip_light', 'var'))  % ip_light feature_ip_light shared_cookies
	load 'joint/ip_light.joint';
end
% clear shared_cookies;

if(!exist('device', 'var'))  % device ip_member_device ip_feature_device basic_device
	load 'joint/device_light.joint';
end


if(!exist('cookie', 'var'))   % cookie ip_refine_cookie basic_cookie
	load 'joint/cookie_light.joint';
end


if(!exist('dc_filter_new_list', 'var'))   % dc_filter_new_list
	load 'joint/filter_new.joint'; 
end

if(!exist('member', 'var'))
	load 'joint/handle.joint';  % member handle feature_basic
end
clear feature_basic;

if(exist('training_data/training_set_alt.join'))
	load 'training_data/training_set_alt.join';
else
	training_set_alt = double([]);
	curr_index = 1;
	skip_num = 0;
	save -binary 'training_data/training_set_alt.join' curr_index training_set_alt skip_num;
end

warning('off', 'Octave:broadcast');
fprintf('... Env prepared ...\n');
fflush(stdout);

h_num = length(handle);
batch_buffer = [];

s = curr_index;
e = curr_index + 500;
if(e > h_num)
	e = h_num;
end

% e = randperm(h_num)(1)
% e = 98477;
% e = 114627;
tic;
for i = s : e

	m_t = member{i};
	ck = m_t(m_t(:, 2) == 1, 1);
	dev_num = sum(m_t(:, 2) == 0);

	for j = 1 : dev_num
		dev = m_t(j, 1);


		dev_idx = find(dev == device);
		bas_dev = basic_device(dev_idx, 5 : 6);


		ip_dev_ref = [ip_member_device{dev_idx}(:) str2num(ip_feature_device{dev_idx})];

		[bool ip_idx] = ismember(ip_dev_ref(:, 1), ip_light);
		shared_num = cellfun('length', shared_cookies(ip_idx(bool)));
		ip_cand_idx = find(shared_num <= 50);

		if(isempty(ip_cand_idx))
			skip_num++;
			continue;
		end

		c1_dev_idx = find(bas_dev(1) == device_c1_id);
		c2_dev_idx = find(bas_dev(2) == device_c2_id);

		ip_dev_ref = ip_dev_ref(ip_cand_idx, :);
		shared_num= shared_num(ip_cand_idx);
		feature_ip_agg = feature_ip_light(ip_idx(bool)(ip_cand_idx), :);

		ck_cand = unique(dc_filter_new_list{dev_idx});
		ck_num = length(ck_cand);
		[bool ck_idx] =ismember(ck_cand, cookie);
		ip_ck_ref = ip_refine_cookie(ck_idx, :);
		



		bas_ck = basic_cookie(ck_idx, 5 : 6);
		

		% size(bas_ck)

		

		if(!isempty(c1_dev_idx))
			c1_known_idx = bas_ck(:, 1) != -1;
			c1_tf = ones(ck_num, 1) / length(cookie_c1_id);
			c1_df = ones(ck_num, 1) * mean(cookie_c1_df);
			c1_tf(c1_known_idx) = sum(bas_ck(c1_known_idx, 1) == ones(sum(c1_known_idx), 1) * dc_c1_pairs{c1_dev_idx}, 2);
			c1_tf = c1_tf / length(dc_c1_pairs{c1_dev_idx});

			[bool c1_idx] = ismember(bas_ck(c1_known_idx, 1), cookie_c1_id);
			c1_df(c1_known_idx) = cookie_c1_df(c1_idx);
			c1_df = c1_df / length(cookie);
			c1_score = c1_tf ./ c1_df;
		else
			c1_score = -1 * ones(ck_num, 1);

		end


		if(!isempty(c2_dev_idx))
			c2_known_idx = bas_ck(:, 2) != -1;
			c2_tf = ones(ck_num, 1) / length(cookie_c2_id);
			c2_df = ones(ck_num, 1) * mean(cookie_c2_df);
			c2_tf(c2_known_idx) = sum(bas_ck(c2_known_idx, 2) == ones(sum(c2_known_idx), 1) * dc_c2_pairs{c2_dev_idx}, 2);
			c2_tf = c2_tf / length(dc_c2_pairs{c2_dev_idx});

			[bool c2_idx] = ismember(bas_ck(c2_known_idx, 1), cookie_c2_id);
			c2_df(c2_known_idx) = cookie_c2_df(c2_idx);
			c2_df = c2_df / length(cookie);
			c2_score = c2_tf ./ c2_df;
		else
			c2_score = -1 * ones(ck_num, 1);
		end
		

		[bool ck_pos_idx] = ismember(ck, ck_cand);
		ck_pos_idx = ck_pos_idx(bool);
		dev_bsc = double(basic_device(dev_idx, [4 7 8 9]));
		ck_bsc = double([c1_score(:) c2_score(:) basic_cookie(ck_idx, [4 7 8 9])]);


		[ip_feature_pos ip_feature_neg] = dc_ip_filter_new(ip_dev_ref, ip_ck_ref, dev_bsc, ck_bsc, ...
															ck_pos_idx, feature_ip_agg, shared_num);

		% ip_feature_pos
		% if(length(ip_feature_neg) > 5)
		% 	ip_feature_neg(1:5)
		% else
		% 	ip_feature_neg
		% end
		

		if(isempty(ip_feature_pos) || isempty(ip_feature_neg))
			continue;
		end

		temp1 = [ip_feature_pos ip_feature_neg];
		temp2 = cellfun('mean', temp1, {1}, 'UniformOutput', false);
		temp2 = [temp2{:}];
		temp2 = reshape(temp2, 28, length(temp2)/28)';
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
		training_set_alt = [training_set_alt ; batch_buffer];
		batch_buffer = [];
	end


end


training_set_alt = [training_set_alt ; batch_buffer];

fprintf('\n');
toc;


save -binary 'training_data/training_set_alt.join' curr_index training_set_alt skip_num;














