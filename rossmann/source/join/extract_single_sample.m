function [X Y] = extract_single_sample(sample_cell, select_week)
	X = -1;
	Y = -1;
	if(select_week < 3)
		% fprintf('\n  The Selected idx is too small(must larger than 2), extraction skipped ... \n');
		% fflush(stdout);
		return;
	end

	sales = double(sample_cell{1}((select_week - 2) : select_week, :));
	if(sum(sales(:) == -1) > 0)
		% fprintf('\n  The Selected sales data contain NA value, extraction skipped ... \n');
		% fflush(stdout);
		return;
	end

	sale_distr = double(sample_cell{6}((select_week - 2) : select_week, :));
	% dif = sales_range(:, 2) - sales_range(:, 1);
	if(sum(sale_distr(:) <= 0) > 0)
		fprintf('\n  The Selected sales data contain bad distribution, extraction skipped ... \n');
		fflush(stdout);
		return;
	end


	% if(sum(dif(:) <= 0) > 0)
	% 	fprintf('\n  The Selected sales data contain bad distribution, extraction skipped ... \n');
	% 	fflush(stdout);
	% 	return;
	% end
	
	is_open = double(sample_cell{2}(select_week, :));
	is_promo = double(sample_cell{3}(select_week, :));
	is_statHday = double(sample_cell{4}(select_week, :));
	is_schHday = double(sample_cell{5}(select_week, :));

	llsales_feat = [(1 * (sales(1, :) - sale_distr(1, 1)) / sale_distr(1, 2)) (0.0001 * sale_distr(1, :))];

	lsales_feat = [(1 * (sales(2, :) - sale_distr(2, 1)) / sale_distr(2, 2)) (0.0001 * sale_distr(2, :))];


	X = [llsales_feat lsales_feat 1*[is_open is_promo is_statHday is_schHday]];
	Y = [(1 * (sales(3, :) - sale_distr(3, 1)) / sale_distr(3, 2)) (0.0001 * sale_distr(3, :))];

	% if(sum(X < 0) > 0 || sum(Y < 0) > 0)
	% 	fprintf('\n  Something went wrong, extraction skipped ... \n');
	% 	fflush(stdout);
	% 	X = -1;
	% 	Y = -1;
	% 	return;
	% end


end


