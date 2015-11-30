function check_nn_gradient(input_size, label_size, hidden_num, batch_size, lambda = 0)

	if(input_size > 5 || label_size > 5 || hidden_num > 4 || batch_size > 5)
		printf('Some Of The Input Parameters Are Too Large!\n');
		return;
	end


	weight_num = hidden_num + 1;
	try
		layer_ratio = (input_size / label_size) ^ (1 / weight_num);
	catch
		printf('Layer Ratio Error!\n');
		return;
	end

	layer_size = zeros(weight_num + 1, 1);
	layer_size(1) = input_size;
	layer_size(weight_num + 1) = label_size;
	for i = 2 : weight_num
		layer_size(i) = round(layer_size(i - 1) / layer_ratio);
	end

	weight_list = cell(weight_num, 1);

	for i = 1 : weight_num
		weight_list{i} = rand(layer_size(i+1), layer_size(i) + 1) - rand(layer_size(i+1), layer_size(i) + 1);
	end

	weight_vector = list_to_vector(weight_list);

	X = rand(batch_size, input_size);
	Y = rand(batch_size, label_size);
	% y  = 1 + mod(1 : batch_size, label_size)';
	% Y = y * ones(1, label_size) == ones(batch_size, 1) * [1 : label_size];

	% Short hand for cost function
	costFunc = @(p) cost_function(p, layer_size, X, Y, lambda);

	[cost, grad] = costFunc(weight_vector);
	numgrad = compute_numerical_gradient(costFunc, weight_vector);

	% Visually examine the two gradient computations.  The two columns
	% you get should be very similar. 
	disp(numgrad - grad);
	fprintf(['The above two columns you get should be very similar.\n' ...
	         '(Left-Your Numerical Gradient, Right-Analytical Gradient)\n\n']);

	% Evaluate the norm of the difference between two solutions.  
	% If you have a correct implementation, and assuming you used EPSILON = 0.0001 
	% in computeNumericalGradient.m, then differ below should be less than 1e-9
	differ = norm(numgrad-grad)/norm(numgrad+grad);

	fprintf(['If your backpropagation implementation is correct, then \n' ...
	         'the relative difference will be small (less than 1e-9). \n' ...
	         '\nRelative Difference: %g\n'], differ);
end
