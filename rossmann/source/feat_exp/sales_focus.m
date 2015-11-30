function sales_focus(standin, store_index)
	date_base = double(standin.date_base);
	selected_idx = (standin.store_index == store_index);

	if(sum(selected_idx) == 0)
		return;
	end
	sales = double(standin.sale_cust(selected_idx, 1));
	date_seq = double(standin.date_seq(selected_idx));
	is_promo = standin.bool_feat(selected_idx, 2);
	is_sch_hday = standin.bool_feat(selected_idx, 3);
	is_st_hday = standin.state_hday(selected_idx) ~= 0;

	h1 = datenum([2015 1 1]) - date_base;
	h1_idx = find(date_seq == h1);
	h2 = datenum([2014 1 1]) - date_base;
	h2_idx = find(date_seq == h2);
	h3 = datenum([2013 1 1]) - date_base;
	h3_idx = find(date_seq == h3);

	yr1 = 1 : h1_idx;
	yr2 = h1_idx + 1 : h2_idx;
	yr3 = h2_idx + 1 : h3_idx;

	plot(date_seq(yr1) - h1 + 2, sales(yr1), 'r', ...
		 date_seq(yr2) - h2 + 1, sales(yr2), 'b', ...
		 date_seq(yr3) - h3, sales(yr3), 'k--');
	hold on;

	plot((date_seq(yr1(is_promo(yr1))) - h1 + 2), sales(yr1(is_promo(yr1))), 'r.', ...
		 (date_seq(yr2(is_promo(yr2))) - h2 + 1), sales(yr2(is_promo(yr2))), 'b.', ...
		 date_seq(yr3(is_promo(yr3))) - h3, sales(yr3(is_promo(yr3))), 'k.');

	plot((date_seq(yr1(is_sch_hday(yr1))) - h1 + 2), sales(yr1(is_sch_hday(yr1))), 'ro', ...
		 (date_seq(yr2(is_sch_hday(yr2))) - h2 + 1), sales(yr2(is_sch_hday(yr2))), 'bo', ...
		 date_seq(yr3(is_sch_hday(yr3))) - h3, sales(yr3(is_sch_hday(yr3))), 'ko');

	plot((date_seq(yr1(is_st_hday(yr1))) - h1 + 2), sales(yr1(is_st_hday(yr1))), 'rx', ...
		 (date_seq(yr2(is_st_hday(yr2))) - h2 + 1), sales(yr2(is_st_hday(yr2))), 'bx', ...
		 (date_seq(yr3(is_st_hday(yr3))) - h3), sales(yr3(is_st_hday(yr3))), 'kx');


	title(['store index = ' num2str(store_index)]);
	legend('2015', '2014', '2013');
	grid on;
	hold off;
end