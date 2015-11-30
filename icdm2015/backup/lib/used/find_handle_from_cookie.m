clear; clc;

n_batch = 50;
curr_line = 2;
unknown_line = int32([]);
handle_array = int32([]);

if(exist('statistics/handle_cookie_all_basic.log'))
	load 'statistics/handle_cookie_all_basic.log';
else
	save -binary 'statistics/handle_cookie_all_basic.log' curr_line unknown_line;
end


if(exist('statistics/handle_in_cookie.stat'))
	load 'statistics/handle_in_cookie.stat';
else
	save -binary 'statistics/handle_in_cookie.stat' handle_array;
end


file_name = 'raw_data/cookie_all_basic.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_handle t_unknown t_curr] = handle_in_file(finput, 40000, curr_line);
	if(isempty(t_handle))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	handle_array = [handle_array t_handle];
end

fclose(finput);
fprintf('\n');

save -binary 'statistics/handle_cookie_all_basic.log' curr_line unknown_line;
save -binary 'statistics/handle_in_cookie.stat' handle_array;

