function [cookie ip] = joint_from_idxip(n_lines = 1)
	file_name = 'test_data/id_all_ip.csv';
	curr_line = 2;
	unknown_line = [];
	finput = fopen(file_name, 'r');

	if(exist('log/id_all_ip.log'))
		load 'log/id_all_ip.log';
	else
		save -binary 'log/id_all_ip.log' curr_line unknown_line;
	end


	if(!exist('joint/device.joint'))
		printf('...The device.joint does not exist!...\n');
		printf('...Update device.joint form device_train failed!...\n');
		return;
	else
		load 'joint/device.joint';
	end


	if(!exist('joint/cookie.joint'))
		printf('...The cookie.joint does not exist!...\n');
		printf('...Update cookie.joint form device_train failed!...\n');
		return;
	else
		load 'joint/cookie.joint';
	end


	if(!exist('joint/ip.joint'))
		printf('...The ip.joint does not exist!...\n');
		printf('...Update ip.joint form device_train failed!...\n');
		return;
	else
		load 'joint/ip.joint';
	end

	%%%%%%%%%%%%%%%%%%% enviroment prepared! %%%%%%%%%%%%%%%%%%%
	if(curr_line > 1)
		fskipl(finput, curr_line - 1);
	end
 	header_list = {'id', 'indicator', 'ip', 'freq', ...
 	               'c1', 'c2', 'c3', 'c4', 'c5'};

 	
 	for i = 1 : n_lines

 		str = fgetl(finput);
		if(isnumeric(str))			
			printf('\n... Reach the end of the table! ...\n');
			break;
		end

		tuple_index = index(str, '{');
		temp1_2 = strsplit(str(1 : tuple_index - 2), ',');
		id = str2num(temp1_2{1}(4 : end));
		indicator = str2num(temp1_2{2});
		ip_list = strsplit(str(tuple_index + 2 : end - 2), '),(');
		ip_num = length(ip_list);

		if(tuple_index == 0 || str(1 : 2) == '-1' || ip_num > 60)
			unknown_line(end + 1) = curr_line;
		else
			
			ip_list = cellfun('substr', ip_list, {3}, 'UniformOutput', false);
			ip_list = cellfun('strsplit', ip_list, {','}, 'UniformOutput', false);
			ip_list = reshape([ip_list{:}], 7, ip_num);
			ip_mat =  cell2mat(cellfun('str2num' , ip_list, 'UniformOutput', false));


			if(indicator == 1) % for cookie
				id_index = find([cookie.id] == id, 1);
				if(isempty(id_index))
					id_index = length([cookie.id]) + 1;
					cookie(id_index).id = id;
					cookie(id_index).handle_index = -1;
				end
			else    % for device
				id_index = find([device.id] == id, 1);
				if(isempty(id_index))
					id_index = length([device.id]) + 1;
					device(id_index).id = id;
					device(id_index).handle_index = -1;
				end			
			end


			ip_index = zeros(1, ip_num);


			for j = 1 : ip_num
				idx = find([ip.address] == ip_mat(1, j), 1);
				if(isempty(idx))
					ip_index(j) = length([ip.address]) + 1;
					ip(ip_index(j)).address = ip_mat(1, j);
				else
					ip_index(j) = idx;
				end

				ip(ip_index(j)).cell_indicator = [ip(ip_index(j)).cell_indicator indicator * 2];  % the id belongs to cookie, but not sure the ip is cell or not.
				ip(ip_index(j)).dev_cookie_index = [ip(ip_index(j)).dev_cookie_index id_index];
			end


			if(indicator == 1) % for cookie
				cookie(id_index).ip_index = [cookie(id_index).ip_index ip_index];
				cookie(id_index).ip_freq = [cookie(id_index).ip_freq ip_mat(2, :)];
				cookie(id_index).c1 = [cookie(id_index).c1 ip_mat(3, :)];
				cookie(id_index).c2 = [cookie(id_index).c2 ip_mat(4, :)];
				cookie(id_index).c3 = [cookie(id_index).c3 ip_mat(5, :)];	
				cookie(id_index).c4 = [cookie(id_index).c4 ip_mat(6, :)];
				cookie(id_index).c5 = [cookie(id_index).c5 ip_mat(7, :)];	
			else  			  % for device
				device(id_index).ip_index = [device(id_index).ip_index ip_index];
				device(id_index).ip_freq = [device(id_index).ip_freq ip_mat(2, :)];
				device(id_index).c1 = [device(id_index).c1 ip_mat(3, :)];
				device(id_index).c2 = [device(id_index).c2 ip_mat(4, :)];
				device(id_index).c3 = [device(id_index).c3 ip_mat(5, :)];	
				device(id_index).c4 = [device(id_index).c4 ip_mat(6, :)];
				device(id_index).c5 = [device(id_index).c5 ip_mat(7, :)];
			end

		end

		fprintf('%d lines recorded...\r', curr_line);
		fflush(stdout);
    	curr_line++;
		
	end

	fclose(finput);
	fprintf('\n');

end

