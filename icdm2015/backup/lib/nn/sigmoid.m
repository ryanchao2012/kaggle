function g = sigmoid(z)
	g = 1.0 ./ (ones(size(z)) + exp(-z));
end
