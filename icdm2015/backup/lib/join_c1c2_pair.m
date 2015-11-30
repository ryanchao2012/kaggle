clc;
close all;

if(!exist('handle', 'var'))  % device ip_member_device prop_member_device prop_feature_device
	load 'joint/handle.joint';
end
handle_num = length(handle);

if(exist('joint/c1c2_pair.joint'))
	load 'joint/c1c2_pair.joint';
else
	c1_id = int32([]);
	c2_id = int32([]);
	c1_pairs = {};
	c2_pairs = {};
	save -binary 'joint/c1c2_pair.joint' c1_id c2_id c1_pairs c2_pairs;
end

fprintf('... Env prepared ...\r\n');
fflush(stdout);	

s = 1;
e = handle_num;

for i = s : e
	m_t = member{i};
	dev_idx = find(m_t(:, 2) == 0);
	ck_idx = find(m_t(:, 2) == 1);

	dev_feat = feature_basic{i}(dev_idx, :);
	ck_feat = feature_basic{i}(ck_idx, :);

	buff_dev = sscanf(dev_feat', '%f,%f,%f,%f,%f,%f,%f,%f,%f,');
	buff_ck = sscanf(ck_feat', '%f,%f,%f,%f,%f,%f,%f,%f,%f,');

	buff_dev = reshape(buff_dev, 9, length(buff_dev) / 9)';
	buff_ck = reshape(buff_ck, 9, length(buff_ck) / 9)';

	dev_c1 = buff_dev(:, 5);
	dev_c2 = buff_dev(:, 6);
	dev_c1(find(dev_c1 == -1)) = [];
	dev_c2(find(dev_c2 == -1)) = [];
	
	ck_c1 = buff_ck(:, 5);
	ck_c2 = buff_ck(:, 6);
	ck_c1(find(ck_c1 == -1)) = [];
	ck_c2(find(ck_c2 == -1)) = [];

	c1_len = length(dev_c1);
	c2_len = length(dev_c2);

	if(c1_len > 0)

		if(!isempty(ck_c1))

			for j = 1 : c1_len
					c1_idx = find(c1_id == dev_c1(j));
					if(isempty(c1_idx))
						c1_id = [c1_id dev_c1(j)];
						c1_pairs{length(c1_id)} = ck_c1';
					else
						c1_pairs{c1_idx} = [c1_pairs{c1_idx} ck_c1'];
					end
			end
		end

	end
	


	if(c2_len > 0)

		if(!isempty(ck_c2))

			for j = 1 : c2_len
					c2_idx = find(c2_id == dev_c2(j));
					if(isempty(c2_idx))
						c2_id = [c2_id dev_c2(j)];
						c2_pairs{length(c2_id)} = ck_c2';
					else
						c2_pairs{c2_idx} = [c2_pairs{c2_idx} ck_c2'];
					end
			end
		end

	end


	if(mod(i, 500) == 0)
		fprintf('... %d-th c1 & c2 paired...\r', i);
		fflush(stdout);
	end


end


fprintf('\n');

save -binary 'joint/c1c2_pair.joint' c1_id c2_id c1_pairs c2_pairs;



