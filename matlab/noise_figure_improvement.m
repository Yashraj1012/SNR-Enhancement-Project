%% noise_figure_improvement.m
% Compare BPSK output SNR with two different receiver noise figures

clc; clear; close all;

% 1) Parameters
EbN0dB    = 0:2:20;    % range of Eb/N0 in dB
F_base    = 6;         % baseline noise figure (dB)
F_improved= 3;         % improved noise figure (dB)
numSymbols= 1e4;       % number of BPSK symbols

% 2) Generate BPSK signal
bits = randi([0 1],numSymbols,1);
tx   = pskmod(bits,2,pi);  % BPSK with phase offset pi

% 3) Simulate over Eb/N0 range
SNR_base = zeros(size(EbN0dB));
SNR_imp  = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    snr_base = EbN0dB(k) - F_base;     % effective SNR with NF=6
    snr_imp  = EbN0dB(k) - F_improved; % effective SNR with NF=3

    y1 = awgn(tx, snr_base, 'measured');
    y2 = awgn(tx, snr_imp,  'measured');

    SNR_base(k) = snr(tx, y1 - tx);
    SNR_imp(k)  = snr(tx, y2 - tx);
end

% 4) Plot
figure;
plot(EbN0dB, SNR_base,'-o', EbN0dB, SNR_imp,'-x','LineWidth',1.5);
grid on; xlabel('Input Eb/N0 (dB)'); ylabel('Output SNR (dB)');
legend('NF = 6 dB','NF = 3 dB','Location','NorthWest');
title('Noise Figure Improvement');
