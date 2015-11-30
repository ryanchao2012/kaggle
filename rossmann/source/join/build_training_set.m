clc; clear; close all;

if(!exist('train_v2', 'var'))
	load 'data_frame/train_v2.df';  % train_v2
end
  % {
  %  store_index, {
		%    [int32]sales(w, 7), 
		%    [logical]isOpen(w, 7), 
		%    [logical]isPromo(w, 7), 
		%    [logical]isSchHday(w, 7), 
		%    [logical]isStateHday(w, 7), 
		%    [double]sale_distr(w, 2)
		%  }
  % }

store_num = 1115;
week_num = 135;

X = zeros(store_num * week_num, 46);
Y = zeros(store_num * week_num, 9);
succ_count = 0;
for i = 1 : store_num

	for j = 1 : week_num

		[x y] = extract_single_sample(train_v2(i, :), j);

		if((x(1) != -1) && (y(1) != -1))
			succ_count++;
			X(succ_count, :) = x;
			Y(succ_count, :) = y;
		else 
			% fprintf('  WTF %d, %d ... \n', i, j);
			% fflush(stdout);
		end

		if(mod(succ_count, 1000) == 1)
			fprintf('  * %d samples has been joined ... \r', succ_count);
			fflush(stdout);
		end

	end

end
fprintf('\n');

X((succ_count + 1) : end, :) = [];
Y((succ_count + 1) : end, :) = [];
training_set.X = X;
training_set.Y = Y;



save -binary 'training_set/training_set.join' training_set;




