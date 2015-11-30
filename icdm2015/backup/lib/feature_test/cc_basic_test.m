% clear; clc;
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(exist('model/model_v0.nn') == 0)
	printf('... Model Does Not exist! ...\n');
	return;
end

% load 'model/model_v0.nn';

test_num = 3;
nNum = 5000;
skew_ratio = 0.1;
pNum = 1 + round(skew_ratio * nNum);
opt = optimset('MaxIter', 500);
lambda = 0.03;



fprintf('... Randomly select %d:%d(P:N) positive/negative samples ...\n\r', pNum, nNum);
fflush(stdout);


handle_num = length(handle);

for i = 1 : test_num

	load 'model/model_v0.nn';

	samples = cc_sample_basic(handle_num, member, feature_basic, pNum, nNum);
	[Xtrain Xval Ytrain Yval] = sample_seperate(samples);
	[X mu sigma] = feature_normalization(Xtrain);
	func = @(p) cost_function(p, layer_size, X, Ytrain, lambda);
	[wv, cost] = fmincg(func, list_to_vector(weight_list), opt);
	wl = vector_to_list(wv, layer_size);

	O = nn_forward(wl, X);
	printf('training:\r\n');
	training_result(O, Ytrain);

	[X mu sigma] = feature_normalization(Xval);
	O = nn_forward(wl, X);
	printf('validate:\r\n');
	training_result(O, Yval);
	printf('==========\r\n');

end











