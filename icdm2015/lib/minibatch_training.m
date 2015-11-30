clc;
close all;


if(exist('model/model_v0.nn'))
	load 'model/model_v0.nn';
else
	fprintf('... Model Does Not exist! ...\n');
	return;
end

if(!exist('training_set', 'var'))
	load 'training_data/training_set.join';
end

standin = training_set;
clear training_set;

if(exist('model/performance.join'))
	load 'model/performance.join';
else
	cost_value = [];
	precision = [];            % [training ; validation]
	recall = [];               % [training ; validation]
	feature_mean = [];
	feature_std = [];

	save -binary 'model/performance.join' cost_value precision recall feature_mean feature_std;
end

lambda = 0.1;
opt = optimset('MaxIter', 25);

threshold = 0.5;
wl = weight_list;

% i = find(standin(:, 12) == 1);
% standin(i, :) = [];
% standin(:, 12) = [];
sample_num = rows(standin);
for i = 1 : 10

	mini_idx = randperm(sample_num)(1 : 30000);
	% x0 = standin(mini_idx, 1 : 13);
	% x1 = sum(standin(mini_idx, 14 : 16), 2);
	% x2 = standin(mini_idx, 17);
	% x3 = sum(standin(mini_idx, 18 : 22), 2);
	% x4 = standin(mini_idx, 23);
	% x5 = sum(standin(mini_idx, 24 : 28), 2);
	% x6 = standin(mini_idx, 29);

	% X = [x0 x1 x2 x3 x4 x5 x6];
	X = standin(mini_idx, 1 : end - 1);

	Y = standin(mini_idx, end);

	[X_norm mu sigma] = feature_normalization(X);
	[Xtrain Xval Ytrain Yval] = sample_seperate([X_norm Y]);

	func = @(p) cost_function(p, layer_size, Xtrain, Ytrain, lambda);
	[wv cost] = fmincg(func, list_to_vector(wl), opt);
	wl = vector_to_list(wv, layer_size);


	printf('===== %d =====\n', i);
	O = nn_forward(wl, Xtrain);
	printf('training:\n');
	[at pt rt ft] = training_result(O, Ytrain, threshold);

	O = nn_forward(wl, Xval);
	printf('validation:\n');
	[av pv rv fv] = training_result(O, Yval, threshold);
	printf('\n');

	if(sum(isnan([pt rt pv fv])) > 0)
		disp('woops!');
		continue;
	end

	weight_list = wl;
	cost_value = [cost_value mean(cost)];
	precision = [precision [pt ; pv]];
	recall = [recall [rt ; rv]];
	feature_mean = [feature_mean ; mu];
	feature_std = [feature_std ; sigma];

end



save -binary 'model/model_v0.nn' weight_list layer_size;
save -binary 'model/performance.join' cost_value precision recall feature_mean feature_std;





