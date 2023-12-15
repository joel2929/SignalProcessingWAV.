% Joel Marte
% Sarnoh W Lepolu
% ECE320
% MATLAB Projet 2

% 3.2 tutorial: freqz
% (2a)
clc, clear;
a = [1, -.8];
b = [2 0 -1];

% (2b)
n1 = 4;
n2 = 4;

[H1, omega1] = freqz(b, a, n1);
[H2, omega2] = freqz(b, a, n2, 'whole');
H1; omega1;
% (2c)
H2;
omega2;

%%% (a)
load('group9.mat')
soundsc(y, 10000)
fs = 10000;
% set fft size to be the power of 2 greater than the signal length
Nfft = 2^ceil(log2(length(y)));
% fftshift reorders the values of the DTFT to go from -pi to pi
Y =fftshift(fft(y, Nfft));
% set appropriate omega samples for X from -pi to pi
omegaX = (0:(Nfft-1))*(2*pi/Nfft)-pi;

figure(1)
clf
% plot magnitude samples vs frequency normalized by pi
plot(omegaX/pi, abs(Y));
noise = text(-.8, 500, 'noise'); noise2 = text(.67, 500, 'noise');
speech = text(-.095, 500, 'speech');
tone = text(-.45, 500, 'tone\rightarrow'); tone2 = text(.27, 500, '\leftarrowtone');
xlabel('Frequency (\omega/\pi)')
ylabel('|Y(e^{j\omega})|')
title('|Y(e^{j\omega})| Spectrum')

figure(2)
plot(omegaX/pi, 20*log10(abs(Y)));
dBnoise = text(-.8, 50, 'noise'); dBnoise2 = text(.67, 50, 'noise');
dBspeech = text(-.095, 50, 'speech');
dBtone = text(-.45, 50, 'tone\rightarrow'); dBtone2 = text(.27, 50, '\leftarrowtone');
xlabel('Frequency (\omega/\pi)')
ylabel('|Y(e^{j\omega})|')
title('|Y(e^{j\omega})| Spectrum (dB)')
ylim([-80 100])




%%% (c)

Wn=0.280029*pi;
hnotch = [1 -2*cos(Wn) 1];
[Hnotch, omegaHnotch] = freqz(hnotch, 1);

% frequency response of notch filter

figure(3)
plot(omegaHnotch/pi, 2*log10(abs(Hnotch)));
xlabel('Frequency (\omega/\pi)')
ylabel('|Hnotch(e^{j\omega})|')
title('|Hnotch(e^{j\omega})| Spectrum (dB)')

%%% (d)

% run y signal through notch filter to remove tone
r = filter(hnotch, 1, y);
 soundsc(r, fs)
% The tone is comepletely gone

NfftR = 2^ceil(log2(length(r)));

R =fftshift(fft(r, NfftR));
omegaR = (0:(NfftR-1))*(2*pi/NfftR)-pi;



figure(4)
plot(omegaR/pi, abs(R));
xlabel('Frequency (\omega/\pi)')
ylabel('|R(e^{j\omega})|')
title('|R(e^{j\omega})| Spectrum')

%%% (e)
alpha = 0.416809; % cut-off frequency to remove noise based of Fig.1
hlpf = fir1(100, alpha);

NfftHlpf = 2^ceil(log2(length(hlpf)));

Hlpf =fftshift(fft(hlpf, NfftHlpf));

omegaHlpf = (0:(NfftHlpf-1))*(2*pi/NfftHlpf)-pi;


figure(5)
plot(omegaHlpf/pi, abs(Hlpf));
xlabel('Frequency (\omega/\pi)')
ylabel('|Hlpf(e^{j\omega})|')
title('|Hlpf(e^{j\omega})| Spectrum')

%%% (f)
s = filter(hlpf, 1, r);
soundsc(s, fs)
% The voice says, "It was the best of times, it was the worst of times"
% I do still hear a faint noise in the backgroud

NfftS = 2^ceil(log2(length(s)));

S =fftshift(fft(s, NfftS));
omegaS = (0:(NfftS-1))*(2*pi/NfftS)-pi;



figure(6)
plot(omegaS/pi, abs(S));
xlabel('Frequency (\omega/\pi)')
ylabel('|S(e^{j\omega})|')
title('|S(e^{j\omega})| Spectrum')

% (g)
hcombo = conv(hlpf, hnotch);

NfftHcombo = 2^ceil(log2(length(hcombo)));

Hcombo = fftshift(fft(hcombo, NfftHcombo));
omegaHcombo = (0:(NfftHcombo-1))*(2*pi/NfftHcombo)-pi;

figure(7)
plot(omegaHcombo/pi, abs(Hcombo));
xlabel('Frequency (\omega/\pi)')
ylabel('|Hcombo(e^{j\omega})|')
title('|Hcombo(e^{j\omega})| Spectrum')

s2 = filter(hcombo, 1, y);
% soundsc(s2, fs)

% Yes, s2 removed the tone and the noise. It sounds just like the s.




