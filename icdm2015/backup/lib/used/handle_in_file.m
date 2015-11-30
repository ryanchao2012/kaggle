function [handle_array unknown_line curr_line] = handle_in_file(finput, n_lines = 10, curr_line = 2)

	unknown_line = [];
	
	handle_array = int32([]);

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		index = find(str == ',', 1);
		temp = str(1 : index - 1);

		if(strcmp(temp, '-1'))
			unknown_line = [unknown_line curr_line];
		else
			handle = [str2num(temp(8 : end)) ; curr_line];
			handle_array = [handle_array handle];
		end

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end



end

