function [samples idx_dev] = dc_basic_filter(device, cookie, device_label, cookie_label, basic_device, basic_cookie, dc_filter_list, pNum)
	
	% feature_size = 9;

	dev_num = length(device);
	seq = randperm(dev_num);

	samples = cell(pNum, 1);


	for i = 1 : pNum
		idx_dev = seq(i);
		% disp(idx_dev);
		idx_ck = find(cookie_label == device_label(idx_dev));
		% disp(length(idx_ck));

		buff_dev = sscanf([basic_device{idx_dev}], '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
		buff_ck = sscanf([basic_cookie{idx_ck}], '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
		
		repNum = length(buff_ck) / 9;
		buff_ck = reshape(buff_ck, 9, repNum)';

		positive = [ones(repNum, 1) * buff_dev buff_ck ones(repNum, 1)];

		neg_ck = dc_filter_list{idx_dev};
		[dummy neg_idx_ck] = ismember(neg_ck, cookie);
		[dummy discard_idx] = ismember(neg_idx_ck, idx_ck);
		neg_idx_ck(dummy == 1) = [];
		% disp(length(neg_idx_ck));

		if(length(neg_idx_ck) > 0)
			buff_nck = sscanf([basic_cookie{neg_idx_ck}], '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
			repNum = length(buff_nck) / 9;
			buff_nck = reshape(buff_nck, 9, repNum)';

			negative = [ones(repNum, 1) * buff_dev buff_nck zeros(repNum, 1)];		
			samples{i} = [positive ; negative];

		else
			samples{i} = positive;
		end

	end


end
