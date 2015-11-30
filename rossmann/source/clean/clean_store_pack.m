clear; clc;

load 'raw_basket/store.pack';  % store(cell)
standin = store;
clear store;

store_num = length(standin);

type_assort = zeros(store_num, 2);
numerical_feat = zeros(store_num, 6);

comma_index = cellfun('strfind', standin, {','}, 'UniformOutput', false);
comma_num = cellfun('length', comma_index);


MONTH = {'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sept';'Oct';'Nov';'Dec'};
MONTH = cellfun('sum', MONTH);


promo_month = cell(store_num, 1);

for i = 1 : store_num

	col_2_3 = standin{i}(comma_index{i}(1) : comma_index{i}(3));
	type_assort(i, :) = [[regexp(col_2_3, '"(\w)"', 'tokens'){:}]{:}] - 96;

	col_4_9 = standin{i}(comma_index{i}(3) : comma_index{i}(9));
	numerical_feat(i, :) = str2num(strrep(strrep(col_4_9, ',,', ',-1,'), ',,', ','));

	if(comma_num(i) == 9)
		promo_month{i} = int8(-1);

	else
		str_month = standin{i}(comma_index{i}(9) + 2 : end - 1);
		int_month = cellfun('sum', strsplit(str_month, ','));
		[bool m_idx] = ismember(int_month, MONTH);
		promo_month{i} = int8(m_idx);
	end

	if(mod(i, 100) == 0 && i > 0)
		fprintf('  The %d-th store is refined \r', i);
		fflush(stdout);
	end

end


type_assort = int8(type_assort);
numerical_feat = int16(numerical_feat);

comp_dist = numerical_feat(:, 1);
comp_open_since = numerical_feat(:, 2 : 3);
promo2 = numerical_feat(:, 4 : end);


save -binary 'refine_basket/store.ref' type_assort comp_dist comp_open_since promo2 promo_month;




