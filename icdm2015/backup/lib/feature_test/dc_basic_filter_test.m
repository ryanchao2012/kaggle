clc;
close all;


if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end


if(!exist('cookie', 'var'))   % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end


if(!exist('cookie_label', 'var') || !exist('device_label', 'var'))   % cookie_label device_label
	load 'joint/label.joint'; 
end


if(!exist('dc_filter_list', 'var'))   % dc_filter_list
	load 'joint/filter.joint'; 
end

if(!exist('cookie_c1_df', 'var'))   % device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1_id cookie_c2_id cookie_c1_df cookie_c2_df
	load 'joint/c1c2_pair.joint'; 
end


fprintf('... Env prepared ...\r\n');
fflush(stdout);



num = 1;

samples = cell(num, 1);


[samples idx_dev] = dc_basic_filter(device, cookie, device_label, cookie_label, basic_device, basic_cookie, dc_filter_list, num);


buff = samples{1}(:,[5 6 14 15 19])

ck_c1_df = cookie_c1_df;
ck_c1_df = ck_c1_df/length(cookie);
ck_c2_df = cookie_c2_df;
ck_c2_df = ck_c2_df/length(cookie);


dev_c1 = buff(1, 1);
dev_c2 = buff(1, 2);
ck_c1 = buff(:, 3);
ck_c2 = buff(:, 4);

if(dev_c1 != -1)
	dev_c1_pairs = dc_c1_pairs{find(dev_c1 == device_c1_id)};
	c1_idx = find(ck_c1 != -1);
	[dummy j] = ismember(ck_c1(c1_idx), cookie_c1_id);

	n = length(ck_c1);
	c1_idf = -1 * ones(n, 1);
	c1_idf(c1_idx) = ck_c1_df(j);

	c1_tf = zeros(n, 1);
	for i = 1 : n
		c1_tf(i) = sum(dev_c1_pairs == ck_c1(i));
	end

	c1_tf = c1_tf / length(dev_c1_pairs);
	c1_idf = c1_idf(:);
	c1_tf = c1_tf(:);

	c1_score = c1_tf./c1_idf;
	% disp([score buff(c1_idx, 5)]);
end


if(dev_c2 != -1)
	dev_c2_pairs = dc_c2_pairs{find(dev_c2 == device_c2_id)};
	c2_idx = find(ck_c2 != -1);
	[dummy j] = ismember(ck_c2(c2_idx), cookie_c2_id);

	n = length(ck_c2);
	c2_idf = -1 * ones(n, 1);
	c2_idf(c2_idx) = ck_c2_df(j);

	c2_tf = zeros(n, 1);
	for i = 1 : n
		c2_tf(i) = sum(dev_c2_pairs == ck_c2(i));
	end

	c2_tf = c2_tf / length(dev_c2_pairs);
	c2_idf = c2_idf(:);
	c2_tf = c2_tf(:);

	c2_score = c2_tf./c2_idf;
	% disp([score buff(c2_idx, 5)]);
end


if(dev_c2 != -1 && dev_c1 != -1)
	idx = intersect(c2_idx, c1_idx);
	c1_score = c1_score(idx);
	c1_score = c1_score + ones(size(c1_score));
	c2_score = c2_score(idx);
	c2_score = c2_score + ones(size(c2_score));
	disp([c1_score c2_score c1_score.*c2_score buff(idx, 5)]);
end








