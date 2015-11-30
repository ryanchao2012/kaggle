function list = vector_to_list(vector, layer_size)
	num = size(layer_size, 1) - 1;
	list = cell(num, 1);

	s = 0;
	for i = 1 : num
		list{i} = reshape(vector(s + 1 : s + (layer_size(i) + 1) * layer_size(i + 1)),...
			                     layer_size(i + 1), layer_size(i) + 1);
		s = s + (layer_size(i) + 1) * layer_size(i + 1);
	end

end