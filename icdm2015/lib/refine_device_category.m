clc; clear('all');
close all;


if(!exist('property_member_device', 'var')) % property_member_device property_feature_device
	load 'new_join/property_device.join'; 
end



if(!exist('property', 'var')) % property property_df cat_member
	load 'new_join/property.join'; 
end


if(!exist('category', 'var')) % category category_df
	load 'new_join/category.join';
end


fprintf('... Env prepared ...\n');
fflush(stdout);

dev_num = length(property_member_device);
cat_num = length(category);
category_tf_device = uint8(zeros(dev_num, cat_num));
category_df_device = uint8(zeros(dev_num, cat_num));

for i = 1 : dev_num
	prop_dev = property_member_device{i};
	
	if(isempty(prop_dev))
		continue;
	end
	% prop_num = length(prop_dev);
	% [bool prop_idx] = ismember(prop_dev, property);


	prop_tf = property_feature_device{i};
	% [S t] = sort(prop_tf, 'descend');
	% t = t(S > 0.7 * S(1));
	% prop_tf = prop_tf(t);
	[bool prop_idx] = ismember(prop_dev, property);
	prop_num = sum(bool);


	prop_df = property_df(prop_idx, 1);

	cat_t = cat_member(prop_idx);

	if(isempty(cat_t))
		continue;
	end

	cat_len = [cellfun('length', cat_t)]';

	prop_tf = repelems(prop_tf, [1:prop_num ; cat_len]);
	prop_df = repelems(prop_df, [1:prop_num ; cat_len]);

	cat_idx = [cat_t{:}];

	cat_df = category_df(cat_idx);

	c443_tf = zeros(cat_num, 1);
	[U, ~, J] = unique(cat_idx);
	R = accumarray(J', 1);
	c443_tf(U) = R(:);

	cat_tf = c443_tf(cat_idx);

	TF = prop_tf(:) .* cat_tf(:);
	DF = prop_df(:) .* cat_df(:);

	ref_tf = zeros(1, cat_num);
	ref_df = zeros(1, cat_num);

	temp_tf = accumarray(J(:), TF(:));
	temp_df = accumarray(J(:), DF(:));

	ref_tf(U) = [temp_tf(:)]';
	ref_df(U) = [temp_df(:)]';

	ref_tf = ref_tf / 100;
	ref_df = ref_df / 1000;

	ref_tf = ref_tf / (ref_tf * ref_tf')^0.5;
	ref_df = ref_df / (ref_df * ref_df')^0.5;

	category_tf_device(i, :) = uint8(255 * ref_tf);
	category_df_device(i, :) = uint8(254 * ref_df + 1);


	% m_tf = max(ref_tf) + 0.1;
	% m_df = max(ref_df) + 0.1;
	% category_tf_device(i, :) = uint8(255 * (ref_tf / m_tf));
	% category_df_device(i, :) = uint8(255 * (ref_df / m_df));

 	if(mod(i, 500) == 0)
		fprintf('... %d dev-category refined ...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');



save -binary 'new_join/category_refine_devie.join' category_tf_device category_df_device;

