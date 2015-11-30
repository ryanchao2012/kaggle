function samples = dc_sample_extract(h, mem, dev, ck, pNum, nNum)

	seq = randperm(length(h));
	% if(pNum > 10000)
	% 	pNum = 10000;
	% end

	% if(nNum > 10000)
	% 	nNum = 10000;
	% end
	
	samples = zeros(pNum + nNum, 5);
	positive = seq(1 : pNum);
	negative = seq(pNum + 1 : pNum + 2 * nNum);

	for i = 1 : pNum
		m_t = mem{positive(i)};

		dv_t = m_t(find(m_t(:, 2) == 0), 1);
		dv_t = dv_t(randperm(length(dv_t))(1));

		ck_t = m_t(find(m_t(:, 2) == 1), 1);		
		ck_t = ck_t(randperm(length(ck_t))(1));

		samples(i, :) = [h(positive(i)) h(positive(i)) find(dev == dv_t) find(ck == ck_t) 1];
	end


	for i = 1 : nNum
		m1_t = mem{negative(i)};
		m2_t = mem{negative(nNum + i)};

		dv_t = m1_t(find(m1_t(:, 2) == 0), 1);
		dv_t = dv_t(randperm(length(dv_t))(1));

		ck_t = m2_t(find(m2_t(:, 2) == 1), 1);		
		ck_t = ck_t(randperm(length(ck_t))(1));

		samples(pNum + i, :) = [h(negative(i)) h(negative(nNum + i)) find(dev == dv_t) find(ck == ck_t) 0];
	end


end
