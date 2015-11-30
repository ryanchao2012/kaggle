clear; clc;

n_batch = 15;
cat_batch = {};
prop_batch = int32([]);
unknown_batch = int32([]);

if(exist('statistics/all_propcat.log'))
	load 'statistics/all_propcat.log';
else
	curr_line = 2;
	unknown_line = int32([]);
	save -binary 'statistics/all_propcat.log' unknown_line curr_line;
end


file_name = 'raw_data/property_category.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_prop t_cat t_unknown t_curr] = all_in_propxcat(finput, 30000, curr_line);
	if(isempty(t_prop))
		break;
	end
	curr_line = t_curr;
	prop_batch = [prop_batch t_prop];
	cat_batch = [cat_batch t_cat];
	unknown_batch = [unknown_batch t_unknown];
end

fclose(finput);
fprintf('\n');


if(exist('statistics/all_in_propxcat.stat'))
	load 'statistics/all_in_propxcat.stat';
else
	cat_list = {};
	prop_array = int32([]);
end

cat_list = [cat_list cat_batch];
prop_array = [prop_array prop_batch];
unknown_line = [unknown_line unknown_batch];

save -binary 'statistics/all_propcat.log' unknown_line curr_line;
save -binary 'statistics/all_in_propxcat.stat' cat_list prop_array;

clear i t_prop t_cat t_unknown t_curr finput n_batch prop_batch cat_batch unknown_batch;


