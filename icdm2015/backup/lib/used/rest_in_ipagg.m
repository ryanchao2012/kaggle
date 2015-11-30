function [rest_list curr_line] = rest_in_ipagg(finput, n_lines = 10, curr_line = 2)
	
	rest_list = {};

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		s = index(str, ',');
		rest_list = [rest_list str(s + 1 : end)];

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end
end