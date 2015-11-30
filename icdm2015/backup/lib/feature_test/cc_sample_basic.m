function samples = cc_sample_basic(handle_num, member, feature_basic, pNum, nNum)
	seq = randperm(handle_num);
	samples = zeros(pNum + nNum, 13);

	mp = 0;
	mn = 0;
	nflag = true;

	for i = 1 : handle_num
		m_t = member{seq(i)};
		idx_ck = find(m_t(:, 2) == 1);

		if(length(idx_ck) < 2)
			if(mn < nNum)
				if(nflag)
					str = feature_basic{seq(i)}(idx_ck, :);
					nbuff1 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
				else
					str = feature_basic{seq(i)}(idx_ck, :);
					nbuff2 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';

					ntemp = zeros(1, 13);

					for j = 1 : 6
						if(nbuff1(j) == -1  || nbuff2(j) == -1)
							ntemp(j) = -1;
						else
							ntemp(j) = double(nbuff1(j) == nbuff2(j));
						end
					end

					ntemp(7 : end - 1) = [nbuff1(7 : 9) nbuff2(7 : 9)];
					% ntemp(1 : end - 1) = ntemp(1 : end - 1) / max(ntemp(1 : end - 1));
					ntemp(end) = 0;
					samples(pNum + (++mn), :) = ntemp;

				end
				nflag = !nflag;
			end

		else
			if(mp < pNum)
				order = randperm(length(idx_ck));
				str = feature_basic{seq(i)}(idx_ck(order(1)), :);
				pbuff1 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';
				str = feature_basic{seq(i)}(idx_ck(order(2)), :);
				pbuff2 = sscanf(str(1, :), '%f,%f,%f,%f,%f,%f,%f,%f,%f,')';

				ptemp = zeros(1, 13);

				for k = 1 : 6
					if(pbuff1(k) == -1  || pbuff2(k) == -1)
						ptemp(k) = -1;
					else
						ptemp(k) = double(pbuff1(k) == pbuff2(k));
					end
				end

				ptemp(7 : end - 1) = [pbuff1(7 : 9) pbuff2(7 : 9)];
				% ptemp(1 : end - 1) = ptemp(1 : end - 1) / max(ptemp(1 : end - 1));
				ptemp(end) = 1;
				samples((++mp), :) = ptemp;			

			end

		end

		if(mn == nNum && mp == pNum)
			break;
		end

	end

end