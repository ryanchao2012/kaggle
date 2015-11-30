clear; clc;

n_batch = 300;
rest_batch = {};

if(exist('statistics/rest_ipagg.log'))
	load 'statistics/rest_ipagg.log';
else
	curr_line = 2;
	save -binary 'statistics/rest_ipagg.log' curr_line;
end


file_name = 'raw_data/ipagg_all.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_rest t_curr] = rest_in_ipagg(finput, 40000, curr_line);
	if(isempty(t_rest))
		break;
	end
	curr_line = t_curr;
	rest_batch = [rest_batch t_rest];
end

fclose(finput);
fprintf('\n');


if(exist('statistics/rest_in_ipagg.stat'))
	load 'statistics/rest_in_ipagg.stat';
else
	rest_list = {};
end

rest_list = [rest_list rest_batch];

save -binary 'statistics/rest_ipagg.log' curr_line;
save -binary 'statistics/rest_in_ipagg.stat' rest_list;

clear i t_rest t_curr n_batch finput rest_batch;
