function [accuracy precision recall  Fscore] = training_result(predict, Y, threshold = 0.5)
	accuracy = -1;
	precision = -1;
	recall = -1;
	Fscore = -1;
	if(length(predict) != length(Y))
		fprintf("... Input's dimension dismatch ...");
		return;
	end

	if(threshold > 1 || threshold < 0)
		fprintf("... Warning! Threshold is too high/low, reset to 0.5 ...");
		threshold = 0.5;
	end

	

	Y = Y(!isnan(predict));
	predict = predict(!isnan(predict));
	total_num = length(Y);

	predict(find(predict >= threshold)) = 1;
	predict(find(predict <= threshold)) = 0;

	p_idx = find(Y == 1);
	n_idx = find(Y == 0);


	TP = sum(predict(p_idx)) / total_num;
	FN = - TP + length(p_idx) / total_num;
	FP = sum(predict(n_idx)) / total_num;
	TN = - FP + length(n_idx) / total_num;


	accuracy = 1 - sum(abs(predict - Y)) / total_num;
	recall = TP / (TP + FN);
	precision = TP / (TP + FP);
	Fscore = (1 + 0.25) * recall * precision / (0.25 * precision + recall);
	% Fscore = 2 * recall * precision / (precision + recall);

	% disp([TP FN FP TN]);
	fprintf('accuracy \t precision \t recall \t F-0.5  \t pNum \t\t nNum \r\n');
	fprintf('%1.3f \t\t %1.3f \t\t %1.3f \t\t %1.3f \t\t %d \t\t %d \r\n', ...
		accuracy, precision, recall, Fscore, length(p_idx), length(n_idx));



