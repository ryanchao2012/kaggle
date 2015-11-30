clc; clear('all');
close all;


% load 'new_join/c1c2_pair.join';  % device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1 cookie_c2



% if(!exist('dc_filter_train', 'var'))   % dc_filter_train
% 	load 'new_join/dc_filter_train.join'; 
% end


% if(!exist('cookie_light_array', 'var'))  % cookie_light_array
% 	load 'refine/cookie_light_in_cookie.ref';
% end

% if(!exist('member', 'var'))
% 	load 'new_join/handle.join';  % member handle
% end


% if(!exist('ip_light', 'var'))  % ip_light feature_ip_light shared_cookies_light shared_number_light
% 	load 'new_join/ip_light_train.join';
% end

% if(!exist('device', 'var'))  % device ip_refine_device basic_device
% 	load 'new_join/device_train.join';
% end



% if(!exist('property_member_cookie', 'var')) % property_member_cookie property_feature_cookie
% 	load 'new_join/property_cookie.join'; 
% end



% if(!exist('property_member_device', 'var')) % property_member_device property_feature_device
% 	load 'new_join/property_device.join'; 
% end


% if(!exist('property', 'var')) % property property_df cat_member
% 	load 'new_join/property.join'; 
% end


% if(!exist('category', 'var')) % category category_df
% 	load 'new_join/category.join';
% end


% if(!exist('cookie', 'var'))   % cookie ip_refine_cookie basic_cookie
% 	load 'new_join/cookie_train.join';
% end



fprintf('... Env prepared ...\n');
fflush(stdout);

% dev_num = length(dc_filter_train);
% dc_filter_light_train = cell(dev_num, 1);
% col = cellfun('columns', dc_filter_train);
% ck = [dc_filter_train{:}];
% ck = ck(1, :);
% bool = ismember(ck, cookie_light_array(1, :));

% e = 0;
% for i = 1 : dev_num
% 	s = e + 1;
% 	e = e + col(i);
% 	dc_filter_light_train{i} = dc_filter_train{i}(:, bool(s : e));


%  	if(mod(i, 500) == 0)
% 		fprintf('... %d filter-light refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');
% save -binary 'new_join/dc_filter_light_train.join' dc_filter_light_train;




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



% X = [0 1; 100 89; 0 2; 50 24; 100 140; 0 11; 33 72; 67 317; 100 209];
% [a,~,c] = unique(X(:,1));
% out = [a, accumarray(c,X(:,2))];

% ck_num = length(property_member_cookie);
% cat_num = length(category);
% category_tf_cookie = uint8(zeros(ck_num, cat_num));
% category_df_cookie = uint8(zeros(ck_num, cat_num));

% for i = 1 : ck_num
% 	prop_ck = property_member_cookie{i};
	
% 	if(isempty(prop_ck))
% 		continue;
% 	end


% 	prop_tf = property_feature_cookie{i};
% 	% [S t] = sort(prop_tf, 'descend');
% 	% t = t(S > 0.7 * S(1));
% 	% prop_tf = prop_tf(t);
% 	[bool prop_idx] = ismember(prop_ck, property);
% 	prop_num = sum(bool);


% 	prop_df = property_df(prop_idx, 2);

% 	cat_t = cat_member(prop_idx);

% 	cat_len = [cellfun('length', cat_t)]';

% 	if(sum(cat_len) == 0)
% 		continue;
% 	end

% 	prop_tf = repelems(prop_tf, [1:prop_num ; cat_len]);
% 	prop_df = repelems(prop_df, [1:prop_num ; cat_len]);

% 	cat_idx = [cat_t{:}];

% 	cat_df = category_df(cat_idx);

