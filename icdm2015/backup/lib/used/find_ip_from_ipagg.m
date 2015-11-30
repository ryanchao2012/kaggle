clear; clc;

n_batch = 200;
curr_line = 2;
unknown_line = int32([]);
ip_array = int32([]);

if(exist('statistics/ip_ipagg_all.log'))
	load 'statistics/ip_ipagg_all.log';
else
	save -binary 'statistics/ip_ipagg_all.log' curr_line unknown_line;
end


if(exist('statistics/ip_in_ipagg.stat'))
	load 'statistics/ip_in_ipagg.stat';
else
	save -binary 'statistics/ip_in_ipagg.stat' ip_array;
end


file_name = 'raw_data/ipagg_all.csv';
finput = fopen(file_name, 'r');
if(curr_line > 1)
	fskipl(finput, curr_line - 1);
end


for i = 1 : n_batch
	[t_ip t_unknown t_curr] = ip_in_ipagg(finput, 40000, curr_line);
	if(isempty(t_ip))
		break;
	end
	curr_line = t_curr;
	unknown_line = [unknown_line t_unknown];
	ip_array = [ip_array t_ip];
end

fclose(finput);
fprintf('\n');


clear i t_ip t_unknown t_curr n_batch finput;


save -binary 'statistics/ip_ipagg_all.log' curr_line unknown_line;
save -binary 'statistics/ip_in_ipagg.stat' ip_array;

