
% % % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
% if(!exist('cookie_array', 'var'))
% 	load 'refine/cookie_in_cookie.stat'; 
% end

% if(!exist('handle_array', 'var'))
% 	load 'refine/handle_in_cookie.stat'; 
% end

% if(!exist('rest_list', 'var'))
% 	load 'statistics/rest_in_cookie.stat';
% end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% total_num = length(handle_array);

% % % % % % % % % % % % % % % - targets - % % % % % % % % % % % % % % % % % % % % % % % % 
if(!exist('handle', 'var'))
	load 'joint/handle.joint'; 
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint'; 
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


fprintf('%d joint loaded...\n\r');
fflush(stdout);

n = length(cookie);
for i = 1 : n
	cookie(i).handle_index = int32(cookie(i).handle_index);
	if(mod(i, 1000) == 0)
		fprintf('%d cookie completed...\r', i);
		fflush(stdout);
	end
end

fprintf('\n All cookie completed...\n\r');
fflush(stdout);

m = length(handle);
for j = 1 : m
	handle(j).indicator = int8(handle(j).indicator);
	handle(j).type = int16(handle(j).type);
	handle(j).version = int16(handle(j).version);
	handle(j).county = int16(handle(j).county);
	handle(j).c0 = int8(handle(j).c0);
	handle(j).c1 = int32(handle(j).c1);
	handle(j).c2 = int32(handle(j).c2);
	handle(j).a5 = int16(handle(j).a5);
	handle(j).a6 = int16(handle(j).a6);
	handle(j).a7 = int16(handle(j).a7);

	if(mod(j, 1000) == 0)
		fprintf('%d handle completed...\r', j);
		fflush(stdout);
	end

end

% fprintf('all handle completed...\n\r');


% [h_t i_t j_t] = unique(handle_array(1, :));

% handle_num = length(h_t);
% cookie_num = length(cookie_array);

% h_t = mat2cell(h_t, 1, ones(1, handle_num));
% c_t = mat2cell(cookie_array(1, :), 1, ones(1, cookie_num));
% jj_t = mat2cell(j_t, 1, ones(1, cookie_num));

% [cookie(1 : cookie_num).id] = c_t{:};
% [cookie(1 : cookie_num).handle_index] = jj_t{:};
% [handle(1 : handle_num).id] = h_t{:};

% clear jj_t c_t i_t;

% tic;

% handle_array(3, :) = [1 : cookie_num];
% header_list = {'computer_os_type_', 'computer_browser_version_', 'country_', ...
%                '', 'anonymous_c1_', 'anonymous_c2_', '', '', ''};
% h = handle_array;
% idx_array = [];


% for i = 1 : handle_num
% 	idx = find(h(1, :) == handle(i).id);
% 	handle(i).dev_cookie_index = h(3, idx);
% 	handle(i).indicator = ones(1, length(idx));
	

% 	rest_idx = h(2, idx) - ones(size(idx));
% 	str = rest_list(rest_idx);
% 	vlist = cellfun('clean_cookie', str, {header_list}, 'UniformOutput', false);

% 	val = reshape([vlist{:}], length(vlist), 9);

% 	handle(i).type = val(:, 1)';
% 	handle(i).version = val(:, 2)';
% 	handle(i).county = val(:, 3)';
% 	handle(i).c0 = val(:, 4)';
% 	handle(i).c1 = val(:, 5)';
% 	handle(i).c2 = val(:, 6)';
% 	handle(i).a5 = val(:, 7)';
% 	handle(i).a6 = val(:, 8)';
% 	handle(i).a7 = val(:, 9)';

% 	idx_array = [idx_array idx];
% 	if(mod(i, 10000) == 0)
% 		h(:, idx_array) = h(:, 1 + end - length(idx_array) : end);
% 		h(:, 1 + end - length(idx_array) : end) = [];
% 		idx_array = [];
% 	end

% 	if(mod(i, 500) == 0)
% 		fprintf('%d handle recorded...\r', i);
% 		fflush(stdout);
% 	end

% end
% toc;

% fprintf('\n');
	

% save -binary 'joint/handle.joint' handle;
% save -binary 'joint/cookie.joint' cookie;