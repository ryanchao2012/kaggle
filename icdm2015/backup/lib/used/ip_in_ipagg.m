function [ip_array unknown_line curr_line] = ip_in_ipagg(finput, n_lines = 10, curr_line = 2)

	unknown_line = [];
	
	ip_array = int32([]);

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		

		if(strcmp(str(1 : 2), '-1'))
			unknown_line = [unknown_line curr_line];

		else
			index = find(str == ',', 1);
			temp = str(3 : index(1) - 1);
			ip = [str2num(temp) ; curr_line];
			ip_array = [ip_array ip];

		end

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end

end

