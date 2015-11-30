clc;
close all;

if(!exist('cookie', 'var'))   % basic_cookie cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end

if(!exist('cookie_property_pairs', 'var'))   % cookie_property_pairs device_property_id cookie_property_df
	load 'joint/property_pair.joint';
end


cookie_property_id = unique([cookie_property_pairs{:}]);

property_num = length(cookie_property_id);
cookie_property_df = zeros(property_num, 1);

prop_buff = [cellfun('unique', cookie_property_pairs, 'UniformOutput', false){:}];



for i = 1 : property_num
	cookie_property_df(i) = sum(cookie_property_id(i) == prop_buff);

	if(mod(i, 500) == 0)
		fprintf('... %d-th prop_id count...\r', i);
		fflush(stdout);
	end
end


fprintf('\n');



save -binary 'joint/property_pair.joint' device_property_id cookie_property_pairs  cookie_property_id cookie_property_df;



