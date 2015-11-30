function n = calculate_lines(file_name)
	n = -1;
	if(!exist(file_name))
		printf('Target File Does Not Exist!!! \n');
		return;
	end
    more off;
    % buffer_size = 5e4;
	fid = fopen(file_name, 'r');

	tic;
	% n = 0;
	while(true)

		str = fgetl(fid, 1);
		fskipl(fid);
		n++;

		% [str count] = fscanf(fid, template, buffer_size);
		% n = n + count;

		if(isnumeric(str))
			break;
		end


		% if(count == 0)
		% 	break;
		% end

		if(mod(n, 1e5) == 0 && n > 0)
			disp(toc);
			printf('%d Lines Found... \n', n);
			tic;
		end

	end

	fclose(fid);
end