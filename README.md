# Enhancing Signal-to-Noise Ratio (SNR) in Air Traffic Communication

📡 This project explores techniques to **improve Signal-to-Noise Ratio (SNR)** in air traffic communication systems.  
Improved SNR directly enhances **reliability, clarity, and safety** in aviation communication.

---

## 📖 Overview
- **Domain:** Wireless Communication, Air Traffic Control (ATC)
- **Techniques Implemented:**
  1. **Receiver Noise Figure Reduction**  
  2. **Antenna Diversity (Maximal-Ratio Combining, MRC)**  
  3. **LDPC Forward Error Correction**
- **Tools:** MATLAB (simulation + visualization)

---

## 🛠️ Implementation
MATLAB scripts provided for each technique:

- `noise_figure_improvement.m` → NF reduction improves SNR by ~3 dB  
- `antenna_diversity_mrc.m` → MRC combining with 4 branches improves SNR by ~6 dB  
- `ldpc_coding_bpsk.m` → LDPC coding provides ~5 dB coding gain  
- `combined.m` → Combined results (~10 dB net improvement)

---

## 📊 Results
| Technique                  | Gain (dB)   |
|-----------------------------|-------------|
| Noise Figure Reduction      | +3          |
| 2-branch MRC                | +3          |
| 4-branch MRC                | +6          |
| LDPC (R = 1/2)              | +5          |
| **Combined**                | **+10**     |

Example plot:  
(Insert results/combined.png here)

---

## ✈️ Significance
- **Reduced Bit Error Rate (BER)** → More reliable digital communication  
- **Clearer Voice Transmission** → Critical for pilot-controller communication  
- **Robust ATC Links** → Improved safety, efficiency, and range  

---

## 📂 Repository Structure
snr-enhancement-air-traffic/
│── README.md # Project documentation
│── LICENSE # License file
│
├── report/ # Final project report
│ └── snr2-3.pdf
│
├── matlab/ # MATLAB simulation codes
│ ├── noise_figure_improvement.m
│ ├── antenna_diversity_mrc.m
│ ├── ldpc_coding_bpsk.m
│ └── combined.m
│
├── results/ # Output plots and comparison figures
│ ├── nf_vs_snr.png
│ ├── mrc_vs_single.png
│ ├── ldpc_output_snr.png
│ └── combined.png
