function [cookie_array device_array unknown_line curr_line] = id_in_file(finput, n_lines = 10, curr_line = 2)

	unknown_line = [];
	
	cookie_array = int32([]);
	device_array = int32([]);

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		

		if(strcmp(str(1 : 2), '-1'))
			unknown_line = [unknown_line curr_line];

		else
			index = find(str == ',', 2);
			temp = str(4 : index(1) - 1);
			indicator = str2num(str(index(1) + 1 : index(2) - 1));
			id = [str2num(temp) ; curr_line];

			if(indicator == 1)
				cookie_array = [cookie_array id];
			elseif(indicator == 0)
				device_array = [device_array id];
			else
				unknown_line = [unknown_line curr_line];
			end
		end

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end

end

