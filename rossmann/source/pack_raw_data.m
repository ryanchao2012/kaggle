function success = pack_raw_data(input_name, batch_size = 20000)  % input_name with extension
	success = false;
	last_dot_idx = index(input_name, '.', 'last');
	name_length = length(input_name);
	if(last_dot_idx <= 1 || last_dot_idx == name_length)
		fprintf('\n  Package file failed: please check the name of the input file ... \n');
		return;
	end

	variable_name = input_name(1 : last_dot_idx - 1);
	output_name = [variable_name '.pack'];

	if(exist(['raw_basket/' output_name], 'file'))
		fprintf('\n  File: [%s] already exists, please check manually ... \n', output_name);
		return;
	end

	if(!exist(['raw_data/' input_name], 'file'))
		fprintf('\n  File: [raw_data/%s] does not exist ... \n', input_name);
		return;
	end



	basket = {};
	batch = {};


	% basket = [basket batch]

	finput = fopen(['raw_data/' input_name], 'r');
	fskipl(finput);

	for i = 1 : 2e6
		str = fgetl(finput);

		if(isnumeric(str))
			fprintf('\n  Reach the end of the table: %s ...\n', input_name);
			fflush(stdout);
			break;
		end

		batch = [batch str];
		if(mod(i, 500) == 0)
			fprintf('  Extracting: %d lines...\r', i);
			fflush(stdout);
		end

		if(mod(i, batch_size) == 0)
			basket = [basket batch];
			batch = {};
		end

	end

	basket = [basket batch];

	eval([variable_name '= basket;']);
	eval(['save -binary raw_basket/' output_name ' ' variable_name]);

	success = true;

end













