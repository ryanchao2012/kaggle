clc;
close all;
	n_line = 300000;

	if(!exist('ip_list', 'var'))
		load 'statistics/ip_in_idxip.stat';  % ip_list
	end


	if(exist('log/refine_idxip.log'))
		load 'log/refine_idxip.log';
	else
		curr_line = 1;
		num = length(ip_list);
		save -binary 'log/refine_idxip.log' curr_line num;
	end



	if(!exist('refine_list', 'var'))
		if(exist('refine/ip_in_idxip.ref'))
			load 'refine/ip_in_idxip.ref';  % refine_list
		else
			refine_list = cell(num, 1);
			save -binary 'refine/ip_in_idxip.ref' refine_list;
		end
			
	end

	fprintf('... Env prepared ... \r\n');
	fflush(stdout);

	target = n_line + curr_line - 1;

	if(target > num)
		target = num;
	end

	tic
	for i = curr_line : target 
		% str = [ip_list{1:10}];
		% str = strsplit(str(3 : end - 2), ')}{(');
		% str = cellfun('strsplit', str, )
		% m = cellfun('length', str, 'UniformOutput', false);

		temp = strsplit(ip_list {i}(3 : end - 2), '),(');
		temp = cellfun('substr', temp, {3}, 'UniformOutput', false);
		temp = cellfun('sscanf', temp, {'%d, %d, %d, %d, %d, %d, %d'}, 'UniformOutput', false);
		refine_list{i} = int32([temp{:}]);

		if(mod(i, 1000) == 0)
			fprintf('%d lines refined...\r', i);
			fflush(stdout);
		end

	end

	fprintf('\n');
	
	toc;

	curr_line = target + 1;

	save -binary 'refine/ip_in_idxip.ref' refine_list;
	save -binary 'log/refine_idxip.log' curr_line num;

