clear;
clc;


if(!exist('cookie_pair_num', 'var'))
	load 'joint/device_cookie_distribution'; % cookie_pair_num
end

if(!exist('predict_cookie_score', 'var'))
	load 'prediction/predict_cookie_score.pd'; % predict_cookie_score
end

if(!exist('test_device', 'var'))
	load 'joint/test_device.joint';  % test_device test_device_ip_member test_device_cookie_list
end

test_num = length(test_device);
% len1 = cellfun('length', predict_cookie_score);
% len2 = cellfun('length', test_device_cookie_list);
% disp(test_num);
% sum(len1 == len2)

cand_num = zeros(test_num, 1);
cand_list = cell(test_num, 1);
threshold = 0.8;

fid = fopen('whatever.csv', 'w');
fprintf(fid, 'device_id,cookie_id\n');

for i = 1 : test_num
	cand_num(i) = sum(predict_cookie_score{i} > threshold);
	cand_list{i} = test_device_cookie_list{i}(find(predict_cookie_score{i} > threshold));

	m = length(cand_list{i});
	if(m > 0)
		s = repmat('id_%d ', [1, m]);
		fprintf(fid, ['id_%d,' s '\n'], test_device(i), cand_list{i});
	else
		fprintf(fid, ['id_%d, \n'], test_device(i));
	end
	

	if(mod(i, 500) == 0)
		fprintf('... %d test sample completed ... \r', i);
		fflush(stdout);
	end

end

fprintf('\n');
fprintf('training-mean: %f\n', mean(cookie_pair_num));
fprintf('training-std: %f\n', std(cookie_pair_num));
fprintf('mean: %f\n', mean(cand_num));
fprintf('std: %f\n', std(cand_num));

fclose(fid);





