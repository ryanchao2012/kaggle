clear; clc;

n_batch = 10;
curr_line = 2;
unknown_line = int32([]);
device_array = int32([]);

if(exist('statistics/device_dev_train_basic.log'))
	load 'statistics/device_dev_train_basic.log';
else
	save -binary 'statistics/device_dev_train_basic.log' curr_line unknown_line;
end


if(exist('statistics/device_in_device.stat'))
	load 'statistics/device_in_device.stat';
else
	save -binary 'statistics/device_in_device.stat' device_array;
end


file_name = 'raw_data/dev_train_basic.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_device t_unknown t_curr] = device_in_device(finput, 20000, curr_line);
	if(isempty(t_device))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	device_array = [device_array t_device];
end

fclose(finput);
fprintf('\n');

save -binary 'statistics/device_dev_train_basic.log' curr_line unknown_line;
save -binary 'statistics/device_in_device.stat' device_array;

