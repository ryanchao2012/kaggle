function output = nn_forward(wl, X)
	weight_num = size(wl, 1);
	m = size(X, 1);
	A = [ones(m, 1) X];
	for i = 1 : weight_num
		W = wl{i};
		Z = A * W';
		A = [ones(m, 1) sigmoid(Z)];
	end
	output = Z;
end