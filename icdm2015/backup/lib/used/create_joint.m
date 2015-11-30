function flag = create_joint()

	flag = uint8(zeros(1, 6));

	if(exist('joint/handle.joint'))
		printf(['...The handle-joint already exists!...\n' ...
			    '...Create handle-joint failed...\n']);
	else
		handle = struct('id', int32([]), 'dev_cookie_index', int32([]), ...
			            'indicator', int8([]), 'type', int16([]), ...
			            'version', int16([]), 'country', int16([]), ...
			            'c0', int8([]), 'c1', int32([]), 'c2', int32([]), ...
			            'a5', int16([]), 'a6', int16([]), 'a7', int16([]));
		flag(1) = 1;
		save -binary 'joint/handle.joint' handle;
	end



	if(exist('joint/cookie.joint'))
		printf(['...The cookie-joint already exists!...\n' ...
			    '...Create cookie-joint failed...\n']);
	else
		cookie = struct('id', int32([]), 'handle_index', int32([]), ...
			            'ip_index', int32([]), 'ip_freq', int16([]), ...
			            'c1', int16([]), 'c2', int16([]), 'c3', int16([]), ...
			            'c4', int16([]), 'c5', int16([]), ...
			            'prop_index', int32([]), 'prop_freq', int16([]));
		flag(2) = 1;
		save -binary 'joint/cookie.joint' cookie;
	end


	if(exist('joint/device.joint'))
		printf(['...The device-joint already exists!...\n' ...
			    '...Create device-joint failed...\n']);
	else
		device = struct('id', int32([]), 'handle_index', int32([]), ...
			            'ip_index', int32([]), 'ip_freq', int16([]), ...
			            'c1', int16([]), 'c2', int16([]), 'c3', int16([]), ...
			            'c4', int16([]), 'c5', int16([]), ...
		                'prop_index', int32([]), 'prop_freq', int16([]));
		flag(3) = 1;
		save -binary 'joint/device.joint' device;
	end


	if(exist('joint/ip.joint'))
		printf(['...The ip-joint already exists!...\n' ...
			    '...Create ip-joint failed...\n']);
	else
		ip = struct('address', int32([]), 'iscell', int8([]), ...
			        'dev_cookie_index', int32([]), 'total_freq', int32([]), ...
			        'c0', int16([]), 'c1', int16([]), 'c2', int16([]));
		flag(4) = 1;
		save -binary 'joint/ip.joint' ip;
	end

	if(exist('joint/property.joint'))
		printf(['...The property-joint already exists!...\n' ...
			    '...Create property-joint failed...\n']);
	else
		property = struct('id', int32([]), 'dev_cookie_index', int32([]), ...
						  'indicator', int8([]), 'cat_index', int16([]));
		flag(5) = 1;
		save -binary 'joint/property.joint' property;
	end


	if(exist('joint/category.joint'))
		printf(['...The category-joint already exists!...\n' ...
			    '...Create category-joint failed...\n']);
	else
		category = struct('id', int16([]), 'prop_index', int32([]));
		flag(6) = 1;
		save -binary 'joint/category.joint' category;
	end

end


