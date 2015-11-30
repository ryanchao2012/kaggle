function er = sales_error(O, Y)
	temp = ones(1, 7);
	predict_distr = O(:, 8 : 9) * 10000;
	actual_distr = Y(:, 8 : 9) * 10000;

	predict_sales = (O(:, 1 : 7) .* (predict_distr(:, 2) * temp)) + (predict_distr(:, 1) * temp);
	actual_sales = (Y(:, 1 : 7) .* (actual_distr(:, 2) * temp)) + (actual_distr(:, 1) * temp);

	predict_sales(:, 6) = [];
	actual_sales(:, 6) = [];

	invalid_idx = actual_sales <= 10;
	actual_sales(invalid_idx) = 1;
	predict_sales(invalid_idx) = 1;


	er = (  mean(  (  (predict_sales(:) - actual_sales(:)) ./ actual_sales(:)  ).^2  )  )^0.5;

end