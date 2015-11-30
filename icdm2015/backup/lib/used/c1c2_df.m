clc;
close all;

if(!exist('cookie', 'var'))   % basic_cookie cookie ip_member_cookie prop_member_cookie prop_feature_cookie
	load 'joint/cookie.joint';
end

if(!exist('c1_id', 'var') || !exist('c2_id', 'var'))   % c1_id c2_id c1_pairs c2_pairs
	load 'joint/c1c2_pair.joint';
end


tic;
temp = [cellfun('sscanf', basic_cookie, {'%f,%f,%f,%f,%f,%f,%f,%f,%f,'}, 'UniformOutput', false){:}]';
toc;

c1_buff = temp(:, 5);
c1_buff(find(c1_buff == -1)) = [];
c2_buff = temp(:, 6);
c2_buff(find(c2_buff == -1)) = [];

cookie_c1_id = unique(c1_buff);
cookie_c2_id = unique(c2_buff);

c1_num = length(cookie_c1_id);
c2_num = length(cookie_c2_id);

cookie_c1_df = zeros(c1_num, 1);
cookie_c2_df = zeros(c2_num, 1);

for i = 1 : c1_num
	cookie_c1_df(i) = sum(cookie_c1_id(i) == c1_buff);
end

for i = 1 : c2_num
	cookie_c2_df(i) = sum(cookie_c2_id(i) == c2_buff);
end


device_c1_id = c1_id;
device_c2_id = c2_id;

dc_c1_pairs = c1_pairs;
dc_c2_pairs = c2_pairs;

save -binary 'joint/c1c2_pair.joint' device_c1_id device_c2_id dc_c1_pairs dc_c2_pairs cookie_c1_id cookie_c2_id cookie_c1_df cookie_c2_df;
