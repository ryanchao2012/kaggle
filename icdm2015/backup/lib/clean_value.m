function value = clean_value(str, header)
	if(isempty(header))
		value = [str ','];
	else
		if(strcmp(str, '-1'))
			value = '-1,';
		else
			value = [str(length(header) + 1 : end) ','];
		end
	end
end
