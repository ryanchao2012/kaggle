function success = count_raw_data()

	if(!exist('mini_data/available_file.list', 'file'))
		fprintf('\n [available_file.list] not found, please build mini-data first ... \n');
		success = false;
		return;
	else
		load 'mini_data/available_file.list';  % (cell)available_list
	end

	n_file = length(available_list);

	fo_log = fopen(['data_summary.txt'], 'w');

	for i = 1 : n_file
		n_line = count_line(available_list{i});
		fprintf(fo_log, [available_list{i} ': %d lines \r\n'], n_line);
	end

	fclose(fo_log);
	success = true;

end