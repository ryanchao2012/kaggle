function n = count_line(file_name)
	n = -1;
	if(!exist(['raw_data/' file_name], 'file'))
		fprintf([file_name ' does not exist in raw_data/ ... \n']);
		return;
	end

	fid = fopen(['raw_data/' file_name], 'r');

	while(true)

		str = fgetl(fid, 1);
		fskipl(fid);
		n++;

		if(isnumeric(str))
			break;
		end


		if(mod(n, 1e5) == 0 && n > 0)
			fprintf('%d lines found in %s \n', n, file_name);
			fflush(stdout);
		end

	end

	fclose(fid);
end