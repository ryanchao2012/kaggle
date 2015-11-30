function [ip_feature_pos ip_feature_neg] = dc_filter(ip_dev_ref, ip_ck_ref, ...
													ck_pos_idx, feature_ip_agg, shared_num)

	ip_feature_pos = {};
	ip_feature_neg = {};
	pos_num = length(ck_pos_idx);
	ck_num = rows(ip_ck_ref);

	if(pos_num >= ck_num)
		return;
	end

	% [ck_num] must be larger than [pos_num]
	% ip_feature_pos = cell(pos_num, 1);
	% ip_feature_neg = cell(ck_num - pos_num, 1);
	pos_idx = 1;
	neg_idx = 1;

	ip_dev = ip_dev_ref(:, 1);


	for i = 1 : ck_num
		ip_ck = ip_ck_ref{i}(:, 1);

		[bool inter_idx] = ismember(ip_dev, ip_ck);

		if(sum(bool) == 0)
			continue;
		end

		ip_ck_fea = double(ip_ck_ref{i}(inter_idx(bool), 2 : end));
		ip_ck_fea = ip_ck_fea ./ ( ones(rows(ip_ck_fea), 1) * (max(ip_ck_fea) + 0.1));
		ip_ck_fea = log10(ip_ck_fea * 10 + 1);


		ip_dev_fea = ip_dev_ref(bool, 2 : end);

		ipagg_fea = feature_ip_agg(bool, :);
		seen_num = shared_num(bool)(:);
		A = ones(size(seen_num));
		if(ismember(i, ck_pos_idx))
			% ip_feature_pos{pos_idx++} = [cat_feature(i)];
			% ip_feature_pos{pos_idx++} = [A*[ck_bsc(i, :) dev_bsc] seen_num ipagg_fea ip_ck_fea ip_dev_fea];
			ip_feature_pos{pos_idx++} = [seen_num ipagg_fea ip_ck_fea ip_dev_fea];
		else
			% ip_feature_neg{neg_idx++} = [cat_feature(i)];
			% ip_feature_neg{neg_idx++} = [A*[ck_bsc(i, :) dev_bsc] seen_num ipagg_fea ip_ck_fea ip_dev_fea];
			ip_feature_neg{neg_idx++} = [seen_num ipagg_fea ip_ck_fea ip_dev_fea];
		end


	end


end





