function [prop_array cat_list unknown_line curr_line] = all_in_propxcat(finput, n_lines = 10, curr_line = 2)

	unknown_line = [];
	cat_list = {};
	prop_array = int32([]);

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
			temp = str(10 : index(1) - 1);
			property = [str2num(temp) ; curr_line];
			prop_array = [prop_array property];
			cat_list = [cat_list str(index(1) + 1 : end)];

		end

		curr_line++;
		fprintf('%d lines scanned...\r', curr_line);
		fflush(stdout);

	end

end

