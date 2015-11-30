clear; clc;
% % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
load 'refine/handle_in_device.stat';   % handle_array
handle_dev = handle_array;

load 'refine/handle_in_cookie.stat';
handle_cookie = handle_array;
clear handle_array;

load 'refine/device_in_device.stat';  % device_array
load 'refine/cookie_in_cookie.stat';  % cookie_array


load 'statistics/rest_in_cookie.stat';
cookie_rest = rest_list;
load 'statistics/rest_in_device.stat';
dev_rest = rest_list;
clear rest_list;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('... Data loaded ...\n\r');
fflush(stdout);


dev_header = {'devtype_', 'devos_', 'country_', ...
              '', 'anonymous_c1_', 'anonymous_c2_', '', '', ''};
ck_header = {'computer_os_type_', 'computer_browser_version_', 'country_', ...
               '', 'anonymous_c1_', 'anonymous_c2_', '', '', ''};


handle = unique(handle_dev(1, :));

key = ismember(handle_dev(1, :), handle);
h_dev = handle_dev(:, key);
device = device_array(1, key);

key = ismember(handle_cookie(1, :), handle);
h_ck = handle_cookie(:, key);
cookie = cookie_array(1, key);

num = length(handle);
feature_basic = cell(num, 1);
member = cell(num, 1);


% % % % % % % % % % % % % % % % - targets - % % % % % % % % % % % % % % % % % % % % % % % % 
if(exist('joint/handle.joint'))
	fprintf('... Joint already exists ...\n\r');
	fflush(stdout);
	return;
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


for i = 1 : num
	i_ck = find(h_ck(1, :) == handle(i));
	i_dev = find(h_dev(1, :) == handle(i));

	m_ck = length(i_ck); 
	m_dev = length(i_dev); 
	line_ck = h_ck(2, i_ck) - ones(1, m_ck);
	line_dev = h_dev(2, i_dev) - ones(1, m_dev);

	
	dev = cellfun('clean_cookie', dev_rest(line_dev), {dev_header}, 'UniformOutput', false);
	ck = cellfun('clean_cookie', cookie_rest(line_ck), {ck_header}, 'UniformOutput', false);

	A = int32(zeros(m_dev + m_ck, 2));
	A(:, 1) = [device(i_dev)(:); cookie(i_ck)(:)];
	A(:, 2) = [zeros(m_dev, 1); ones(m_ck, 1)];
	member{i} = A;
	feature_basic{i} = [strvcat(dev); strvcat(ck)];

	checksum = sum(A(:, 2));
	if(checksum == 0 || checksum == (m_dev + m_ck))
		fprintf('\n... Something wrong, please check ...\r\n');
		break;
	end

	
	if(mod(i, 500) == 0)
		fprintf('%d samples recorded...\r', i);
		fflush(stdout);
	end
end


fprintf('\n');

save -binary 'joint/handle.joint' handle member feature_basic;
save -binary 'joint/device.joint' device;
save -binary 'joint/cookie.joint' cookie;




