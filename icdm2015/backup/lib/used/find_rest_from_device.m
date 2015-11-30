clear; clc;

n_batch = 10;
rest_batch = {};

if(exist('statistics/rest_device.log'))
	load 'statistics/rest_device.log';
else
	curr_line = 2;
	save -binary 'statistics/rest_device.log' curr_line;
end


file_name = 'raw_data/dev_train_basic.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_rest t_curr] = rest_in_device(finput, 30000, curr_line);
	if(isempty(t_rest))
		break;
	end
	curr_line = t_curr;
	rest_batch = [rest_batch t_rest];
end

fclose(finput);
fprintf('\n');


if(exist('statistics/rest_in_device.stat'))
	load 'statistics/rest_in_device.stat';
else
	rest_list = {};
end

rest_list = [rest_list rest_batch];

save -binary 'statistics/rest_device.log' curr_line;
save -binary 'statistics/rest_in_device.stat' rest_list;

clear i t_rest t_curr n_batch finput rest_batch;
