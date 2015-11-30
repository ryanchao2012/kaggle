clc;

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
store_age = zeros(1, store_num);
business_rate = zeros(1, store_num);

is_open = train.bool_feat(:, 1);

for i = 1 : store_num
	selected_idx = ((train.store_index == i) & is_open);
	total_date = double(train.date_seq(selected_idx));
	total_date = sort(total_date);
	store_age(i) = total_date(end) - total_date(1) + 1;
	avai_sales_num = sum(selected_idx);

	business_rate(i) = avai_sales_num / store_age(i);

	if(mod(i, 100) == 0)
		fprintf('  The %d-store tested ... \r', i);
		fflush(stdout);
	end

end
fprintf('\n');

business.business_rate = business_rate;
business.store_age = int32(store_age);

save -binary 'data_frame/business.df' business;