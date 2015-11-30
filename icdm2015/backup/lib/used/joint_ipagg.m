% clear; clc;

% % % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
% load 'refine/ip_in_ipagg.stat';         % ip_array
% load 'statistics/rest_in_ipagg.stat';   % rest_list
% load 'joint/ip.joint';                  % ip ip_device ip_cookie
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('... Data loaded ...\n\r');
fflush(stdout);


buf_ip = ip_array(:, ismember(ip_array(1, :), ip));
[dump i_ip] = ismember(buf_ip(1, :), ip);
num_ip = length(buf_ip);
feature_ip = int32([]);

for i = 1 : num_ip
	feature_ip(i_ip(i), :) = int32(sscanf(rest_list{buf_ip(2, i) - 1}, '%d,%d,%d,%d,%d')');

	if(mod(i, 500) == 0)
		fprintf('%d ip-feature recorded...\r', i);
		fflush(stdout);
	end
end


% save -binary 'joint/ip.joint' ip ip_device ip_cookie feature_ip;