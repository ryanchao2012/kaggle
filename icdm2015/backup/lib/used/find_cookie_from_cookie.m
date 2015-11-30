clear; clc;

n_batch = 60;
curr_line = 2;
unknown_line = int32([]);
cookie_array = int32([]);

if(exist('log/cookie_cookie_all_basic.log'))
	load 'log/cookie_cookie_all_basic.log';
else
	save -binary 'log/cookie_cookie_all_basic.log' curr_line unknown_line;
end


if(exist('statistics/cookie_in_cookie.stat'))
	load 'statistics/cookie_in_cookie.stat';
else
	save -binary 'statistics/cookie_in_cookie.stat' cookie_array;
end


file_name = 'raw_data/cookie_all_basic.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_cookie t_unknown t_curr] = cookie_in_cookie(finput, 40000, curr_line);
	if(isempty(t_cookie))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	cookie_array = [cookie_array t_cookie];
end

fclose(finput);
fprintf('\n');

save -binary 'log/cookie_cookie_all_basic.log' curr_line unknown_line;
save -binary 'statistics/cookie_in_cookie.stat' cookie_array;

