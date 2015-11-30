function [weight_list layer_size] = create_model(input_size, label_size, hidden_num, force_create = false)
	
	if(force_create == false)
		if(exist('model/model_v0.nn') != 0)
			printf(['...The NN-Model Already Exists!...\n'... 
				    '...Please Check Carefully!...\n']);
			weight_list = {};
			return;
		end
	end

	if(length(hidden_num) < 2)
		weight_num = hidden_num + 1;
		try
			layer_ratio = (input_size / label_size) ^ (1 / weight_num);
		catch
			printf('Layer Ratio Error!\n');
			weight_list = {};
			return;
		end


		layer_size = zeros(weight_num + 1, 1);
		layer_size(1) = input_size;
		layer_size(weight_num + 1) = label_size;
		for i = 2 : weight_num
			layer_size(i) = round(layer_size(i - 1) / layer_ratio);
		end

	else
		weight_num = length(hidden_num) + 1;
		layer_size = zeros(weight_num + 1, 1);
		layer_size(1) = input_size;
		for j = 2 : length(layer_size) - 1
			layer_size(j) = hidden_num(j - 1);
		end
		layer_size(end) = label_size;

			
	end
	% layer_size(2) = 25;
	weight_list = cell(weight_num, 1);

	for i = 1 : weight_num
		weight_list{i} = rand(layer_size(i+1), layer_size(i) + 1) - rand(layer_size(i+1), layer_size(i) + 1);
	end

	save -binary 'model/model_v0.nn' weight_list layer_size
	printf(['...The NN-Model Has Been Built...\n']);


end
