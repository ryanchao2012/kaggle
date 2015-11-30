function [ip_feature candidate_idx] = test_set_filter(ip_dev_ref, ip_ck_ref, ...
										feature_ip_agg, shared_num)
	ip_feature = {};
	candidate_idx = [];
	ck_num = rows(ip_ck_ref);


	ip_dev = ip_dev_ref(:, 1);

	feat_num = 1;

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

		candidate_idx = [candidate_idx i];
		ip_feature{feat_num++} = [seen_num ipagg_fea ip_ck_fea ip_dev_fea];
		% ip_feature{feat_num++} = [A*[ck_bsc(i, :) dev_bsc] seen_num ipagg_fea ip_ck_fea ip_dev_fea];


	end


end





