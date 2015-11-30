function [ip_list curr_line] = ip_in_idxip(finput, n_lines = 10, curr_line = 2)
	
	ip_list = {};

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		s = index(str, '{');
		ip_list = [ip_list str(s : end)];

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end
end