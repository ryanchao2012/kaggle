function [property_list curr_line] = property_in_idxproperty(finput, n_lines = 10, curr_line = 2)
	
	property_list = {};

	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))
			printf('\n... Reach the end of the table! ...\n');
			break;
		end
		s = index(str, '{');
		property_list = [property_list str(s : end)];

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end
end