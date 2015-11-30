clear; clc;

n_batch = 10;
curr_line = 2;
unknown_line = int32([]);
handle_array = int32([]);

if(exist('statistics/handle_dev_train_basic.log'))
	load 'statistics/handle_dev_train_basic.log';
else
	save -binary 'statistics/handle_dev_train_basic.log' curr_line unknown_line;
end


if(exist('statistics/handle_in_device.stat'))
	load 'statistics/handle_in_device.stat';
else
	save -binary 'statistics/handle_in_device.stat' handle_array;
end


file_name = 'raw_data/dev_train_basic.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_handle t_unknown t_curr] = handle_in_file(finput, 20000, curr_line);
	if(isempty(t_handle))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	handle_array = [handle_array t_handle];
end

fclose(finput);
fprintf('\n');

save -binary 'statistics/handle_dev_train_basic.log' curr_line unknown_line;
save -binary 'statistics/handle_in_device.stat' handle_array;

