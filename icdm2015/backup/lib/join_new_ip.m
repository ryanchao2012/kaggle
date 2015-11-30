clc;
close all;


if(!exist('rest_list', 'var'))
	load 'statistics/rest_in_ipagg.stat';  % rest_list
end

if(!exist('ip_array', 'var'))
	load 'refine/ip_in_ipagg.stat';  % ip_array
end

if(!exist('ip_member_device', 'var'))
	load 'joint/device_ip_light.join';  % device ip_member_device ip_feature_device
end


fprintf('... Env prepared ...\n');
fflush(stdout);

ip_light = unique([ip_member_device{:}]);
ipl_num = length(ip_light);
feature_ip_light = -1 * ones(ipl_num, 5);

buf_ip = ip_array(:, ismember(ip_array(1, :), ip_light));
[dummy i_ip] = ismember(buf_ip(1, :), ip_light);

for i = 1 : ipl_num

	feature_ip_light(i_ip(i), :) = sscanf(rest_list{buf_ip(2, i) - 1}, '%d,%d,%d,%d,%d')';

	if(mod(i, 500) == 0)
		fprintf('%d ip(light)-feature recorded...\r', i);
		fflush(stdout);
	end
end

fprintf('\n');

save -binary 'joint/ip_light.joint' ip_light feature_ip_light;






