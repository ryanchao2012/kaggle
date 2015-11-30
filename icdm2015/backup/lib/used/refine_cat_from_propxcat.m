clear; clc;

load 'statistics/all_in_propxcat.stat';   % cat_list  prop_array

n = length(cat_list);

refind_list = cell(n, 1);

for i = 1 : 1

	temp = strsplit(cat_list {i}(3 : end - 2), '),(');
	temp = cellfun ('substr', temp, {10}, 'UniformOutput', false);
	temp = cellfun ('str2num', temp, 'UniformOutput', false);
	refind_list(i) = int32([temp{:}]);

	fprintf('%d lines processed...\r', i);
	fflush(stdout);
end

fprintf('\n');

cat_list = refind_list;

save -binary 'refind/re_all_in_propxcat.stat' cat_list prop_array;

