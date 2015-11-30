clc;
close all;

if(!exist('handle', 'var'))  % handle member ...
	load 'joint/handle.joint';
end
handle_num = length(handle);


if(!exist('device', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/device.joint';
end


if(!exist('cookie', 'var'))   % cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end


if(exist('joint/property_pair.joint'))
	load 'joint/property_pair.joint';
else
	device_property_id = int32([]);
	cookie_property_pairs = {};
	save -binary 'joint/property_pair.joint' device_property_id cookie_property_pairs;
end

fprintf('... Env prepared ...\r\n');
fflush(stdout);	

s = 1;
e = handle_num;

for i = s : e
	m_t = member{i};
	dev = m_t(find(m_t(:, 2) == 0), 1);
	ck = m_t(find(m_t(:, 2) == 1), 1);

	[dummy dev_idx] = ismember(dev, device);
	% dev_idx(find(dev_idx == 0)) = [];
	[dummy ck_idx] = ismember(ck, cookie);
	% ck_idx(find(ck_idx == 0)) = [];

	prop_ck = [];

	for k = 1 : length(ck_idx)
		buff_ck = prop_member_cookie{ck_idx(k)};
		if(!isempty(buff_ck))
			[dominant dom_idx] = max(prop_feature_cookie{ck_idx(k)});
			prop_ck = [prop_ck buff_ck(dom_idx)];
		end			
	end

	if(isempty(prop_ck))
		continue;
	end


	prop_len = length(dev_idx);

	for j = 1 : prop_len
		buff_dev = prop_member_device{dev_idx(j)};

		if(isempty(buff_dev))
			continue;
		end

		[dominant dom_idx] = max(prop_feature_device{dev_idx(j)});
		prop_dev = buff_dev(dom_idx);


		prop_ck = prop_ck(:);
		record_idx = find(device_property_id == prop_dev);
		if(isempty(record_idx))
			device_property_id = [device_property_id prop_dev];
			cookie_property_pairs{length(device_property_id)} = prop_ck';
		else
			cookie_property_pairs{record_idx} = [cookie_property_pairs{record_idx} prop_ck'];
		end

	end


	if(mod(i, 500) == 0)
		fprintf('... %d-th property paired...\r', i);
		fflush(stdout);
	end


end


fprintf('\n');

save -binary 'joint/property_pair.joint' device_property_id cookie_property_pairs;


