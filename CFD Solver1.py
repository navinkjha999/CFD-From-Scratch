"""
=========================================================
 CFD Solver From Scratch in Python
 Episode 2 : Building the Computational Grid
=========================================================

In this episode we will:

1. Define the computational domain
2. Divide the domain into uniform cells
3. Compute the cell width
4. Generate cell-centre coordinates
5. Create arrays for the solver variables

Author: Engineering Insight Lab
"""

import numpy as np
import matplotlib.pyplot as plt

# =========================================================
# 1. Define the computational domain
# =========================================================

L = 1.0              # Length of the domain (m)
nx = 8               # Number of computational cells

# =========================================================
# 2. Compute the cell width
# =========================================================

dx = L / nx

print(f"Domain Length : {L:.3f} m")
print(f"Number of Cells : {nx}")
print(f"Cell Width dx : {dx:.3f} m")

# =========================================================
# 3. Generate cell-centre coordinates
# =========================================================

x = np.linspace(dx/2, L - dx/2, nx)

print("\nCell Centre Coordinates")
print(x)

# =========================================================
# 4. Allocate solver variables
# =========================================================

u = np.zeros(nx)     # Velocity
p = np.zeros(nx)     # Pressure
T = np.zeros(nx)     # Temperature

print("\nVelocity Array")
print(u)

print("\nPressure Array")
print(p)

print("\nTemperature Array")
print(T)

# =========================================================
# 5. Plot the computational grid
# =========================================================

plt.figure(figsize=(10,2))

# Draw domain
plt.plot([0, L], [0, 0], 'k', linewidth=2)

# Draw cell boundaries
boundaries = np.linspace(0, L, nx+1)

for b in boundaries:
    plt.plot([b, b], [-0.08, 0.08], 'k')

# Draw cell centres
plt.scatter(
    x,
    np.zeros_like(x),
    s=80,
    color='red',
    zorder=5,
    label='Cell Centres'
)

# Label cell centres
for i, xc in enumerate(x):
    plt.text(
        xc,
        -0.18,
        f"{i}",
        ha='center',
        fontsize=10
    )

plt.title("One-Dimensional Computational Grid")

plt.xlabel("x (m)")
plt.yticks([])

plt.xlim(-0.05, L+0.05)
plt.ylim(-0.3, 0.3)

plt.grid(axis='x', linestyle='--', alpha=0.4)

plt.legend()

plt.tight_layout()

plt.show()