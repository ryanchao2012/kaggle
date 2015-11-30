clear; clc;


j = 1;
for i = 1 : 100

	fprintf('loop: %d \n', j);
	fflush(stdout);

	if(mod(j, 3) == 0)
		j+=2;
	else
		j++;
	end

	if(j > 100)
		break;
	end

end

