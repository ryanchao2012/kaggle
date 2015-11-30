clc;
clear;

load 'training_data/test_set_raw_7.join';
n = length(test_set_raw_7);

if(exist('training_data/test_set_refine_60001.ref'))
	load 'training_data/test_set_refine_60001.ref';
else
	test_set_refine_60001 = cell(1156, 1);
	refine_index = 1;
	save -binary 'training_data/test_set_refine_60001.ref' test_set_refine_60001 refine_index;
end


fprintf('... Env prepared ...\n');
fflush(stdout);



for i = 1 : n
	buff_list = test_set_raw_7{i};
	each_len = cellfun('rows', buff_list);
	mean_list = cellfun('mean', buff_list, {1}, 'Uniformoutput', false);
	agg_array = [mean_list{:}];
	agg_array = reshape(agg_array, 12, length(agg_array)/12)';
	agg_array(:, 1) = each_len(:);
	test_set_refine_60001{refine_index++} = agg_array;

	if(mod(refine_index, 500) == 0)
		fprintf('... %d test-set refined ...\r', refine_index);
		fflush(stdout);
	end

end

fprintf('\n');

save -binary 'training_data/test_set_refine_60001.ref' test_set_refine_60001 refine_index;



