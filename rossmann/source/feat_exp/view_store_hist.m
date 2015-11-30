function hist_sales = view_store_hist(standin, store_index, start_date = 0, interval = 942)
	hist_sales = -1;
	% isopen = standin.bool_feat(:, 1);
	day = standin.day_week;
	hday = standin.state_hday;
	select_idx = find((standin.store_index == store_index));
	% select_idx = find(standin.store_index == store_index);
	
	x = double(standin.date_seq(select_idx));
	y = double(standin.sale_cust(select_idx, 1));

	coef = polyfit(x, y, 1);
	u = [x(1) x(end)];
	v = coef(1) * u + coef(2);

	% plot(x, log(y+1));
	plot(x, y, 'b', u, v, 'r');
	
	hist_sales = [x(:) y(:)];
end
