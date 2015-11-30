% clear;
clc;

if(!exist('train', 'var'))
	load 'raw_basket/train.pack';   % train(cell)
end

train_num = length(train);
date_list = cell(train_num, 1);
numerical_feat = zeros(train_num, 8);


batch_size = 10000;

for i = 1 : train_num
% tic
	if(mod(i, batch_size) == 1)
		batch = i + batch_size - 1;
		if(batch > train_num)
			batch = train_num;
		end

		comma_idx = cellfun('findstr', train(i : batch), {','}, 'uniformOutput', false);
		rel_idx = 1;

		fprintf('  The %d-th train-data is refined \n', i);
		fflush(stdout);
	end

	col_124567 = str2num([train{i}(1 : comma_idx{rel_idx}(2)) ...
						train{i}(comma_idx{rel_idx}(3) + 1 : comma_idx{rel_idx}(5)) ...
						train{i}(comma_idx{rel_idx}(5) + 1 : comma_idx{rel_idx}(7))]
						);
	col_89 = int32([[regexp(train{i}(comma_idx{rel_idx}(7) : end), '"(\w)"', 'tokens'){:}]{:}]) - [96 48];

	numerical_feat(i, :) = [col_124567 col_89];

	date_list{i} = train{i}(comma_idx{rel_idx}(2) + 1 : comma_idx{rel_idx}(3) - 1);
	
	rel_idx++;
end

store_index = int16(numerical_feat(:, 1));
day_week = int8(numerical_feat(:, 2));
sale_cust = int32(numerical_feat(:, [3 4]));
bool_feat = logical(numerical_feat(:, [5 6 8]));
state_hday = int8(numerical_feat(:, 7));
state_hday(state_hday < 0) = 0;


save -binary 'refine_basket/train.ref' store_index day_week sale_cust bool_feat state_hday date_list;


