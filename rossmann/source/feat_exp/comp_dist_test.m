clc; close all;

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


if(!exist('store', 'var'))
	load 'data_frame/store.df'  % store
end
  % [1,1] = type_assort
  % [2,1] = comp_dist
  % [3,1] = comp_open_since
  % [4,1] = promo2
  % [5,1] = promo_month

store_num = double(max(train.store_index));
sales_mean = zeros(store_num, 2);
sales_std = zeros(store_num, 2);
watershed = zeros(store_num, 1);
date_seq = double(train.date_seq);
is_open = train.bool_feat(:, 1);
comp_since = double(store.comp_open_since);
date_base = double(train.date_base);
for i = 1 : store_num
	d = comp_since(i, :);
	comp_open_date = datenum([d(2) d(1) 1]) - date_base;
	watershed(i) = comp_open_date;
	chosen = (train.store_index == i) & is_open;
	if((comp_open_date <= 0) || (comp_open_date >= 941))
		sales = train.sale_cust(chosen, 1);
		sales_mean(i, :) = mean(sales);
		sales_std(i, :) = std(sales);
	else
		chosen_now = chosen & (date_seq >= comp_open_date);
		sales = train.sale_cust(chosen_now, 1);
		sales_mean(i, 1) = mean(sales);
		sales_std(i, 1) = std(sales);

		chosen_past = chosen & (date_seq < comp_open_date);
		sales = train.sale_cust(chosen_past, 1);
		sales_mean(i, 2) = mean(sales);
		sales_std(i, 2) = std(sales);
	end
		
	

	if(mod(i, 100) == 0)
		fprintf('  The %d-store tested ... \r', i);
		fflush(stdout);
	end
end
fprintf('\n');


[sorted_dist sorted_idx] = sort(store.comp_dist);
x = [1 : store_num]';
plot(x, sorted_dist, 'k', ...
	 x, sales_mean(sorted_idx, 1), 'b-', ...
	 x, sales_mean(sorted_idx, 2), 'b--', ...
	 x, sales_std(sorted_idx, 1), 'r-', ...
	 x, sales_std(sorted_idx, 2), 'r--');


sales_distribution.sales_mean = sales_mean;
sales_distribution.sales_std = sales_std;
sales_distribution.watershed = watershed;

save -binary 'data_frame/sales_distribution.df' sales_distribution;
