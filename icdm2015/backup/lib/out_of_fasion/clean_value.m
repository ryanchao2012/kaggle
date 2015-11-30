function value = clean_value(string_list, header_list)
	l = length(string_list);
	value = zeros(l, 1);

	for i = 1 : l
		if(strcmp(string_list{i}, '-1'))
			value(i) = -1;
		else
			str = string_list{i};
			value(i) = str2num(str(length(header_list{i}) + 2 : end));
		end
	end
end
