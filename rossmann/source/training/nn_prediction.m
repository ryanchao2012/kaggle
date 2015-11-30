clc; clear; 
close all;

if(!exist('test_v2', 'var'))
	load 'data_frame/test_v2.df';  % test_v2
end
% test_v2[cell](856 x 6):
%   {
% 		   [int32]sales(w4, 7), 
% 		   [logical]isOpen(w12, 7), 
% 		   [logical]isPromo(w12, 7), 
% 		   [logical]isSchHday(w12, 7), 
% 		   [logical]isStateHday(w12, 7), 
% 		   [double]sale_distr(w4, 2)
%   }


if(exist('model/model_v0.nn'))
	load 'model/model_v0.nn';
end

store_num = rows(test_v2);
predicted_sales = cell(store_num, 1);

week_num = 8;
standin = test_v2;
wl = weight_list;
temp = ones(1, 7);

for i = 1 : store_num

	sales_i = zeros(week_num, 7);

	s = [double(standin{i, 1}) test_v2{i, 6}];
	s = s(3 : 4, :);
	for j = 1 : week_num

		llsales_feat = [(1 * (s(1, 1 : 7) - s(1, 8)) / s(1, 9)) (0.0001 * s(1, 8 : 9))];
		lsales_feat = [(1 * (s(2, 1 : 7) - s(2, 8)) / s(2, 9)) (0.0001 * s(2, 8 : 9))];
		X = [llsales_feat lsales_feat double([standin{i, 2} standin{i, 3} standin{i, 4} standin{i, 5}](4 + j, :))];

		O = nn_forward(wl, X);

		pred_distr = O(8 : 9) * 10000;
		pred_sale = (O(1 : 7) .* (pred_distr(:, 2) * temp)) + (pred_distr(:, 1) * temp);

		s = [s(2, :) ; [pred_sale pred_distr]];

		sales_i(j, :) = pred_sale;

	end

	predicted_sales{i} = sales_i;

	if(mod(i, 10) == 0)
		fprintf('  The %d prediction finished \r', i);
		fflush(stdout);
	end

end
fprintf('\n');

save -binary 'prediction/prediction.df' predicted_sales;











