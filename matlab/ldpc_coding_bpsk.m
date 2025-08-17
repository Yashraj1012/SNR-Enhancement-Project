%% ldpc_coding_bpsk_manual.m
% Output-SNR of DVB-S2 rate-1/2 LDPC-coded BPSK using manual modulation

clc; clear; close all;

%% 1) Parameters
EbN0dB   = 0:2:20;       % Eb/N0 range
msgLen   = 32400;       % # info bits K
maxIter  = 50;          % max LDPC decoding iterations

%% 2) LDPC (DVB-S2 rate=1/2) setup
H      = dvbs2ldpc(1/2);      % parity-check matrix (32400×64800)
eCfg   = ldpcEncoderConfig(H);
dCfg   = ldpcDecoderConfig(H);

%% 3) Loop over Eb/N0
outSNR = zeros(size(EbN0dB));
for k = 1:length(EbN0dB)
    %% a) Generate & encode
    data    = randi([0 1], msgLen, 1);    % info bits
    coded   = ldpcEncode(data, eCfg);     % codeword bits, length N=64800

    %% b) Manual BPSK modulation: 0→+1, 1→-1
    txSig   = 1 - 2*coded;                 % TX symbols in {+1, -1}

    %% c) AWGN channel
    EbN0    = EbN0dB(k);
    rxSig   = awgn(txSig, EbN0, 'measured');  
    noiseVar= 10^(-EbN0/10);               % noise variance per dimension

    %% d) Manual LLR demodulation
    % For BPSK in AWGN: LLR ≈ 2*rxSig / noiseVar
    llr     = (2/ noiseVar) * rxSig;

    %% e) LDPC decode (soft-input)
    decBits = ldpcDecode(llr, dCfg, maxIter);  % returns K bits

        %% f) Re-encode decoded bits to full codeword
    reCoded = ldpcEncode(decBits, eCfg);         % back to length N
    txRecon = 1 - 2*double(reCoded);              % re-modulated symbols (double)

    %% g) Compute Output SNR
    outSNR(k) = snr(txRecon, rxSig - txRecon);
end

%% 4) Plot
figure;
plot(EbN0dB, outSNR, '-x','LineWidth',1.5);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Output SNR (dB)');
title('LDPC-Coded BPSK Output SNR (Manual Mod/Demod)');
legend('LDPC R=1/2','Location','NorthWest');
