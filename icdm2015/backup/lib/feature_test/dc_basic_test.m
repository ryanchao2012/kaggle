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

test_num = 10;
% nNum = 2000;
% skew_ratio = 1;
% pNum = 1 + round(skew_ratio * nNum);
% opt = optimset('MaxIter', 1000);
% lambda = 0;



% fprintf('... Randomly select %d:%d(P:N) positive/negative samples ...\n\r', pNum, nNum);
% fflush(stdout);


handle_num = length(handle);
vec = [17 18];
for i = test_num : test_num

	load 'model/model_v0.nn';


	nNum = 2000 * i;
	skew_ratio = 1;
	pNum = 1 + round(skew_ratio * nNum);
	opt = optimset('MaxIter', 1000);
	lambda = 0;
	fprintf('... Randomly select %d:%d(P:N) positive/negative samples ...\n\r', pNum, nNum);
	fflush(stdout);


	samples = dc_sample_basic(handle_num, member, feature_basic, pNum, nNum);
	X = samples(:, 1 : 18);
	unknown = sum(X == -1, 2);
	known = find(unknown == 0);
	X = X(known, :);
	Y = samples(known, 19);

	ZP = unique(X(Y == 1, vec),'rows');
	ZN = unique(X(Y == 0, vec),'rows');
	ZZ = unique([ZP ; ZN],'rows');

	fprintf('%d \t %d \t %d \t %d \n\r', length(ZP), length(ZN), length(ZZ), length(Y));



	% for j = 1 : 18
	% 	a = unique(X(find(Y == 1), j));
	% 	b = unique(X(find(Y == 0), j));
	% 	c = unique([a ; b]);
	% 	fprintf('%d \t %d \t %d \t \n\r', length(a), length(b), length(c));
	% end

	% avg = mean(X);
	% s = std(X);
	% X = (X - ones(pNum + nNum, 1) * avg) ./ (ones(pNum + nNum, 1) * s);


	% [Xtrain Xval Ytrain Yval] = sample_seperate(samples);
	% [X mu sigma] = feature_normalization(Xtrain);
	% func = @(p) cost_function(p, layer_size, X, Ytrain, lambda);
	% [wv, cost] = fmincg(func, list_to_vector(weight_list), opt);
	% wl = vector_to_list(wv, layer_size);

	% O = nn_forward(wl, X);
	% printf('training:\r\n');
	% training_result(O, Ytrain);

	% [X mu sigma] = feature_normalization(Xval);
	% O = nn_forward(wl, X);
	% printf('validate:\r\n');
	% training_result(O, Yval);
	% printf('==========\r\n');

end









