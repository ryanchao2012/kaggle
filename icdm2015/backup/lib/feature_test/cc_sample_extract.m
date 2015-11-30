function samples = cc_sample_extract(h, mem, ck, num = 10)

	total_num = length(h);
	seq = randperm(total_num);
	if(num > 5000)
		num = 5000;
	end
	samples = zeros(2 * num, 5);

	mp = 0;
	mn = 0;
	nflag = true;
	for i = 1 : total_num
		m_t = mem{seq(i)};
		ck_t = m_t(find(m_t(:, 2) == 1), 1);

		if(length(ck_t) < 2)
			if(mn < num)
				if(nflag)
					samples(num + mn + 1, :) = [h(seq(i)) -1 find(ck == ck_t) -1 0];
				else
					samples(num + mn + 1, 2) = h(seq(i));
					samples(num + (mn++) + 1, 4) = find(ck == ck_t);
				end
				nflag = !nflag;
			end

		else
			if(mp < num)
				ck_t = ck_t(randperm(length(ck_t)))(1 : 2);
				samples(++mp, :) = [h(seq(i)) h(seq(i)) find(ck == ck_t(1)) find(ck == ck_t(2)) 1];
			end

		end

		if(mn == num && mp == num)
			break;
		end

	end



end