% 	c443_tf = zeros(cat_num, 1);
% 	[U, ~, J] = unique(cat_idx);
% 	R = accumarray(J', 1);
% 	c443_tf(U) = R(:);

% 	cat_tf = c443_tf(cat_idx);

% 	TF = prop_tf(:) .* cat_tf(:);
% 	DF = prop_df(:) .* cat_df(:);

% 	ref_tf = zeros(1, cat_num);
% 	ref_df = zeros(1, cat_num);

% 	temp_tf = accumarray(J(:), TF(:));
% 	temp_df = accumarray(J(:), DF(:));

% 	ref_tf(U) = [temp_tf(:)]';
% 	ref_df(U) = [temp_df(:)]';

% 	ref_tf = ref_tf / 100;
% 	ref_df = ref_df / 1000;

% 	if(sum(ref_tf) == 0 || sum(ref_df) == 0)
% 		break;
% 	end

% 	ref_tf = ref_tf / (ref_tf * ref_tf')^0.5;
% 	ref_df = ref_df / (ref_df * ref_df')^0.5;

% 	category_tf_cookie(i, :) = uint8(255 * ref_tf);
% 	category_df_cookie(i, :) = uint8(254 * ref_df + 1);

% 	% m_tf = max(ref_tf) + 0.1;
% 	% m_df = max(ref_df) + 0.1;
% 	% category_tf_cookie(i, :) = uint8(255 * ref_tf / m_tf);
% 	% category_df_cookie(i, :) = uint8(255 * ref_df / m_df);
% 	% uint8(255 * log10(1 + 10 * (ref_df / m_df)));

%  	if(mod(i, 500) == 0)
% 		fprintf('... %d ck-category refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% save -binary 'new_join/category_refine_cookie.join' category_tf_cookie category_df_cookie;



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


% dev_num = length(property_member_device);
% cat_num = length(category);
% category_tf_device = uint8(zeros(dev_num, cat_num));
% category_df_device = uint8(zeros(dev_num, cat_num));

% for i = 1 : dev_num
% 	prop_dev = property_member_device{i};
	
% 	if(isempty(prop_dev))
% 		continue;
% 	end
% 	% prop_num = length(prop_dev);
% 	% [bool prop_idx] = ismember(prop_dev, property);


% 	prop_tf = property_feature_device{i};
% 	% [S t] = sort(prop_tf, 'descend');
% 	% t = t(S > 0.7 * S(1));
% 	% prop_tf = prop_tf(t);
% 	[bool prop_idx] = ismember(prop_dev, property);
% 	prop_num = sum(bool);


% 	prop_df = property_df(prop_idx, 1);

% 	cat_t = cat_member(prop_idx);

% 	if(isempty(cat_t))
% 		continue;
% 	end

% 	cat_len = [cellfun('length', cat_t)]';

% 	prop_tf = repelems(prop_tf, [1:prop_num ; cat_len]);
% 	prop_df = repelems(prop_df, [1:prop_num ; cat_len]);

% 	cat_idx = [cat_t{:}];

% 	cat_df = category_df(cat_idx);

% 	c443_tf = zeros(cat_num, 1);
% 	[U, ~, J] = unique(cat_idx);
% 	R = accumarray(J', 1);
% 	c443_tf(U) = R(:);

% 	cat_tf = c443_tf(cat_idx);

% 	TF = prop_tf(:) .* cat_tf(:);
% 	DF = prop_df(:) .* cat_df(:);

% 	ref_tf = zeros(1, cat_num);
% 	ref_df = zeros(1, cat_num);

% 	temp_tf = accumarray(J(:), TF(:));
% 	temp_df = accumarray(J(:), DF(:));

% 	ref_tf(U) = [temp_tf(:)]';
% 	ref_df(U) = [temp_df(:)]';

% 	ref_tf = ref_tf / 100;
% 	ref_df = ref_df / 1000;

% 	ref_tf = ref_tf / (ref_tf * ref_tf')^0.5;
% 	ref_df = ref_df / (ref_df * ref_df')^0.5;

% 	category_tf_device(i, :) = uint8(255 * ref_tf);
% 	category_df_device(i, :) = uint8(254 * ref_df + 1);


% 	% m_tf = max(ref_tf) + 0.1;
% 	% m_df = max(ref_df) + 0.1;
% 	% category_tf_device(i, :) = uint8(255 * (ref_tf / m_tf));
% 	% category_df_device(i, :) = uint8(255 * (ref_df / m_df));

%  	if(mod(i, 500) == 0)
% 		fprintf('... %d dev-category refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');



% save -binary 'new_join/category_refine_devie.join' category_tf_device category_df_device;



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



% ck_num = length(property_member_cookie);
% cat_num = length(category);
% category_tf_cookie = uint8(zeros(ck_num, cat_num));
% category_df_cookie = uint8(zeros(ck_num, cat_num));

% for i = 1 : ck_num
% 	prop_ck = property_member_cookie{i};
	
% 	if(isempty(prop_ck))
% 		continue;
% 	end
% 	prop_num = length(prop_ck);
% 	[bool prop_idx] = ismember(prop_ck, property);


% 	prop_tf = property_feature_cookie{i};
% 	prop_df = property_df(prop_idx, 1);

% 	cat_t = cat_member(prop_idx);

% 	if(isempty(cat_t))
% 		continue;
% 	end

% 	cat_len = [cellfun('length', cat_t)]';

% 	prop_tf = repelems(prop_tf, [1:prop_num ; cat_len]);
% 	prop_df = repelems(prop_df, [1:prop_num ; cat_len]);

% 	cat_idx = [cat_t{:}];

% 	cat_df = category_df(cat_idx);

% 	c443_tf = zeros(cat_num, 1);
% 	[U, ~, J] = unique(cat_idx);
% 	R = accumarray(J', 1);
% 	c443_tf(U) = R(:);

% 	cat_tf = c443_tf(cat_idx);

% 	TF = prop_tf(:) .* cat_tf(:);
% 	DF = prop_df(:) .* cat_df(:);

% 	ref_tf = zeros(1, cat_num);
% 	ref_df = zeros(1, cat_num);

% 	temp_tf = accumarray(J(:), TF(:));
% 	temp_df = accumarray(J(:), DF(:));

% 	ref_tf(U) = [temp_tf(:)]';
% 	ref_df(U) = [temp_df(:)]';
% 	m_tf = max(ref_tf) + 0.1;
% 	m_df = max(ref_df) + 0.1;

% 	category_tf_cookie(i, :) = uint8(255 * (ref_tf / m_tf));
% 	category_df_cookie(i, :) = uint8(255 * (ref_df / m_df));


%  	if(mod(i, 500) == 0)
% 		fprintf('... %d ck-category refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');

% save -binary 'new_join/category_refine_cookie.join' category_tf_cookie category_df_cookie;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




% dev_num = length(property_member_device);
% cat_num = length(category);
% category_tf_device = uint8(zeros(dev_num, cat_num));
% category_df_device = uint8(zeros(dev_num, cat_num));

% for i = 1 : dev_num
% 	prop_dev = property_member_device{i};
	
% 	if(isempty(prop_dev))
% 		continue;
% 	end
% 	prop_num = length(prop_dev);
% 	[bool prop_idx] = ismember(prop_dev, property);


% 	prop_tf = property_feature_device{i};
% 	prop_df = property_df(prop_idx, 1);

% 	cat_t = cat_member(prop_idx);

% 	if(isempty(cat_t))
% 		continue;
% 	end

% 	cat_len = [cellfun('length', cat_t)]';

% 	prop_tf = repelems(prop_tf, [1:prop_num ; cat_len]);
% 	prop_df = repelems(prop_df, [1:prop_num ; cat_len]);

% 	cat_idx = [cat_t{:}];

% 	cat_df = category_df(cat_idx);

% 	c443_tf = zeros(cat_num, 1);
% 	[U, ~, J] = unique(cat_idx);
% 	R = accumarray(J', 1);
% 	c443_tf(U) = R(:);

% 	cat_tf = c443_tf(cat_idx);

% 	TF = prop_tf(:) .* cat_tf(:);
% 	DF = prop_df(:) .* cat_df(:);

% 	ref_tf = zeros(1, cat_num);
% 	ref_df = zeros(1, cat_num);

% 	temp_tf = accumarray(J(:), TF(:));
% 	temp_df = accumarray(J(:), DF(:));

% 	ref_tf(U) = [temp_tf(:)]';
% 	ref_df(U) = [temp_df(:)]';
% 	m_tf = max(ref_tf) + 0.1;
% 	m_df = max(ref_df) + 0.1;

% 	category_tf_device(i, :) = uint8(255 * (ref_tf / m_tf));
% 	category_df_device(i, :) = uint8(255 * (ref_df / m_df));


%  	if(mod(i, 500) == 0)
% 		fprintf('... %d dev-category refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');



% save -binary 'new_join/category_refine_devie.join' category_tf_device category_df_device;




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




% [bool c1_idx_dev]=ismember(basic_device(:,5), device_c1_id);
% [bool c2_idx_dev]=ismember(basic_device(:,6), device_c2_id);
% cx_index_device = int32([c1_idx_dev(:) c2_idx_dev(:)]);

% [bool c1_idx_ck]=ismember(basic_cookie(:,5), cookie_c1(:, 1));
% [bool c2_idx_ck]=ismember(basic_cookie(:,6), cookie_c2(:, 1));
% cx_index_cookie = int32([c1_idx_ck(:) c2_idx_ck(:)]);



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




% standin_c1 = dc_c1_pairs;
% standin_c2 = dc_c2_pairs;

% c1_num = length(standin_c1);
% c2_num = length(standin_c2);


% for i = 1 : c1_num
% 	temp = standin_c1{i};
% 	[U, ~, J] = unique(temp);
% 	R = accumarray(J', 1);
% 	[bool c1_idx] = ismember(U, cookie_c1(:, 1));

% 	temp = int32([[U(:)]' ; [R(:)]' ; [c1_idx(:)]']);

% 	standin_c1{i} = temp;

% 	if(mod(i, 100) == 0)
% 		fprintf('... %d cookie-c1 refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');



% for i = 1 : c2_num
% 	temp = standin_c2{i};
% 	[U, ~, J] = unique(temp);
% 	R = accumarray(J', 1);
% 	[bool c2_idx] = ismember(U, cookie_c2(:, 1));

% 	temp = int32([[U(:)]' ; [R(:)]' ; [c2_idx(:)]']);

% 	standin_c2{i} = temp;

% 	if(mod(i, 1000) == 0)
% 		fprintf('... %d cookie-c2 refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



% standin = dc_filter_train;
% dev_num = length(standin);
% temp = [standin{:}];
% [bool ck_idx] = ismember(temp(1, :), cookie);
% temp = [temp ; [ck_idx(:)]'];
% len = cellfun('columns', standin);

% idx = 1;
% for i = 1 : dev_num

% 	standin{i} = temp(:, idx : idx + len(i) - 1);
% 	idx = idx + len(i);

% 	if(mod(i, 1000) == 0)
% 		fprintf('... %d filter refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



% dev_num = length(device);
% ip_refine_device_idx = cell(dev_num, 1);


% for i = 1 : dev_num

% 	ip_temp = ip_refine_device{i}(:, 1);
% 	[bool ip_idx] = ismember(ip_temp, ip_light);
% 	ip_refine_device_idx{i} = int32(ip_idx');

% 	if(mod(i, 1000) == 0)
% 		fprintf('... %d dev-ip refined ...\r', i);
% 		fflush(stdout);
% 	end

% end
% fprintf('\n');

% save -binary 'new_join/device_train.join' device ip_refine_device basic_device ip_refine_device_idx





% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



% han_num = length(handle);
% standin = member;


% void_idx = [];
% void_num = 0;
% for i = 1 : han_num

% 	m_num = rows(standin{i});
% 	m_t = [standin{i} zeros(m_num, 1)];

% 	for j = 1 : m_num

% 		if(m_t(j, 2) == 0)
% 			m_t(j, 3) = find(m_t(j, 1) == device);
% 		else
% 			idx = find(m_t(j, 1) == cookie);
% 			if(isempty(idx))
% 				void_idx = [void_idx i];
% 				fprintf('\n... void number: %d(handle idx: %d) ...\n', void_num++, i);
% 				fflush(stdout);
% 				m_t(j, 3) = 0;
% 			else
% 				m_t(j, 3) = idx;
% 			end
			
% 		end
% 	end

% 	standin{i} = m_t;

% 	if(mod(i, 500) == 0)
% 		fprintf('... %d member refined ...\r', i);
% 		fflush(stdout);
% 	end
% end
% fprintf('\n');

% save -binary 'new_join/handle.join' handle member void_idx;







