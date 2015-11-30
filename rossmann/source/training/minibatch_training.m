clc;
close all;


if(exist('model/model_v0.nn'))
	load 'model/model_v0.nn';
else
	fprintf('... Model Does Not exist! ...\n');
	return;
end



if(!exist('training_set', 'var'))
	load 'training_set/training_set.join';
end

if(exist('model/performance.join'))
	load 'model/performance.join';
else
	error_rate = [];

	save -binary 'model/performance.join' error_rate;
end

sample_num = rows(training_set.X);
lambda = 0.01;
opt = optimset('MaxIter', 100);
batch_size = 5000;
valid_ratio = 0.3;

wl = weight_list;

for i = 1 : 20

	mini_idx = randperm(sample_num)(1 : batch_size);
	training_num = round(length(mini_idx) * (1 - valid_ratio));

	Xtrain = training_set.X(mini_idx(1 : training_num), :);
	Ytrain = training_set.Y(mini_idx(1 : training_num), :);
	% Xtrain(:, 1 : 9) = Ytrain;

	Xval = training_set.X(mini_idx(training_num + 1 : end), :);
	Yval = training_set.Y(mini_idx(training_num + 1 : end), :);
	% Xval(:, 1 : 9) = Yval;

	func = @(p) cost_function(p, layer_size, Xtrain, Ytrain, lambda);
	[wv cost] = fmincg(func, list_to_vector(wl), opt);
	wl = vector_to_list(wv, layer_size);


	printf('===== %d =====\n', i);
	O = nn_forward(wl, Xtrain);

	er_tr = sales_error(O, Ytrain);
	fprintf('Training error: \n');
	fprintf('  %1.3f \n', er_tr);

	O = nn_forward(wl, Xval);

	er_val = sales_error(O, Yval);
	fprintf('  Validation error: \n');
	fprintf('  %1.3f \n', er_val);
	printf('\n');


	weight_list = wl;
	error_rate = [error_rate [er_tr ; er_val]];

end


% plot(O');
% hold on;
% plot(Yval');
% hold off;


save -binary 'model/model_v0.nn' weight_list layer_size;
save -binary 'model/performance.join' error_rate;











