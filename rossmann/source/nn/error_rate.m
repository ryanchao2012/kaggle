function err = error_rate(predict, label)
	predict(find(predict >= 0.5)) = 1;
	predict(find(predict < 0.5)) = 0;
	err = mean(abs(predict - label));
end