function build_mini_data(n_lines = 500, extension = 'csv')


	raw_list = cellstr(ls('raw_data'));                % string cell
	last_dot_index = index(raw_list, '.', 'last');     % integer vector
	file_name_length = cellfun('length', raw_list);
	n_file = length(raw_list);

	available_list = {};
	sample = 0;

	for i = 1 : n_file
			
		_len = file_name_length(i);
		_last = last_dot_index(i);

		if(_last < _len && _last > 0)

			file_name = raw_list{i};

			if(strcmp(file_name(_last + 1 : end), 'csv'))
				available_list{++sample} = file_name;
			end

		end

	end

	fprintf('\n%d available samples found!\n', sample);

	if(!exist('mini_data', 'dir'))
		mkdir 'mini_data';
	end

	fo_log = fopen(['data_summary.txt'], 'w');

	for j = 1 : sample
		fi_raw = fopen(['raw_data/' available_list{j}], 'r');
		fo_mini = fopen(['mini_data/' available_list{j}], 'w');
		
		fprintf(fo_log, [available_list{j} '\r\n']);

		for i = 1 : n_lines
			str = fgetl(fi_raw);
			if(isnumeric(str))
				break;
			end
			fprintf(fo_mini, [str '\r\n']);
		end

		fclose(fo_mini);
		fclose(fi_raw);

	end

	fclose(fo_log);

	fprintf('mini data built completed! \n');

	save -binary 'mini_data/available_file.list' available_list;

end
