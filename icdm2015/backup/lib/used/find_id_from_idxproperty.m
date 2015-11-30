clear; clc;

n_batch = 55;
curr_line = 2;
unknown_line = int32([]);
cookie_array = int32([]);
device_array = int32([]);

if(exist('statistics/id_idxproperty.log'))
	load 'statistics/id_idxproperty.log';
else
	save -binary 'statistics/id_idxproperty.log' curr_line unknown_line;
end


if(exist('statistics/id_in_idxproperty.stat'))
	load 'statistics/id_in_idxproperty.stat';
else
	save -binary 'statistics/id_in_idxproperty.stat' cookie_array device_array;
end


file_name = 'raw_data/id_all_property.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_cookie t_device t_unknown t_curr] = id_in_file(finput, 40000, curr_line);
	if(isempty(t_cookie) && isempty(t_device))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	cookie_array = [cookie_array t_cookie];
	device_array = [device_array t_device];
end

fclose(finput);
fprintf('\n');

clear i t_cookie t_device t_unknown t_curr n_batch;

save -binary 'statistics/id_idxproperty.log' curr_line unknown_line;
save -binary 'statistics/id_in_idxproperty.stat' cookie_array device_array;

