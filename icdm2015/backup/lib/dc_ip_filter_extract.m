clc;
close all;


if(!exist('ip', 'var'))  % ip feature_ip shared_cookie
	load 'joint/ip.joint';
end


if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end


if(!exist('cookie', 'var'))   % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end


if(!exist('cookie_label', 'var') || !exist('device_label', 'var'))   % cookie_label device_label
	load 'joint/label.joint'; 
end


if(!exist('dc_filter_list', 'var'))   % dc_filter_list
	load 'joint/filter.joint'; 
end



if(exist('training_data/training_set_alt.join'))
	load 'training_data/training_set_alt.join';
else
	training_set_alt = double([]);
	curr_index = 1;
	save -binary 'training_data/training_set_alt.join' curr_index training_set_alt;
end



fprintf('... Env prepared ...\n');
fflush(stdout);


dev_num = length(device);

s = curr_index;
e = curr_index + 10000;
if(e > dev_num)
	e = dev_num;
end

batch_buffer = [];

for i = s : e

	[ip_feature_pos ip_feature_neg] = dc_ip_filter(device, cookie, device_label, cookie_label, ...
												   ip_member_device, ip_member_cookie, ip_feature_cookie, ...
												   ip, feature_ip, dc_filter_list, i);

	curr_index = i + 1;

	if(mod(i, 500) == 0)
		fprintf('%d training sample recorded...\r', i);
		fflush(stdout);
	end

	ip_feature_pos(find(cellfun('isempty' , ip_feature_pos))) = [];
	if(isempty(ip_feature_pos) || isempty(ip_feature_neg))
		continue;
	end

	temp1 = [ip_feature_pos ip_feature_neg];
	temp2 = cellfun('mean', temp1, {1}, 'UniformOutput', false);
	temp2 = [temp2{:}];
	temp2 = reshape(temp2, 12, length(temp2)/12)';
	each_len = cellfun('rows', temp1)(:);
	len = length(each_len);

	temp2(:, 1) = each_len;

	% % % % % % % % % % % % % % % 
	temp2 = temp2 + 1;
	mu = mean(temp2, 1);
	MU = (ones(len, 1) * mu);
	temp3 = temp2 ./ MU;
	% % % % % % % % % % % % % % % 

	lab = [ones(length(ip_feature_pos), 1); zeros(length(ip_feature_neg), 1)];

	% % % % % % % % % % % % % % %
	buff = [temp3 lab];
	% % % % % % % % % % % % % % %

	batch_buffer = [batch_buffer ; buff];

end

training_set_alt = [training_set_alt ; batch_buffer];
fprintf('\n');

save -binary 'training_data/training_set_alt.join' curr_index training_set_alt;
