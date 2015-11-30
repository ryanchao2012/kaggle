clc; clear; 
close all;


if(!exist('predicted_sales', 'var'))
	load 'prediction/prediction.df'
end

% predicted_sales[cell](856 x 1):
%   {
%    sales[double](8 x 7)
%   }

store_num = length(predicted_sales);
weeknum = 8;
submit_array = zeros(weeknum * 7, store_num);

start_idx = 5;
end_idx = start_idx + 48 - 1;
for i = 1 : store_num
	submit_array(:, i) = [predicted_sales{i}'](:);
end

submit_array = submit_array(start_idx : end_idx, :);
submit_array = flipud(submit_array);

submit_seq = round(submit_array'(:));
seq_num = length(submit_seq);
id_no = [1 : seq_num]';


fid = fopen('submit/final.csv', 'w');
fprintf(fid, 'Id,Sales\n');

for i = 1 : seq_num
	
	fprintf(fid, ['%d,%d\n'], id_no(i), submit_seq(i));
	
	if(mod(i, 500) == 0)
		fprintf('... %d test sample completed ... \r', i);
		fflush(stdout);
	end

end

fprintf('\n');

fclose(fid);
