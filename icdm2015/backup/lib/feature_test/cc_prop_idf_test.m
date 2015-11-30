% clear; clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end


if(!exist('property', 'var'))
	load 'joint/property.joint';
end

if(!exist('category', 'var'))
	load 'joint/category.joint';
end


fprintf('... Joints loaded ...\n\r');
fflush(stdout);



test_num = 1;
sample_num = 20;


fprintf('... Randomly select %d positive/negative samples ...\n\r', sample_num);
fflush(stdout);


n = 2 * sample_num;
false_positive = zeros(1, test_num);
false_negative = zeros(1, test_num);
temp_weight = category_weight;

% temp_weight(find(temp_weight < 3)) = 0;

for j = 1 : test_num

	sample = cc_sample_extract(handle, member, cookie, sample_num);
	prop_idf = -1 * ones(n, 2);
	for i = 1 : n
		prop_ck1 = prop_member_cookie{sample(i, 3)};
		prop_ck2 = prop_member_cookie{sample(i, 4)};


		if(!isempty(prop_ck1) && !isempty(prop_ck2))
			mpck1 = length(prop_ck1);
			mpck2 = length(prop_ck2);

			total = [];
			[dummy idx_prop_ck1] = ismember(prop_ck1, property);
			[dummy idx_prop_ck2] = ismember(prop_ck2, property);

			% idx_prop_dev = idx_prop_dev(find(idx_prop_dev))
			% idx_prop_ck = idx_prop_ck(find(idx_prop_ck))

			for k = 1 : mpck1
				cat_ck1 = cat_member{idx_prop_ck1(k)};

				for kk = 1 : mpck2
					cat_ck2 = cat_member{idx_prop_ck2(kk)};
					inter = intersect(cat_ck1, cat_ck2);
					if(!isempty(inter))
						[dummy idx_cat] = ismember(inter, category);
						total = [total sum(temp_weight(idx_cat))/((length(cat_ck1) * length(cat_ck2))^0.5)];
					end
				end
			end

			prop_idf(i, :) = [mean(total) * length(total) sample(i, 5)];
			
		end

		fprintf('... The %d-th sample finished/skipped ...\r', i);
		fflush(stdout);

	end
	% false_positive(j) = 100 * sum(prop_inter_num(sample_num + 1 : end) != 0)/sample_num;
	% false_negative(j) = 100 * sum(prop_inter_num(1 : sample_num) == 0) / sample_num;

	fprintf('\n... The %d-th test finished ...\n\r', j);
	fflush(stdout);
end


xp = prop_idf(find(prop_idf(:, 2) == 1) , 1);
xn = prop_idf(find(prop_idf(:, 2) == 0) , 1);
hold on;
plot(xp, zeros(length(xp), 1), 'bo');
plot(xn, zeros(length(xn), 1), 'rx');








