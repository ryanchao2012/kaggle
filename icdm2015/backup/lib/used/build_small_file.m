% clear; clc;

n_lines = 5000;


raw_list = cellstr(ls('raw_data'));                % string vector
last_dot_index = index(raw_list, '.', 'last');     % integer vector

% disp(num);

sample_list = {};
sample = 0;

for i = 1 : numel(raw_list)
		
	l = length(raw_list{i});

	if(last_dot_index(i) < l && last_dot_index(i) > 0)

		file_name = raw_list{i};

		if(strcmp(file_name(last_dot_index(i) + 1 : end), 'csv'))
			sample_list{++sample} = raw_list{i};
		end

	end

end

printf('%d available samples found!\n', sample);


for j = 1 : sample
	finput = fopen(['raw_data/' sample_list{j}], 'r');
	foutput = fopen(['test_data/' sample_list{j}], 'w');

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			break;
		end
		fprintf(foutput, [str '\r\n']);
	end

	fclose(foutput);
	fclose(finput);

end

