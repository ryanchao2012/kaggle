clear; clc;

% % % % % % % % % % % % % % % % - source - % % % % % % % % % % % % % % % % % % % % % % % 
load 'refine/all_in_propxcat.ref';   % cat_list prop_array
load 'joint/property.joint';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('... Data loaded ...\n\r');
fflush(stdout);



buf_prop = prop_array(:, ismember(prop_array(1, :), property));


[dump i_prop] = ismember(buf_prop(1, :), property);
num_prop = length(buf_prop);
cat_member = cell(1, length(property));

category = int16([]);

for i = 1 : num_prop
	cat_member{i_prop(i)} = int16(cat_list{buf_prop(2, i) - 1});
	category = [category cat_member{i_prop(i)}];

	if(mod(i, 500) == 0)
		fprintf('%d property-category recorded...\r', i);
		fflush(stdout);
		category = unique(category);
	end

end

category = unique(category);
fprintf('\n... property-category finished ...\r\n');
fflush(stdout);

save -binary 'joint/property.joint' property prop_device prop_cookie cat_member;
save -binary 'joint/category.joint' category;


