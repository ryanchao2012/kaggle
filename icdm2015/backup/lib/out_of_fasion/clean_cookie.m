function value = clean_cookie(str, header_list)
	str = strsplit(str, ',');
	vlist = cellfun('clean_value', str, header_list, 'UniformOutput', false);
	value = [vlist{:}];
end
