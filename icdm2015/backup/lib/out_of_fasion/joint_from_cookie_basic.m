function [curr_line unknown_line] = joint_from_cookie_basic(n_lines = 10)
	file_name = 'test_data/cookie_all_basic.csv';
	curr_line = 2;
	unknown_line = [];
	finput = fopen(file_name, 'r');

	if(exist('log/cookie_all_basic.log'))
		load 'log/cookie_all_basic.log';
	else
		save -binary 'log/cookie_all_basic.log' curr_line unknown_line;

	end


	if(!exist('joint/handle.joint'))
		printf('...The handle.joint does not exist!...\n');
		printf('...Update handle.joint form cookie_basic failed!...\n');
		return;
	else
		load 'joint/handle.joint';
		% disp(handle);
	end

	if(!exist('joint/cookie.joint'))
		printf('...The cookie.joint does not exist!...\n');
		printf('...Update cookie.joint form cookie_basic failed!...\n');
		return;
	else
		load 'joint/cookie.joint';
		% disp(cookie);
	end

	%%%%%%%%%%%%%%%%%%% enviroment prepared! %%%%%%%%%%%%%%%%%%%
	if(curr_line > 1)
		fskipl(finput, curr_line - 1);
	end
 	header_list = {'handle', 'id', 'computer_os_type', 'computer_browser_version', ...
 	               'country', 'anonymous_c0', 'anonymous_c1', 'anonymous_c2', ...
 	               'anonymous_5', 'anonymous_6', 'anonymous_7'};
	% more off;
	tic;
	for i = 1 : n_lines
		str = fgetl(finput);
		if(isnumeric(str))			
			printf('\n... Reach the end of the table! ...\n');
			break;
		end

		str = strsplit(str, ',');
		temp1_5 = clean_value(str(1 : 5), header_list(1 : 5));
		temp7_8 = clean_value(str(7 : 8), header_list(7 : 8));
		temp9_11 = [str2num(str{9}), str2num(str{10}), str2num(str{11})];

		if(temp1_5(1) == -1)
			unknown_line(end + 1) = curr_line;
		else

			handle_index = find([handle.id] == temp1_5(1), 1);
			if(isempty(handle_index))
				handle_index = length([handle.id]) + 1;
				handle(handle_index).id = temp1_5(1);
			end

			if(temp1_5(2) != -1)
				cookie_index = find([cookie.id] == temp1_5(2), 1);
				if(isempty(cookie_index))
					cookie_index = length([cookie.id]) + 1;
					cookie(cookie_index).id = temp1_5(2);
					cookie(cookie_index).handle_index = handle_index;
				else
					printf('\n... Something goes wrong , please check ...\n');
				end
			else
				cookie_index = -1;
			end
			
			handle(handle_index).dev_cookie_index = [handle(handle_index).dev_cookie_index cookie_index];
			handle(handle_index).indicator = [handle(handle_index).indicator 1];
			handle(handle_index).type = [handle(handle_index).type temp1_5(3)];
			handle(handle_index).version = [handle(handle_index).version temp1_5(4)];
			handle(handle_index).county = [handle(handle_index).county temp1_5(5)];
			handle(handle_index).c0 = [handle(handle_index).c0 str2num(str{6})];
			handle(handle_index).c1 = [handle(handle_index).c1 temp7_8(1)];
			handle(handle_index).c2 = [handle(handle_index).c2 temp7_8(2)];
			handle(handle_index).a5 = [handle(handle_index).a5 temp9_11(1)];
			handle(handle_index).a6 = [handle(handle_index).a6 temp9_11(2)];
			handle(handle_index).a7 = [handle(handle_index).a7 temp9_11(3)];

		end

		curr_line++;

		fprintf('%d lines recorded...\r', curr_line);
		fflush(stdout);

	end
	toc;
	fclose(finput);

	save -binary 'log/cookie_all_basic.log' curr_line unknown_line;
	save -binary 'joint/handle.joint' handle;
	save -binary 'joint/cookie.joint' cookie;

	fprintf('\n');
end

