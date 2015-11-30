function [X_norm, mu, sigma] = feature_normalization(X)

	feature_num = size(X, 2);

	X_norm = zeros(size(X));

	mu = zeros(1, feature_num);
	sigma = zeros(1, feature_num);

	for i = 1 : feature_num
		temp1 = X(:, i);
		temp2 = temp1(find(temp1 >= 0));
		mu(i) = mean(temp2);
		sigma(i) = std(temp2);
		temp1(find(temp1 < 0)) = mu(i);
		% X_norm(:, i) = (temp1 - mu(i) * ones(length(temp1), 1));
		X_norm(:, i) = (temp1 - mu(i) * ones(length(temp1), 1)) / (sigma(i) + 0.01);

	end

end
