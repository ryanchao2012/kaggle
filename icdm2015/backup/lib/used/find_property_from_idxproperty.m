clear; clc;

n_batch = 55;
property_batch = {};

if(exist('statistics/property_idxproperty.log'))
	load 'statistics/property_idxproperty.log';
else
	curr_line = 2;
	save -binary 'statistics/property_idxproperty.log' curr_line;
end


file_name = 'raw_data/id_all_property.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_property t_curr] = property_in_idxproperty(finput, 40000, curr_line);
	if(isempty(t_property))
		break;
	end
	curr_line = t_curr;
	property_batch = [property_batch t_property];
end

fclose(finput);
fprintf('\n');


if(exist('statistics/property_in_idxproperty.stat'))
	load 'statistics/property_in_idxproperty.stat';
else
	property_list = {};
end

property_list = [property_list property_batch];

save -binary 'statistics/property_idxproperty.log' curr_line;
save -binary 'statistics/property_in_idxproperty.stat' property_list;

clear i t_property t_curr n_batch finput property_batch;
