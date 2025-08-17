%% antenna_diversity_mrc.m
% Show output SNR gain using 4-branch Max‑Ratio Combining (M=4)

clc; clear; close all;

% 1) Parameters
EbN0dB    = 0:2:20;
M         = 4;         % # of diversity branches
numSymbols= 1e4;

% 2) Generate BPSK
bits = randi([0 1],numSymbols,1);
tx   = pskmod(bits,2,pi);

% 3) MRC simulation
SNR_mono = zeros(size(EbN0dB));
SNR_mrc  = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    noiseVar = 10^(-EbN0dB(k)/10);
    y_comb   = zeros(size(tx));
    % single-branch
    y1 = awgn(tx, EbN0dB(k), 'measured');
    SNR_mono(k) = snr(tx, y1 - tx);
    % M-branch
    for m = 1:M
        h = (randn(size(tx))+1j*randn(size(tx)))./sqrt(2); 
        n = sqrt(noiseVar/2)*(randn(size(tx))+1j*randn(size(tx)));
        y = h.*tx + n;
        y_comb = y_comb + conj(h).*y;
    end
    SNR_mrc(k) = snr(tx, y_comb - tx);
end

% 4) Plot
figure;
plot(EbN0dB, SNR_mono,'-o', EbN0dB, SNR_mrc,'-s','LineWidth',1.5);
grid on; xlabel('Eb/N0 (dB)'); ylabel('Output SNR (dB)');
legend('Single Antenna','4‑Branch MRC','Location','NorthWest');
title('Antenna Diversity (MRC)');
