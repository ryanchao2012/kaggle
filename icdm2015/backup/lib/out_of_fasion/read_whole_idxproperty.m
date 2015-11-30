clear; clc;

n_batch = 120;
str_batch = {};

if(exist('statistics/whole_idxproperty.log'))
	load 'statistics/whole_idxproperty.log';
else
	curr_line = 2;
	save -binary 'statistics/whole_idxproperty.log' curr_line;
end


file_name = 'raw_data/id_all_property.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_str t_curr] = read_whole_file(finput, 20000, curr_line);
	if(isempty(t_str))
		break;
	end
	curr_line = t_curr;
	str_batch = [str_batch t_str];
end

fclose(finput);
fprintf('\n');




if(exist('statistics/whole_in_idxproperty.stat'))
	load 'statistics/whole_in_idxproperty.stat';
else
	str_list = {};
end

str_list = [str_list str_batch];

save -binary 'statistics/whole_idxproperty.log' curr_line;
save -binary 'statistics/whole_in_idxproperty.stat' str_list;

clear i t_str t_curr n_batch finput str_batch;
