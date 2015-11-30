clc;


t = 0.1 : 0.1 : 10;
sampl_freq = 1 / (t(2) - t(1));
% y = 22 + 5.6 * cos(2 * pi() * 0.65 * t + 7 * pi() / 8); %+ 3.5 * cos(2 * pi() * 1.5 * t + pi() / 3) + 1.5 * rand(1, length(t));
y = 2.2 * t + 3.3 + 1.5 * rand(1, length(t));   % 100 samples in total
n = length(y);


fft_n = 90;
co90 = fft(y(1 : fft_n));
co100 = fft(y);


grid90 = sampl_freq / fft_n;
grid100 = sampl_freq / n;
% freq90 = 0 : grid90 : grid90 * (fft_n - 1);
% freq100 = 0 : grid100 : grid100 * (n - 1);

% max_freq = sampl_freq / 2;
gridfit = zeros(1, n);
for i = 1 : fft_n / 2
	x = i * grid90;
	a = x / grid100;
	l = floor(a);
	lv = abs((l + 1) - a) * co90(i + 1);
	rv = abs(a - l) * co90(i + 1);
	gridfit(l + 1) += lv;
	gridfit(l + 2) += rv;
end

gridfit(1) = co90(1);
b = fliplr(conj(gridfit(2 : n / 2)));
gridfit(n / 2 + 2 : end) = b;


scale = sum(y) / sum(y(1 : fft_n));
gridfit *= scale;
% co90 = co90 * scale;
% m = mean(co90(fft_n/2 : fft_n/2 + 2));
% pco = [co90(1 : fft_n/2) m*ones(1, n - fft_n + 1) co90(fft_n/2 + 2 : end)];

z = ifft(gridfit);

c = polyfit(t(1 : fft_n), y(1 : fft_n), 1);
zz = c(1) * t + c(2);

% plot(imag(co100), 'b', imag(co90), 'b--', imag(gridfit), 'r');
plot(t, y, 'b', t, real(z), 'r');
fprintf('  fft err sum: %f \t poly err sum: %f \n', sum(abs(y - real(z))), sum(abs(y - zz)));



