% clear; clc;

if(!exist('category', 'var'))
	load 'joint/category.joint';
end

if(!exist('property', 'var'))
	load 'joint/property.joint';
end

prop_num = length(property);
cat_num = length(category);
category_weight = zeros(1, cat_num);

tic;
for i = 1 : cat_num
	x = cellfun('ismember', {category(i)}, cat_member, 'UniformOutput', false);
	category_weight(i) = log(prop_num / (1 + sum([x{:}])));
	t = toc;
	fprintf('... The %d-th category-weight recorded, elapsed time: %3.2f ...\r', i, t);
	fflush(stdout);
	tic;
end


fprintf('\n');


save -binary 'joint/category.joint' category category_weight;

