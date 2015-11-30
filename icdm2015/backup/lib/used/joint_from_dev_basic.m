
% % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
if(!exist('handle_array', 'var'))
	load 'refine/handle_in_device.stat'; 
end

if(!exist('device_array', 'var'))
	load 'refine/device_in_device.stat'; 
end

if(!exist('rest_list', 'var'))
	load 'statistics/rest_in_device.stat';
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
n = length(device_array);

% % % % % % % % % % % % % % % - targets - % % % % % % % % % % % % % % % % % % % % % % % % 
if(!exist('handle', 'var'))
	load 'joint/handle.joint'; 
end

if(!exist('device', 'var'))
	load 'joint/device.joint'; 
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

fprintf('joints loaded...\n\r');
fflush(stdout);

handle_label = [handle.id];
[dump idx] = ismember(handle_array(1, :), handle_label);

d_t = mat2cell(device_array(1, :), 1, ones(1, n));
j_t = mat2cell(int32(idx), 1, ones(1, n));
[device(1 : n).id] = d_t{:};
[device(1 : n).handle_index] = j_t{:};

header_list = {'devtype_', 'devos_', 'country_', ...
               '', 'anonymous_c1_', 'anonymous_c2_', '', '', ''};

tic;
for i = 1 : n
	handle(idx(i)).dev_cookie_index = [handle(idx(i)).dev_cookie_index i];
	handle(idx(i)).indicator = [handle(idx(i)).indicator 0];
	

	str = rest_list(i);
	vlist = cellfun('clean_cookie', str, {header_list}, 'UniformOutput', false);
	val = [vlist{:}];

	handle(idx(i)).type = [handle(idx(i)).type val(1)];
	handle(idx(i)).version = [handle(idx(i)).version val(2)];
	handle(idx(i)).county = [handle(idx(i)).county val(3)];
	handle(idx(i)).c0 = [handle(idx(i)).c0 val(4)];
	handle(idx(i)).c1 = [handle(idx(i)).c1 val(5)];
	handle(idx(i)).c2 = [handle(idx(i)).c2 val(6)];
	handle(idx(i)).a5 = [handle(idx(i)).a5 val(7)];
	handle(idx(i)).a6 = [handle(idx(i)).a6 val(8)];
	handle(idx(i)).a7 = [handle(idx(i)).a7 val(9)];

	if(mod(i, 500) == 0)
		fprintf('%d device recorded...\r', i);
		fflush(stdout);
	end
end
toc;

fprintf('\n');


% save -binary 'joint/handle.joint' handle;
% save -binary 'joint/device.joint' device;

