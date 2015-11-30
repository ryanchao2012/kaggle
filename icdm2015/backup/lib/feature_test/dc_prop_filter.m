function [prop_dev prop_pos_ck prop_neg_ck] = dc_prop_filter(device, cookie, device_label, cookie_label, ...
															 prop_member_device, prop_member_cookie, ...
															 prop_feature_device, prop_feature_cookie, ...
															 dc_filter_list, pNum)
	
	limit = 1;
	prop_dev = [];
	prop_pos_ck = {};
	prop_neg_ck = {};

	dev_num = length(device);
	seq = randperm(dev_num);

	samples = cell(pNum, 1);


	for i = 1 : pNum
		idx_dev = seq(i);
		disp(idx_dev);
		idx_ck = find(cookie_label == device_label(idx_dev));

		buff_dev = prop_member_device(idx_dev);
		buff_pos_ck = prop_member_cookie(idx_ck);

		if(length(buff_dev{1}) > limit)
			[dominant d_idx] = sort(prop_feature_device{idx_dev}, 'descend');
			prop_dev = buff_dev{1}(d_idx(1 : limit));
		else
			prop_dev = buff_dev{1};
		end


		for j = 1 : length(idx_ck)
			if(length(buff_pos_ck{j}) > limit)
				[dominant d_idx] = sort(prop_feature_cookie{idx_ck(j)}, 'descend');
				prop_pos_ck(j) = buff_pos_ck{j}(d_idx(1 : limit));
			else
				prop_pos_ck(j) = buff_pos_ck{j};
			end
		end


		neg_ck = dc_filter_list{idx_dev};
		[dummy neg_idx_ck] = ismember(neg_ck, cookie);
		[dummy discard_idx] = ismember(neg_idx_ck, idx_ck);
		neg_idx_ck(dummy == 1) = [];

		if(length(neg_idx_ck) > 0)
			buff_neg_ck = prop_member_cookie(neg_idx_ck);

			for j = 1 : length(neg_idx_ck)
				if(length(buff_neg_ck{j}) > limit)
					[dominant d_idx] = sort(prop_feature_cookie{neg_idx_ck(j)}, 'descend');
					prop_neg_ck(j) = buff_neg_ck{j}(d_idx(1 : limit));
				else
					prop_neg_ck(j) = buff_neg_ck{j};
				end
			end

		end

	end


end
