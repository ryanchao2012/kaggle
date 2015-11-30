clc;
close all;


if(!exist('model/model_v0.nn'))
	fprintf('... Model Does Not exist! ...\n');
	return;
end

if(!exist('training_set', 'var'))
	load 'training_data/training_set.join';
end

lambda = 0.01;
opt = optimset('MaxIter', 50);

sample_num = rows(training_set);
test_num = 100;

Pre = zeros(test_num, 2);
Rec = zeros(test_num, 2);
Fs = zeros(test_num, 2);

for i = 1 : test_num

	_pre = zeros(1, 2);
	_rec = zeros(1, 2);
	_fs = zeros(1, 2);

	% for j = 1 : 2
		shuffle = randperm(sample_num);
		tr_set = training_set(shuffle(1 : i * 50 + 5000), :);

		X_norm = feature_normalization(tr_set(:, 1 : end - 1));
		[Xtrain Xval Ytrain Yval] = sample_seperate([X_norm tr_set(:, end)]);
		load 'model/model_v0.nn';
		func = @(p) cost_function(p, layer_size, Xtrain, Ytrain, lambda);
		[wv, cost] = fmincg(func, list_to_vector(weight_list), opt);
		wl = vector_to_list(wv, layer_size);

		O = nn_forward(wl, Xtrain);
		printf('training:\r\n');
		[_at _pt _rt _ft] = training_result(O, Ytrain);

		O = nn_forward(wl, Xval);
		printf('validate:\n');
		[_av _pv _rv _fv] = training_result(O, Yval);
		printf('==========\n');

		% if(j == 2)
		% 	_pre = (_pre + [_pt _pv])/2;
		% 	_rec = (_rec + [_rt _rv])/2;
		% 	_fs = (_fs + [_ft _fv])/2;
		% else
			_pre = [_pt _pv];
			_rec = [_rt _rv];
			_fs = [_ft _fv];
		% end

	% end

	Pre(i, :) = _pre;
	Rec(i, :) = _rec;
	Fs(i, :) = _fs;

end

a=Fs(1:2:end,:);
b=Fs(2:2:end,:);
csvwrite('learning_curve.csv', (a+b)/2);
