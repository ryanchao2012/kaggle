clc;
close all;


if(!exist('model/model_v0.nn'))
	fprintf('... Model Does Not exist! ...\n');
	return;
end

if(exist('training_data/training_set.join'))
	load 'training_data/training_set.join';
else
	fprintf('... Training-set Does Not exist! ...\n');
	return;
end

lambda = 0.1;
opt = optimset('MaxIter', 500);
load 'model/model_v0.nn';

tr_set = training_set(1:end, :);
clear training_set;

[X_norm, mu, sigma] = feature_normalization(tr_set(:, 1 : end - 1));

[Xtrain Xval Ytrain Yval] = sample_seperate([X_norm tr_set(:, end)]);

func = @(p) cost_function(p, layer_size, Xtrain, Ytrain, lambda);
[wv, cost] = fmincg(func, list_to_vector(weight_list), opt);
wl = vector_to_list(wv, layer_size);

O = nn_forward(wl, Xtrain);
printf('training:\r\n');
training_result(O, Ytrain);

O = nn_forward(wl, Xval);
printf('validate:\n');
training_result(O, Yval);
printf('==========\n');


