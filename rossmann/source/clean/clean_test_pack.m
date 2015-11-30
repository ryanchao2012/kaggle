% clear;
clc;

if(!exist('test', 'var'))
	load 'raw_basket/test.pack';   % test(cell)
end

test_num = length(test);
numerical_feat = zeros(test_num, 7);


batch_size = 10000;

for i = 1 : test_num
% tic
	if(mod(i, batch_size) == 1)
		batch = i + batch_size - 1;
		if(batch > test_num)
			batch = test_num;
		end

		comma_idx = cellfun('findstr', test(i : batch), {','}, 'uniformOutput', false);
		rel_idx = 1;

		fprintf('  The %d-th test-data is refined \n', i);
		fflush(stdout);
	end

	col_12356 = [test{i}(1 : comma_idx{rel_idx}(3)) ...
				 test{i}(comma_idx{rel_idx}(4) + 1 : comma_idx{rel_idx}(6))];
	col_12356 = strrep(col_12356, ',,', ',-1,');
	col_12356 = str2num(strrep(col_12356, ',,', ','));

	col_78 = int32([[regexp(test{i}(comma_idx{rel_idx}(6) : end), '"(\w)"', 'tokens'){:}]{:}]) - [96 48];

	numerical_feat(i, :) = [col_12356 col_78];

	date_list{i} = test{i}(comma_idx{rel_idx}(3) + 1 : comma_idx{rel_idx}(4) - 1);
	
	rel_idx++;
end

test_id = uint16(numerical_feat(:, 1));
store_index = int16(numerical_feat(:, 2));
day_week = int8(numerical_feat(:, 3));

bool_feat = int8(numerical_feat(:, [4 5 7]));
state_hday = int8(numerical_feat(:, 6));
state_hday(state_hday < 0) = 0;


save -binary 'refine_basket/test.ref' test_id store_index day_week bool_feat state_hday date_list;


