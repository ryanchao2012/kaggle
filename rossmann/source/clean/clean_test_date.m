clc;

load 'refine_basket/test.ref';
	% test_id store_index day_week bool_feat state_hday date_list;

if(!exist('train', 'var'))
	load 'data_frame/train.df';
end

if(!exist('date_list', 'var') || exist('date_seq', 'var'))
	fprintf('\n Warning: date(date_list) has been refined(date_seq) \n');
	fflush(stdout);
	return;
end

date_num = length(test_id);
date_seq = zeros(date_num, 1);

ref_date = date_list{1};
ref_idx = 1;
end_date = date_list{end};

for i = 2 : date_num

	if(!strcmp(ref_date, date_list{i}))
		date_seq(ref_idx : i - 1) = datenum(ref_date);
		ref_idx = i;
		ref_date = date_list{i};

		fprintf('  The %d-th date is refined \n', i);
		fflush(stdout);
		
		if(strcmp(ref_date, end_date))
			break;
		end

	end

end

date_seq(ref_idx : end) = datenum(end_date);

date_seq = int32(date_seq);


date_seq -= train.date_base;

save -binary 'refine_basket/test.ref' test_id store_index day_week bool_feat state_hday date_seq;

