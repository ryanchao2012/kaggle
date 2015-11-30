clear; clc; close all;

load 'training_data/training_set.join'; % training_set


feat_num = columns(training_set) - 1;

training_mean = ones(1, feat_num);
training_std = ones(1, feat_num);



for i = 1 : feat_num
	temp = training_set(:, i);
	temp = temp(temp >= 0);
	training_mean(i) = mean(temp);
	training_std(i) = std(temp);

end


save -binary 'test_set/training_distribution.join' training_mean training_std;


