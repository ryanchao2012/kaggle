clear;
clc;


if(!exist('predict_cookie_score', 'var'))
	load 'prediction/predict_cookie_score.pd'; % predict_cookie_score
end

if(!exist('candidate_set', 'var'))   % candidate_set
	load 'test_set/candidate_set.join'; 
end


if(!exist('device_test', 'var'))
	load 'new_join/device_test.join';  % device_test ...
end

test_num = length(device_test);

cand_num = zeros(test_num, 1);
cand_list = cell(test_num, 1);
threshold = 0.15;

fid = fopen('final.csv', 'w');
fprintf(fid, 'device_id,cookie_id\n');

for i = 1 : test_num
	cand_num(i) = sum(predict_cookie_score{i} > threshold);
	cand_list{i} = candidate_set{i}(find(predict_cookie_score{i} > threshold));

	m = length(cand_list{i});
	if(m > 0)
		s = repmat('id_%d ', [1, m]);
		fprintf(fid, ['id_%d,' s '\n'], device_test(i), cand_list{i});
	else
		fprintf(fid, ['id_%d, \n'], device_test(i));
	end
	

	if(mod(i, 500) == 0)
		fprintf('... %d test sample completed ... \r', i);
		fflush(stdout);
	end

end

fprintf('\n');
% fprintf('training-mean: %f\n', mean(cookie_pair_num));
% fprintf('training-std: %f\n', std(cookie_pair_num));
fprintf('mean: %f\n', mean(cand_num));
fprintf('std: %f\n', std(cand_num));

fclose(fid);





