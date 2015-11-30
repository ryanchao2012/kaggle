clc; clear; close all;

if(!exist('train_v2', 'var'))
	load 'data_frame/train_v2.df';  % train_v2
end
% train_v2[cell](n x 6):
%   {
%    store_index, {
% 		   [int32]sales(w, 7), 
% 		   [logical]isOpen(w, 7), 
% 		   [logical]isPromo(w, 7), 
% 		   [logical]isSchHday(w, 7), 
% 		   [logical]isStateHday(w, 7), 
% 		   [double]sale_distr(w, 2)
% 		 }
%   }

if(!exist('test', 'var'))
	load 'data_frame/test.df';  % test
end
% test:
%   [1,1] = test_id
%   [2,1] = store_index
%   [3,1] = date_seq
%   [4,1] = day_week
%   [5,1] = bool_feat
%   [6,1] = state_hday


standin = test;
standin.test_id = flipud(double(standin.test_id));
standin.store_index = flipud(double(standin.store_index));
standin.date_seq = flipud(double(standin.date_seq));
standin.day_week = flipud(double(standin.day_week));
standin.bool_feat = flipud(double(standin.bool_feat));
standin.state_hday = flipud(double(logical(standin.state_hday)));


store_index = unique(standin.store_index);
store_num = length(store_index);

week_num = 12;

test_v2 = cell(store_num, 6);


for i = 1 : store_num
	idx = standin.store_index == store_index(i);

	pre_sales = double(train_v2{store_index(i), 1}(end - 4 : end - 1, :));
	pre_is_open = [double(train_v2{store_index(i), 2}(end - 4 : end, :))]'(:);
	pre_is_promo = [double(train_v2{store_index(i), 3}(end - 4 : end, :))]'(:);
	pre_is_schHday = [double(train_v2{store_index(i), 4}(end - 4 : end, :))]'(:);
	pre_is_stateHday = [double(train_v2{store_index(i), 5}(end - 4 : end, :))]'(:);
	pre_sale_distr = double(train_v2{store_index(i), 6}(end - 4 : end - 1, :));

	temp = standin.bool_feat(idx, 2)(end);
	is_open = [pre_is_open(1 : end - 3); standin.bool_feat(idx, 1); 1; 1; 0; 1];
	is_promo = [pre_is_promo(1 : end - 3); standin.bool_feat(idx, 2); temp; 0; 0; ~temp];
	is_schHday = [pre_is_schHday(1 : end - 3); standin.bool_feat(idx, 3); 0; 0; 0; 0];
	is_stateHday = [pre_is_stateHday(1 : end - 3); standin.state_hday(idx); 0; 0; 0; 0];

	is_open = reshape(is_open, 7, week_num)';
	is_promo = reshape(is_promo, 7, week_num)';
	is_schHday = reshape(is_schHday, 7, week_num)';
	is_stateHday = reshape(is_stateHday, 7, week_num)';

	test_v2{i, 1} = int32(pre_sales);
	test_v2{i, 2} = logical(is_open);
	test_v2{i, 3} = logical(is_promo);
	test_v2{i, 4} = logical(is_schHday);
	test_v2{i, 5} = logical(is_stateHday);
	test_v2{i, 6} = double(pre_sale_distr);

	if(mod(i, 10) == 0)
		fprintf('  The %d store is built \r', i);
		fflush(stdout);
	end


end
fprintf('\n');

save -binary 'data_frame/test_v2.df' test_v2;





