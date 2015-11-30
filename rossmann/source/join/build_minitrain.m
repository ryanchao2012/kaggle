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

if(!exist('test', 'var'))
	load 'data_frame/test.df';  % test
end
  % [1,1] = test_id
  % [2,1] = store_index
  % [3,1] = date_seq
  % [4,1] = day_week
  % [5,1] = bool_feat
  % [6,1] = state_hday

selected_store_idx = ismember(train.store_index, test.store_index);

selected_date_period = [datenum([2013 6 1]):datenum([2013 10 1]) ...
						datenum([2014 6 1]):datenum([2014 10 1]) ...
						datenum([2015 6 1]):datenum([2015 7 31])] - double(train.date_base);

selected_date_idx = ismember(train.date_seq, selected_date_period);

selected_idx = selected_store_idx & selected_date_idx;


minitrain.store_index = train.store_index(selected_idx);
minitrain.date_seq = train.date_seq(selected_idx);
minitrain.day_week = train.day_week(selected_idx);
minitrain.sale_cust = train.sale_cust(selected_idx, :);
minitrain.bool_feat = train.bool_feat(selected_idx, :);
minitrain.state_hday = train.state_hday(selected_idx);
minitrain.date_base = train.date_base;


save -binary 'data_frame/minitrain.df' minitrain;


