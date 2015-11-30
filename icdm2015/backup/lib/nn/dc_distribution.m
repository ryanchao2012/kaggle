clear all;
clc;

load 'joint/handle.joint'; % handle member feature_basic



cookie_pair_num = [];

hd_num = length(handle);



for i = 1 : hd_num
	n_ck = sum(member{i}(:, end));
	n_dev = rows(member{i}) - n_ck;

	cookie_pair_num = [cookie_pair_num n_ck * ones(1, n_dev)];


	if(mod(i, 500) == 0)
		fprintf('... %d handle scanned ...\r', i);
		fflush(stdout);
	end

end

fprintf('\n');


save -binary 'joint/device_cookie_distribution' cookie_pair_num;
