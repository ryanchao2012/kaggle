function [prin_period energy n] = sales_hist_fft(standin, store_index)
	period_array = -1;
	energy = -1;
	day = standin.day_week;
	select_idx = find((standin.store_index == store_index) & !(day == 7));
	
	y = double(standin.sale_cust(select_idx, 1));
	m = mean(y);
	y(y == 0) = m;
	n = length(y);
	fft_coeff = fft(y);
	fft_coeff = abs(fft_coeff(2 : ceil(n / 2)));

	% plot(fft_coeff / n);
	
	[energy idx] = sort(fft_coeff, 'descend');
	prin_period = n ./ idx;


end


