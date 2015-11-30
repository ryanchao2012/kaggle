clc;
close all;



if(!exist('property_member_device', 'var'))
	load 'new_join/property_device.join'; % property_member_device property_feature_device prop_idx_dev curr_idx_dev
end


if(!exist('property_member_cookie', 'var'))
	load 'new_join/property_cookie.join'; % property_member_cookie property_feature_cookie prop_idx_ck curr_idx_ck
end


prop_dev_buff = [property_member_device{:}];
prop_ck_buff = [property_member_cookie{:}];

property = int32(unique([prop_dev_buff prop_ck_buff]));

fprintf('... Env prepared ...\n');
fflush(stdout);

prop_num = length(property);

property_df = zeros(prop_num, 2);

[U, ~, J] = unique(prop_dev_buff);
prp_dev = [accumarray(J', 1), U'];


[U, ~, J] = unique(prop_ck_buff);
prp_ck = [accumarray(J', 1), U'];


[bool dev_idx] = ismember(prp_dev(:, 2), property);
[bool ck_idx] = ismember(prp_ck(:, 2), property);

dev_num = rows(prp_dev);
ck_num = rows(prp_ck);



for i = 1 : dev_num
	property_df(dev_idx(i), 1) = prp_dev(i, 1);

	if(mod(i, 1000) == 0)
		fprintf('... %d-th prop(device) count...\r', i);
		fflush(stdout);
	end
end
fprintf('\n');


for i = 1 : ck_num
	property_df(ck_idx(i), 2) = prp_ck(i, 1);

	if(mod(i, 1000) == 0)
		fprintf('... %d-th prop(cookie) count...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');


property_df = int32(property_df);

save -binary 'new_join/property.join' property property_df;









