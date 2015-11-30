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


if(!exist('business', 'var'))
	load 'data_frame/business.df'  % business
end
  % [1,1] = business_rate
  % [2,1] = store_age

store_num = double(max(train.store_index));
princ_num = 20;

frequency = cell(store_num, 1);
energy = cell(store_num, 1);
num = zeros(store_num, 1);
is_open = train.bool_feat(:, 1);

hold on;

for i = 1 : store_num
	br = business.business_rate(i);
	ba = business.store_age(i);
	if((br >= 0.82) && (ba >= 940))
		[p e n] = sales_hist_fft(train, i);
		frequency{i} = p(1 : princ_num);
		energy{i} = e(1 : princ_num);
		plot((frequency{i}), i * ones(1, princ_num), '.');
		num(i) = n;
	end

	if(mod(i, 100) == 0)
		fprintf('  The %d-store tested ... \r', i);
		fflush(stdout);
	end

end
fprintf('\n');
hold off;

principal.frequency = frequency;
principal.energy = energy;
save -binary 'data_frame/principal.df' principal;


