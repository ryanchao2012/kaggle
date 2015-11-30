function vector = list_to_vector(list)
	num = size(list, 1);
	w = list{1};
	vector = w(:);

	% for i = 1 : weight_num
	% 	disp(size(weight_list{i}));
	% end


	for i = 2 : num
		w = list{i};
		vector = [vector; w(:)];
	end

	% disp(size(weight_vector));

end
