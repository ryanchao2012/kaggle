function [Xtrain Xval Ytrain Yval] = sample_seperate(samples, validation_ratio = 0.3)
	X = samples(:, 1 : end - 1);
	% unknown = sum(X == -1, 2);
	% X = X(find(unknown == 0), :);

	Y = samples(:, end);
	% Y = Y(find(unknown == 0));

	positive_idx = find(Y == 1);
	negative_idx = find(Y == 0);

	pNum = length(positive_idx);
	nNum = length(negative_idx);

	positive_idx = positive_idx(randperm(pNum));
	negative_idx = negative_idx(randperm(nNum));

	pNum_val = round(pNum * validation_ratio);
	nNum_val = round(nNum * validation_ratio);

	Xval = [X(positive_idx(1 : pNum_val), :) ; X(negative_idx(1 : nNum_val), :)];
	Yval = [Y(positive_idx(1 : pNum_val), :) ; Y(negative_idx(1 : nNum_val), :)];

	Xtrain = [X(positive_idx(pNum_val + 1 : end), :) ; X(negative_idx(nNum_val + 1 : end), :)];
	Ytrain = [Y(positive_idx(pNum_val + 1 : end), :) ; Y(negative_idx(nNum_val + 1 : end), :)];

end

