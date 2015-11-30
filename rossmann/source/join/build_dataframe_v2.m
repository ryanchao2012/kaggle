clc; clear; close all;

if(!exist('train', 'var'))
	load 'data_frame/train.df';  % train
end
  % [1,1] = store_index
  % [2,1] = date_seq
  % [3,1] = day_week
  % [4,1] = sale_cust
  % [5,1] = bool_feat
  % [6,1] = state_hday
  % [7,1] = date_base


store_num = double(max(train.store_index));
week_num = 135;
day_num = week_num * 7;

standin = train;

standin.store_index = flipud(double(standin.store_index));
standin.date_seq = flipud(double(standin.date_seq));
standin.day_week = flipud(double(standin.day_week));
standin.sale_cust = flipud(double(standin.sale_cust));
standin.bool_feat = flipud(double(standin.bool_feat));
standin.state_hday = flipud(double(logical(standin.state_hday)));

days = -1 * ones(day_num, 1);
sales = -1 * ones(day_num, 1);
is_open = -1 * ones(day_num, 1);
is_promo = -1 * ones(day_num, 1);
is_schHday = -1 * ones(day_num, 1);
is_stateHday = -1 * ones(day_num, 1);

week = repmat([2 3 4 5 6 7 1](:), week_num, 1);

mon_idx = week == 1;
tue_idx = week == 2;
wed_idx = week == 3;
thu_idx = week == 4;
fri_idx = week == 5;
sat_idx = week == 6;
sun_idx = week == 7;

train_v2 = cell(store_num, 6);


for i = 1 : store_num

	days_i = days;	
	sales_i = sales;
	is_open_i = is_open;
	is_promo_i = is_promo;
	is_schHday_i = is_schHday;
	is_stateHday_i = is_stateHday;

	idx = standin.store_index == i;
	date_idx = standin.date_seq(idx) + 1;

	days_i(date_idx) = standin.day_week(idx);	
	sales_i(date_idx) = standin.sale_cust(idx, 1);
	is_open_i(date_idx) = standin.bool_feat(idx, 1);
	is_promo_i(date_idx) = standin.bool_feat(idx, 2);
	is_schHday_i(date_idx) = standin.bool_feat(idx, 3);
	is_stateHday_i(date_idx) = standin.state_hday(idx);

	sales_i = reshape(sales_i, 7, week_num)';
	is_open_i = reshape(is_open_i, 7, week_num)';
	is_promo_i = reshape(is_promo_i, 7, week_num)';
	is_schHday_i = reshape(is_schHday_i, 7, week_num)';
	is_stateHday_i = reshape(is_stateHday_i, 7, week_num)';

	is_open_i(is_open_i == -1) = 0;
	is_promo_i(is_promo_i == -1) = 0;
	is_schHday_i(is_promo_i == -1) = 0;
	is_stateHday_i(is_stateHday_i == -1) = 0;
	% sale_sort = sort(sales_i, 2);
	sale_distr = [mean(sales_i, 2) std(sales_i')'];


	train_v2{i, 1} = int32(sales_i);
	train_v2{i, 2} = logical(is_open_i);
	train_v2{i, 3} = logical(is_promo_i);
	train_v2{i, 4} = logical(is_schHday_i);
	train_v2{i, 5} = logical(is_stateHday_i);
	train_v2{i, 6} = double(sale_distr);

	if(mod(i, 10) == 0)
		fprintf('  The %d store is built \r', i);
		fflush(stdout);
	end


end
fprintf('\n');


save -binary 'data_frame/train_v2.df' train_v2;

