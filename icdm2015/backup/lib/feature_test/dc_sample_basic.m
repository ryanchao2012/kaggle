function samples = dc_sample_basic(handle_num, member, feature_basic, pNum, nNum)
	feature_size = 18 + 1;
	seq = randperm(handle_num);
	samples = zeros(pNum + nNum, feature_size);

	mp = 0;
	mn = 0;
	nflag = true;

	for i = 1 : pNum
		m_t = member{seq(i)};
		idx_dev = find(m_t(:, 2) == 0);
		idx_dev = idx_dev(randperm(length(idx_dev)))(1);
		idx_ck = find(m_t(:, 2) == 1);
		idx_ck = idx_ck(randperm(length(idx_ck)))(1);

		str = feature_basic{seq(i)}(idx_dev, :);
		buff1 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
		str = feature_basic{seq(i)}(idx_ck, :);
		buff2 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';

		temp = zeros(1, feature_size);

		% for j = 1 : 6
		% 	if(buff1(j) == -1  || buff2(j) == -1)
		% 		temp(j) = -1;
		% 	else
		% 		temp(j) = double(buff1(j) == buff2(j));
		% 	end
		% end

		for j = 1 : (feature_size - 1)/2
			temp(2*j-1 : 2*j) = [buff1(j) buff2(j)];
		end

		% temp(7 : end - 1) = [buff1(7) buff2(7) buff1(8) buff2(8) buff1(9) buff2(9)];
		% temp(1 : 6) = temp(1 : 6) / max(temp(1 : 6));
		temp(end) = 1;
		samples(i, :) = temp;

	end


	for i = 1 : nNum
		m_t = member{seq(pNum + i)};
		idx_dev = find(m_t(:, 2) == 0);
		idx_dev = idx_dev(randperm(length(idx_dev)))(1);
		str = feature_basic{seq(pNum + i)}(idx_dev, :);
		buff1 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';


		m_t = member{seq(pNum + nNum + i)};
		idx_ck = find(m_t(:, 2) == 1);
		idx_ck = idx_ck(randperm(length(idx_ck)))(1);		
		str = feature_basic{seq(pNum + nNum + i)}(idx_ck, :);
		buff2 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';

		temp = zeros(1, feature_size);

		% for j = 1 : 6
		% 	if(buff1(j) == -1  || buff2(j) == -1)
		% 		temp(j) = -1;
		% 	else
		% 		temp(j) = double(buff1(j) == buff2(j));
		% 	end
		% end
		for j = 1 : (feature_size - 1)/2
			temp(2*j-1 : 2*j) = [buff1(j) buff2(j)];
		end
		% temp(7 : end - 1) = [buff1(7) buff2(7) buff1(8) buff2(8) buff1(9) buff2(9)];
		% temp(1 : 6) = temp(1 : 6) / max(temp(1 : 6));
		temp(end) = 0;
		samples(pNum + i, :) = temp;

	end

end