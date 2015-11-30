clc;
close all;


if(exist('model/model_v0.nn'))
	load 'model/model_v0.nn';
else
	fprintf('... Model Does Not exist! ...\n');
	return;
end

if(!exist('training_set_alt', 'var'))
	load 'training_data/training_set_alt.join';
end

standin = training_set_alt;
clear training_set_alt;

load 'training_data/training_distribution'; % training_mean  training_std



sample_num = rows(standin);
threshold = 0.5;

i = find(standin(:, 12) == 1);
standin(i, :) = [];
% standin(:, 12) = [];
sample_num = rows(standin);

for i = 1 : 5

	mini_idx = randperm(sample_num)(1 : 5000);
	% x0 = training_set_alt(mini_idx, [1 2 19]);
	% x1 = sum(training_set_alt(mini_idx, 3 : 6), 2);
	% x2 = sum(training_set_alt(mini_idx, 7 : 12), 2);
	% x3 = sum(training_set_alt(mini_idx, 13 : 18), 2);
	% X = [x0 x1 x2 x3];
	% X = [x0 x1 x2 x3 x1.*x2 x2.*x3 x1.*x3];
	X = standin(mini_idx, 1 : end - 1);
	% X(:, 3) = power(X(:, 3), 0.5);
	% X(:, 3) = log(X(:, 3)+1);
	% X(:, 5) = log(X(:, 5)+1);
	% X(:, 6) = log(X(:, 6)+1);
	Y = standin(mini_idx, end);
	[X_norm mu sigma] = feature_normalization(X);
	% X_norm = (X -  ones(rows(X), 1) * training_mean) ./ (ones(rows(X), 1) * training_std);


	printf('===== %d =====\n', i);
	O = nn_forward(weight_list, X_norm);

	% P = O(find(Y == 1));
	% N = O(find(Y == 0));

	printf('test:\n');
	training_result(O, Y, threshold);
	% printf('FP: %f, FN: %f \n', sum(N > threshold)/length(N), sum(P < threshold)/length(P));
	fflush(stdout);

end






