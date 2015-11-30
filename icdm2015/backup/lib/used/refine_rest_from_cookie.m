clear; clc;

load 'statistics/rest_in_cookie.stat';    % rest_list

refind_array = int32(-1 * ones(9, 1));
n = length(rest_list);
tic;
i = 1;
k = 2;
while(k-- > 0)
	str = rest_list {i};
	if(!strcmp(str(1:2), '-1'))
		idx = find(str == ',');
		temp = str2num([str(18 : idx(1) - 1); ... 
		        		str(idx(1) + 26 : idx(2) - 1); ...
		        		str(idx(2) + 9 : idx(3) - 1); ...
				        str(idx(3) + 1 : idx(4) - 1); ...
				        str(idx(4) + 14 : idx(5) - 1); ...
				        str(idx(5) + 14 : idx(6) - 1); ...
				        str(idx(6) + 1 : idx(7) - 1); ...
				        str(idx(7) + 1 : idx(8) - 1); ...
				        str(idx(8) + 1 : end)]);
		% refind_array(:, 1) = temp;
		refind_list{i} = int32(temp);
	end

	fprintf('%d lines processed...\r', i);
	fflush(stdout);
	i++;

end

fprintf('\n');
toc;
