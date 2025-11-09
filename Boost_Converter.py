# -*- coding: utf-8 -*-
"""
=====================================
Pengaruh Resistansi Seri Induktor
pada Ketidak-idealan Tegangan Output 
Rangkaian Boost-Converter
-------------------------------------
Acuan : 
Daniel W. Hart, "Power Electronics"
Bab 6, bagian 6.5 Boost Converter
Persamaan (6-42) dan (6-44)
halaman 219 - 220
-------------------------------------
1st coded on Thu Nov 6 08:59:30 2025 
Ihsan Hariadi - STEI ITB
=====================================
"""
import numpy as np
import matplotlib.pyplot as plt

Npoint  = 500
Npoint2 = Npoint - 3
step    = 1/Npoint
R       = 10.0
rL1     = 0.0
rL2     = 0.05
rL3     = 0.5
#
x1   = np.zeros((Npoint2))
#
y1   = np.zeros((Npoint2))
y2   = np.zeros((Npoint2))
y3   = np.zeros((Npoint2))
y4   = np.zeros((Npoint2))
y5   = np.zeros((Npoint2))
y6   = np.zeros((Npoint2))
#

for ii in range (Npoint2):
    D = ii*step
    x1[ii]      = D                       # D: Duty-cycle
    denom1      = 1 - D
    denom2      = R*(denom1*denom1)       # Eq. 6-42
    denom3a     = 1.0 + (rL1 / denom2)    # Eq. 6-42 utk rL1
    denom3b     = 1.0 + (rL2 / denom2)    # Eq. 6-42 utk rL2
    denom3c     = 1.0 + (rL3 / denom2)    # Eq. 6-42 utk rL3
    denom_real1 = denom1 * denom3a        # Eq. 6-42 utk rL1
    denom_real2 = denom1 * denom3b        # Eq. 6-42 utk rL2
    denom_real3 = denom1 * denom3c        # Eq. 6-42 utk rL3
#
    denom4a     = rL1 / denom2            # Eq. 6-44 utk rL1
    denom4b     = rL2 / denom2            # Eq. 6-44 utk rL2
    denom4c     = rL3 / denom2            # Eq. 6-44 utk rL3
#
    y1[ii]      = 1.0/denom_real1         # Vo/Vs  utk rL1
    y2[ii]      = 1.0/denom_real2         # Vo/Vs  utk rL2
    y3[ii]      = 1.0/denom_real3         # Vo/Vs  utk rL3
    y4[ii]      = 100.0 / (1.0 + denom4a) # Eta(%) utk rL1
    y5[ii]      = 100.0 / (1.0 + denom4b) # Eta(%) utk rL2
    y6[ii]      = 100.0 / (1.0 + denom4c) # Eta(%) utk rL3
  
# ---- Plot Vo/Vs sbg fungsi dari D (Fig 6-10a) ----------
fig1 = plt.figure()
ax = fig1.add_subplot()
fig1.subplots_adjust(top=0.90)
ax.tick_params(axis='both', labelsize=14) 
fig1.suptitle('Kinerja Boost-Converter', fontsize=14, fontweight='bold')
ax.set_xlabel('Duty-Cycle ( x 100% )', fontsize=12, fontweight='bold')
ax.set_ylabel('Vo/Vs', fontsize=12, fontweight='bold')

plt.ylim(0, 20) 
line , = ax.plot(x1,y1, label = r'$ r_L = 0.0 \Omega $')
plt.setp(line, color='purple', linewidth=5)
line , = ax.plot(x1,y2, label = r'$ r_L = 0.05 \Omega $')
plt.setp(line, color ='orange', linewidth=5)
line , = ax.plot(x1,y3, label = r'$ r_L = 0.5 \Omega $')
plt.setp(line, color ='green', linewidth=5)

plt.text(0.015, 7, r'$ R  = 10 \Omega $', fontsize=18, color='white', style='italic', bbox=dict(facecolor='red', alpha=0.5))
plt.text(0.015, 12, r'$ V_o = \left( \frac {V_s}{1.0 - D} \right) \left( \frac{1.0}{1.0 + \frac{r_L}{R(1.0 - D)^2}} \right) $', fontsize = 20, bbox=dict(facecolor='yellow', alpha=0.5))

# plt.arrow(0.65, 30, 0.270, -50, width=0.01)

plt.grid(True, color='w', linestyle='-', linewidth=2)
plt.gca().patch.set_facecolor('0.9')

plt.legend()
plt.show()

# --- Plot Eta (%) sbg fungsi dari D (pers. 6-10b) ----
fig2 = plt.figure()
ax = fig2.add_subplot()
fig2.subplots_adjust(top=0.90)
ax.tick_params(axis='both', labelsize=14) 
fig2.suptitle('Efisiensi Boost-Converter', fontsize=14, fontweight='bold')
ax.set_xlabel('Duty-Cycle ( x 100% )', fontsize=12, fontweight='bold')
ax.set_ylabel('Efisiensi (%)', fontsize=12, fontweight='bold')
line , = ax.plot(x1,y4, label = r'$ r_L = 0.0 \Omega $')
plt.setp(line, color ='purple', linewidth=5)
line , = ax.plot(x1,y5, label = r'$ r_L = 0.05 \Omega $')
plt.setp(line, color ='orange', linewidth=5)
line , = ax.plot(x1,y6, label = r'$ r_L = 0.5 \Omega $')
plt.setp(line, color ='green', linewidth=5)

plt.text(0.375, 10, r'$ R  = 10 \Omega $', fontsize=18, color='white', style='italic', bbox=dict(facecolor='red', alpha=0.5))
plt.text(0.05, 40, r'$ \eta = \frac{1.0}{1.0 + \frac{r_L}{R(1.0 - D)^2}} $', fontsize = 20, bbox=dict(facecolor='yellow', alpha=0.5))

plt.grid(True, color='w', linestyle='-', linewidth=2)
plt.gca().patch.set_facecolor('0.9')

plt.legend()
plt.show()

# ---------------------------------------------
# Pembuatan kode LaTeX untuk pers. Matematika
# kode Latex yg dihasilkan di layer (console)
# bisa dilihat dgn copy paste ke situs 
# free Latex viewer - register dari Google
# https://latexeditor.lagrida.com/
# ---------------------------------------------
#

from sympy import symbols, latex

x, y, rL, R, D = symbols('x y rL R D')
expr1 = (x + y)**2
expr2 = (x + y)/x
expr3 = 1.0 / (1.0 + rL / (R * (1.0 - D)**2) )

latex_code01 = latex(expr1)
latex_code02 = latex(expr2)
latex_code03 = latex(expr3)

print(latex_code01)
print(latex_code02)
print(latex_code03)
