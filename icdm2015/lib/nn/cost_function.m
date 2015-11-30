function [J grad] = cost_function(weight_vector, layer_size, X, Y, lambda = 0)
	weight_num = size(layer_size, 1) - 1;
	weight_list = vector_to_list(weight_vector, layer_size);

	% disp(weight_list{weight_num}(:) - weight_vector(end - layer_size(end) * (layer_size(end-1) + 1) + 1: end)(:));
	
	J = 0;
	grad = zeros(size(weight_vector));

	m = size(X, 1);

	Z_list = cell(size(layer_size, 1), 1);
	grad_list = cell(weight_num, 1);
	for i = 1 : weight_num
		grad_list{i} = zeros(size(weight_list{i}));
	end

	% try
		
		A = [ones(m, 1) X];
		Z_list{1} = X;
		for i = 1 : weight_num
			W = weight_list{i};
			Z_list{i + 1} = A * W';
			A = [ones(m, 1) sigmoid(Z_list{i + 1})];
			J = J + sum(sum(W(:, 2 : end) .* W(:, 2 : end)));  % regularization 1
		end
		O = sigmoid(Z_list{end});
		% A_list{end} = A(:, 2 : end);
		[p q] = size(O);
		% disp([p q]);
		J = J * lambda / (2 * m);  % regularization 2
		J = J - sum(sum(Y .* log(O) ...
	             + (ones(p, q) - Y) .* log(ones(p, q) - O))) / m;


		del = O - Y;
		W = weight_list{weight_num};	
		grad_list{weight_num} = del' * [ones(m, 1) sigmoid(Z_list{weight_num})] / m ...
		                        + lambda * [zeros(size(grad_list{weight_num} , 1), 1) W(:, 2 : end)] / m;


		for i = weight_num - 1 : -1 : 1
			del = del * W(:, 2 : end) .* sigmoid_gradient(Z_list{i + 1});
			W = weight_list{i};
			if i > 1
				Z = sigmoid(Z_list{i});
			else
				Z = Z_list{i};
			end
			grad_list{i} = del' * [ones(m, 1) Z] / m ...
			               + lambda * [zeros(size(grad_list{i} , 1), 1) W(:, 2 : end)] / m;
	    end

	    grad = list_to_vector(grad_list);
	    % disp(size(grad));


	% catch
	% 	printf('Something Goes Wrong :) ....');

	% end

	

end
