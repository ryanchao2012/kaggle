% clear; clc;
clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(exist('model/model_v0.nn') == 0)
	printf('... Model Does Not exist! ...\n');
	return;
end

% load 'model/model_v0.nn';

test_num = 5;
nNum = 5000;
skew_ratio = 1;
pNum = 1 + round(skew_ratio * nNum);
opt = optimset('MaxIter', 500);
lambda = 0.0;



fprintf('... Randomly select %d:%d(P:N) positive/negative samples ...\n\r', pNum, nNum);
fflush(stdout);


handle_num = length(handle);

for i = 1 : test_num

	load 'model/model_v0.nn';

	samples = dc_sample_basic(handle_num, member, feature_basic, pNum, nNum);
	X = samples(:, 1 : 3) == samples(:, 4 : 6);
	Y = samples(:, 7);

	for j = 1 : 3
		subplot(2, 3, j);		
		hist(X(Y == 1, j));
		title(num2str(j));
		subplot(2, 3, 3 + j);
		hist(X(Y == 0, j));
		title(num2str(j));
	end

	% fprintf('%3.2f \t %3.2f \t %3.2f \t %3.2f \t %3.2f \t %3.2f \r\n', mean(X(Y == 1, :)));
	% fprintf('%3.2f \t %3.2f \t %3.2f \t %3.2f \t %3.2f \t %3.2f \r\n', mean(X(Y == 0, :)));
	% fprintf('============================================================\r\n');
	% fflush(stdout);
end







