%% combined_snr_improvements.m
% Compare SNR improvements for:
%  1) Noise Figure (NF)
%  2) Antenna Diversity (4-branch MRC)
%  3) LDPC-Coded BPSK
%
% All curves plotted over Eb/N0 = 0:2:20 dB

clc; clear; close all;

%% Common Eb/N0 range
EbN0dB    = 0:2:20;

%% 1) Noise Figure Improvement
F_base    = 6;        % NF = 6 dB
F_imp     = 3;        % NF = 3 dB
numSymbols= 1e4;      % number of BPSK symbols

% Generate one BPSK waveform
bits_nf = randi([0 1],numSymbols,1);
tx_nf   = pskmod(bits_nf,2,pi);

SNR_base = zeros(size(EbN0dB));
SNR_imp  = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    % simulate receiver NF by reducing effective Eb/N0
    y_base = awgn(tx_nf, EbN0dB(k)-F_base, 'measured');
    y_imp  = awgn(tx_nf, EbN0dB(k)-F_imp,  'measured');
    SNR_base(k) = snr(tx_nf, y_base - tx_nf);
    SNR_imp(k)  = snr(tx_nf, y_imp  - tx_nf);
end

%% 2) Antenna Diversity via 4-branch MRC
M = 4;
bits_mrc = randi([0 1],numSymbols,1);
tx_mrc   = pskmod(bits_mrc,2,pi);

SNR_mono = zeros(size(EbN0dB));
SNR_mrc  = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    noiseVar = 10^(-EbN0dB(k)/10);
    % single-branch
    y1 = awgn(tx_mrc, EbN0dB(k), 'measured');
    SNR_mono(k) = snr(tx_mrc, y1 - tx_mrc);
    % MRC combining
    y_comb = zeros(size(tx_mrc));
    for m = 1:M
        h = (randn(size(tx_mrc)) + 1j*randn(size(tx_mrc))) / sqrt(2);
        n = sqrt(noiseVar/2)*(randn(size(tx_mrc)) + 1j*randn(size(tx_mrc)));
        y_branch = h.*tx_mrc + n;
        y_comb = y_comb + conj(h).*y_branch;
    end
    SNR_mrc(k) = snr(tx_mrc, y_comb - tx_mrc);
end

%% 3) LDPC-Coded BPSK (DVB-S2 R=1/2) with manual mod/demod
msgLen  = 32400;       % # info bits
maxIter = 50;          % LDPC decoder iterations

% LDPC setup
H    = dvbs2ldpc(1/2);
eCfg = ldpcEncoderConfig(H);
dCfg = ldpcDecoderConfig(H);

outSNR_ldpc = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    % encode
    data    = randi([0 1],msgLen,1);
    coded   = ldpcEncode(data,eCfg);      % length N = 64800
    % manual BPSK: 0→+1, 1→−1
    txBPSK  = 1 - 2*double(coded);
    % AWGN
    rxBPSK  = awgn(txBPSK, EbN0dB(k), 'measured');
    noiseVar= 10^(-EbN0dB(k)/10);
    % manual LLR demod: LLR = 2*rx / noiseVar
    llr     = (2/noiseVar)*rxBPSK;
    % decode
    decBits = ldpcDecode(llr, dCfg, maxIter);
    % re-encode & re-modulate
    reCoded = ldpcEncode(decBits, eCfg);
    txRecon = 1 - 2*double(reCoded);
    % output SNR
    outSNR_ldpc(k) = snr(txRecon, rxBPSK - txRecon);
end

%% 4) Plot all results
figure; hold on; grid on;
plot(EbN0dB,  SNR_base,   '-o', 'LineWidth',1.5);
plot(EbN0dB,  SNR_imp,    '-x', 'LineWidth',1.5);
plot(EbN0dB,  SNR_mrc,    '-s', 'LineWidth',1.5);
plot(EbN0dB,  outSNR_ldpc,'-d', 'LineWidth',1.5);

xlabel('Input Eb/N0 (dB)');
ylabel('Output SNR (dB)');
title('Comparison of SNR Improvement Techniques for ATC Links');
legend(...
  'NF = 6 dB (Baseline)', ...
  'NF = 3 dB (Improved)', ...
  '4-Branch MRC', ...
  'LDPC R=1/2', ...
  'Location','NorthWest');
