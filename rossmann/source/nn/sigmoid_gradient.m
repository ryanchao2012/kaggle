function g = sigmoid_gradient(z)
	g = sigmoid(z) .* (ones(size(z)) - sigmoid(z));
end
