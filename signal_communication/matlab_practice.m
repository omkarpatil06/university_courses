clear all
close all

n = 5;
k = 2;

y = {};
%x = linspace(0, 10, n);
%y{1} = sin(x);
y{1} = ones(1,n)/n;
for i = 1:k
    y{i+1} = conv(y{i}, y{1});
end
figure;
for i = 1:k
    subplot(1,k+1,i);
    stem([1:length(y{i})], y{i}, 'b', 'linewidth', 2);
    title(strcat('y', num2str(i), ' vs t'));
end

n_t = 0:k*(n - 1);
variance = (n^2 - 1)/12;
mean = (n - 1)/2;
z = zeros(1, length(n_t));
for i = 1:length(n_t)
    z(i) = (1/sqrt(2*pi*k*variance))*exp(-1*((n_t(i)-k*mean)^2/(2*k*variance)));
end
y{k+1} = z;
subplot(1,k+1,k+1);
stem([1:length(y{k+1})], y{k+1}, 'b', 'linewidth', 2); hold on;
stem([1:length(y{k})], y{k}, 'r', 'linewidth', 1);
title('Gaussian vs Convolution');

num = [1, 0, 0, 0, 0, 0, 0, 0, 0];
den = [1, 1.0461, 0.7869, 0.8768, 0.8434, 0.8959, 0.8149, 0.9292, 0.6778];
root = roots(den);
figure; 
polar(0, 1, '.'); hold on;
plot(real(root), imag(root), 'xb', 'linewidth', 2)
root_real = root(real(root) > 0);
plot(real(root_real), imag(root_real), 'xr', 'linewidth', 2)

[res, z] = freqz(num, den);
mag = 20*log10(abs(res));
phase = rad2deg(angle(res));

figure;
subplot(2,1,1)
plot(z/pi, mag, 'k')
xlabel('Normalised frequency')
ylabel('Magnitude (dB)')
title('Magnitude Response')
subplot(2,1,2)
plot(z/pi, phase, 'k')
xlabel('Normalised frequency')
ylabel('Phase (degrees)')
title('Phase Response')

figure;
n_p = 500;      % the number of points to test the impulse resposne for
up = [1; zeros(n_p-1, 1)];      % creating the dirac delta impulse function
sys = filter(num, den, up);     % using filter to find the systems response to unit impulse
plot([1:length(sys)], sys, 'k');    %plotting the system response
xlabel('Sample index, n')      
ylabel('Impulse response of system')
title(strcat('Impulse response with n=', num2str(n_p)));s

A = 0.5;
phi = pi/3;
f = 441;
to = 2;
fo = 48000*1000;
L = 0.005*1000;

figure;
t = (to*fo:to*fo+L*fo-1)/fo;
mySin = A*sin(2*pi*f*t + phi);
plot(t, mySin);