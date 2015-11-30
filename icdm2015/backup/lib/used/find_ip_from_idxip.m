clear; clc;

n_batch = 130;
ip_batch = {};

if(exist('statistics/ip_idxip.log'))
	load 'statistics/ip_idxip.log';
else
	curr_line = 2;
	save -binary 'statistics/ip_idxip.log' curr_line;
end


file_name = 'raw_data/id_all_ip.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_ip t_curr] = ip_in_idxip(finput, 20000, curr_line);
	if(isempty(t_ip))
		break;
	end
	curr_line = t_curr;
	ip_batch = [ip_batch t_ip];
end

fclose(finput);
fprintf('\n');




if(exist('statistics/ip_in_idxip.stat'))
	load 'statistics/ip_in_idxip.stat';
else
	ip_list = {};
end

ip_list = [ip_list ip_batch];

save -binary 'statistics/ip_idxip.log' curr_line;
save -binary 'statistics/ip_in_idxip.stat' ip_list;

clear i t_ip t_curr n_batch finput ip_batch;
