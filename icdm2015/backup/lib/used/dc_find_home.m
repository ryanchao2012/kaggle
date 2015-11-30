% clear; 
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end

if(!exist('device', 'var'))
	load 'joint/device.joint';
end

handle_num = length(handle);
device_label = int32(zeros(length(device), 1));
cookie_label = int32(zeros(length(cookie), 1));


for j = 1 : handle_num

	m_t = member{j};
	dev_id = m_t(find(m_t(:, 2) == 0), 1);
	ck_id = m_t(find(m_t(:, 2) == 1), 1);
	[dummy dev_idx] = ismember(dev_id, device);
	[dummy ck_idx] = ismember(ck_id, cookie);

	device_label(dev_idx) = handle(j);
	cookie_label(ck_idx) = handle(j);


	if(mod(j, 500) == 0)
		fprintf('... The %d-th process finished ...\r', j);
		fflush(stdout);
	end

end



save -binary 'joint/label.joint' device_label cookie_label;