function test_sample = test_sample_extract(rf_list, dev_ip, ip_all, ip_ft_array)

	ck_num = length(rf_list);
	test_sample = cell(ck_num, 1);
	% tic;
	for i = 1 : ck_num
		% tic;
		ck_ip = rf_list{i}(1, :);

		[dummy ip_ck_idx] = ismember(dev_ip, rf_list{i}(1, :));
		ip_ck_idx(find(dummy == 0)) = [];

		[dummy ip_idx] = ismember(rf_list{i}(1, ip_ck_idx), ip_all);
		ip_ft = ip_ft_array(ip_idx, :);

		% % tic;
		% % ip_intersect = intersect(ck_ip, dev_ip);
		% ip_intersect = ck_ip(find(1 == ismember(ck_ip, dev_ip)));
		% % toc;
		% [dummy ip_idx] = ismember(ip_intersect, ip_all);
		% % toc;
		% ip_ft = ip_ft_array(ip_idx, :);

		% [dummy ip_ck_idx] = ismember(ip_intersect, rf_list{i}(1, :));
		% ip_ck_idx(find(dummy == 0)) = [];


		% test_sample(i) = [ip_intersect(:) ip_ft rf_list{i}(2 : end, ip_ck_idx)'];
		test_sample(i) = [rf_list{i}(1, ip_ck_idx)(:) ip_ft rf_list{i}(2 : end, ip_ck_idx)'];

	end
	% toc;

end

