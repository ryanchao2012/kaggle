% clear; clc;
close all;
if(!exist('handle', 'var'))
	load 'joint/handle.joint';
end

if(!exist('cookie', 'var'))
	load 'joint/cookie.joint';
end

if(!exist('device', 'var'))
	load 'joint/device.joint';
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
sample_num = 50;


fprintf('... Randomly select %d positive/negative samples ...\n\r', sample_num);
fflush(stdout);


n = 2 * sample_num;
false_positive = zeros(1, test_num);
false_negative = zeros(1, test_num);
temp_weight = category_weight;

temp_weight(find(temp_weight < 1)) = 0;

for j = 1 : test_num

	sample = dc_sample_extract(handle, member, device, cookie, sample_num);
	prop_idf = -1 * ones(n, 2);
	for i = 1 : n
		prop_dev = prop_member_device{sample(i, 3)};
		prop_ck = prop_member_cookie{sample(i, 4)};


		if(!isempty(prop_dev) && !isempty(prop_ck))
			mpdev = length(prop_dev);
			mpck = length(prop_ck);

			total = [];
			[dummy idx_prop_dev] = ismember(prop_dev, property);
			[dummy idx_prop_ck] = ismember(prop_ck, property);

			% idx_prop_dev = idx_prop_dev(find(idx_prop_dev))
			% idx_prop_ck = idx_prop_ck(find(idx_prop_ck))

			for k = 1 : mpdev
				cat_dev = cat_member{idx_prop_dev(k)};

				for kk = 1 : mpck
					cat_ck = cat_member{idx_prop_ck(kk)};
					inter = intersect(cat_dev, cat_ck);
					if(!isempty(inter))
						
						total = [total sum(length(inter))/((length(cat_dev) * length(cat_ck))^0.5)];
						% [dummy idx_cat] = ismember(inter, category);
						% total = [total sum(temp_weight(idx_cat))/((length(cat_dev) * length(cat_ck))^0.5)];
					else
						total = [total 0];
					end
				end
			end

			prop_idf(i, :) = [mean(total) sample(i, 5)];
			
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








