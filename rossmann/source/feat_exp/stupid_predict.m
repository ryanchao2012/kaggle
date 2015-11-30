clear; clc; close all;

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


if(!exist('test', 'var'))
	load 'data_frame/test.df'  % test
end
  % [1,1] = test_id
  % [2,1] = store_index
  % [3,1] = date_seq
  % [4,1] = day_week
  % [5,1] = bool_feat
  % [6,1] = state_hday

 
target_store_index = unique(double(test.store_index));
target_num = length(target_store_index);

end_date = 625;
start_date = 578;
store_index = 677;
% for i = 1 : target_num

	% store_index = target_store_index(i);
	date_seq = double(train.date_seq(train.store_index == store_index));
	sales = double(train.sale_cust(train.store_index == store_index, 1));

	if(length(sales) != 942)
		fprintf('  WTF: store_index: %d, length: %d  \n', store_index, length(sales));
		fflush(stdout);
		% break;
	end

% end












