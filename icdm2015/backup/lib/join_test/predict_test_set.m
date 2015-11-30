clear;
clc;

if(exist('model/model_v0.nn'))
	load 'model/model_v0.nn';
else
	fprintf('... Model Does Not exist! ...\n');
	return;
end


load 'test_set/training_distribution.join'; % training_mean  training_std

load 'test_set/test_set.join'; % test_set


n = length(test_set);
predict_cookie_score = cell(n, 1);

fprintf('... Env Prepared ... \n');
fflush(stdout);
feat_num = 29;

for i = 1 : n
	X = test_set{i};

	if(isempty(X))
		continue;
	end

	for j = 1 : feat_num
		temp = X(:, j);
		temp(temp < 0) = training_mean(j);
		X(:, j) = temp;
	end


	X_norm = (X -  ones(rows(X), 1) * training_mean) ./ (ones(rows(X), 1) * training_std);
	O = nn_forward(weight_list, X_norm);
	predict_cookie_score{i} = [O(:)]';


	if(mod(i, 500) == 0)
		fprintf('... %d test sample completed ... \r', i);
		fflush(stdout);
	end


end

fprintf('\n');

save -binary 'prediction/predict_cookie_score.pd' predict_cookie_score;


