function [cookie_array unknown_line curr_line] = cookie_in_cookie(finput, n_lines = 10, curr_line = 2)

	unknown_line = [];
	
	cookie_array = int32([]);

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		

		% if(strcmp(str(1 : 2), '-1'))
		% 	unknown_line = [unknown_line curr_line];
		% else
			index = find(str == ',', 2);
			temp = str(index(1) + 4 : index(2) - 1);
			cookie = [str2num(temp) ; curr_line];
			cookie_array = [cookie_array cookie];
		% end

		curr_line++;
		if(mod(curr_line, 5000) == 0)
			fprintf('%d lines scanned...\r', curr_line);
			fflush(stdout);
		end

	end

end

