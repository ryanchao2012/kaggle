function [prop_dev prop_pos_ck prop_neg_ck ip_feature_pos ip_feature_neg] = dc_propxip_filter(device, cookie, device_label, cookie_label, ...
																		prop_member_device, prop_member_cookie, ...
																		prop_feature_device, prop_feature_cookie, ...
																		ip_member_device, ip_member_cookie, ip_feature_cookie, ...
																		ip, feature_ip, dc_filter_list, rand_idx)

	prop_num_limit = 1;
	prop_dev = [];
	prop_pos_ck = {};
	prop_neg_ck = {};
	ip_feature_pos = {};
	ip_feature_neg = {};

	% dev_num = length(device);
	% seq = randperm(dev_num);

	% samples = cell(pNum, 1);


	idx_dev = rand_idx;
	disp(idx_dev);
	idx_ck = find(cookie_label == device_label(idx_dev));
	disp(idx_ck);
	buff_dev = prop_member_device(idx_dev);
	buff_pos_ck = prop_member_cookie(idx_ck);

	if(length(buff_dev{1}) > prop_num_limit)
		[dominant d_idx] = sort(prop_feature_device{idx_dev}, 'descend');
		prop_dev = buff_dev{1}(d_idx(1 : prop_num_limit));
	else
		prop_dev = buff_dev{1};
	end


	ip_dev = ip_member_device{idx_dev};

	for j = 1 : length(idx_ck)
		if(length(buff_pos_ck{j}) > prop_num_limit)
			[dominant d_idx] = sort(prop_feature_cookie{idx_ck(j)}, 'descend');
			prop_pos_ck(j) = buff_pos_ck{j}(d_idx(1 : prop_num_limit));
		else
			prop_pos_ck(j) = buff_pos_ck{j};
		end
		ip_ck = intersect(ip_dev, ip_member_cookie{idx_ck(j)});
		[dummy ip_ck_idx] = ismember(ip_ck, ip_member_cookie{idx_ck(j)});
		fea = str2num(ip_feature_cookie{idx_ck(j)}(ip_ck_idx, :));
		ip_pos = ip_member_cookie{idx_ck(j)}(ip_ck_idx)(:);
		[dummy ip_idx] = ismember(ip_pos, ip);
		ip_feature_pos(j) = [ip_pos feature_ip(ip_idx, :) fea];
	end


	neg_ck = dc_filter_list{idx_dev};
	[dummy neg_idx_ck] = ismember(neg_ck, cookie);
	[dummy discard_idx] = ismember(neg_idx_ck, idx_ck);
	neg_idx_ck(dummy == 1) = [];
	disp(neg_idx_ck);
	if(length(neg_idx_ck) > 0)
		buff_neg_ck = prop_member_cookie(neg_idx_ck);

		for j = 1 : length(neg_idx_ck)
			if(length(buff_neg_ck{j}) > prop_num_limit)
				[dominant d_idx] = sort(prop_feature_cookie{neg_idx_ck(j)}, 'descend');
				prop_neg_ck(j) = buff_neg_ck{j}(d_idx(1 : prop_num_limit));
			else
				prop_neg_ck(j) = buff_neg_ck{j};
			end

			ip_ck = intersect(ip_dev, ip_member_cookie{neg_idx_ck(j)});
			[dummy ip_neg_ck_idx] = ismember(ip_ck, ip_member_cookie{neg_idx_ck(j)});
			fea = str2num(ip_feature_cookie{neg_idx_ck(j)}(ip_neg_ck_idx, :));
			ip_neg = ip_member_cookie{neg_idx_ck(j)}(ip_neg_ck_idx)(:);
			[dummy ip_idx] = ismember(ip_neg, ip);
			ip_feature_neg(j) = [ip_neg feature_ip(ip_idx, :) fea];
		end
	
	end











end