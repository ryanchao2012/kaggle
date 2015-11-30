clear; clc;

file_name = 'raw_data/dev_test_basic.csv';


buffer_length = 65000;
test_device = zeros(buffer_length, 1);
finput = fopen(file_name, 'r');
head_line = 1;
fskipl(finput, head_line);
actual_length = 0;

for i = 1 : buffer_length
	str = fgetl(finput);
	if(isnumeric(str))
		printf('\n... Reach the end of the table! ...\n');
		break;
	end

	comma = find(str == ',', 2);
	test_device(i) = str2num(str(comma(1) + 4 : comma(2) - 1));
	actual_length++;

	if(mod(i, 1000) == 0)
		fprintf('... The %d-th test finished ...\r', i);
		fflush(stdout);
	end
end

fclose(finput);
test_device(actual_length + 1 : end) = [];
test_device = int32(test_device);







