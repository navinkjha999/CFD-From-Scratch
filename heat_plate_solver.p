"""
heat_plate_solver.py
====================================================================
2D STEADY-STATE HEAT CONDUCTION ON A SQUARE PLATE  (Laplace equation)

This is the "crystal clear" companion to the YouTube lesson:
    "The 5 steps of CFD - and how Python makes them glass"

It walks the EXACT same five steps a commercial CFD package runs,
but every step is plain, readable NumPy you can inspect:

    STEP 1  DOMAIN          define the physical region
    STEP 2  MESH            chop it into a grid of nodes
    STEP 3  DISCRETIZATION  turn the PDE into an algebraic update rule
    STEP 4  SOLVE           iterate that rule until it stops changing
    STEP 5  INTERPRET       read the temperature field / residual

The governing equation is the steady-state heat (Laplace) equation:

        d^2T/dx^2 + d^2T/dy^2 = 0

Physically: with no heat source and nothing changing in time, the
temperature at every interior point is just the AVERAGE of its
neighbours. That single sentence IS the solver.
====================================================================
"""

import numpy as np


# --------------------------------------------------------------------
# STEP 1 + STEP 2 :  DOMAIN  and  MESH
# --------------------------------------------------------------------
# A commercial code hides this behind "draw geometry" + "generate mesh".
# Here it is nothing but: pick how many nodes, make an empty grid.

nx = 50            # number of nodes in the x-direction
ny = 50            # number of nodes in the y-direction
                   # -> the plate is represented by a 50x50 grid of points.

# T is the temperature at every node. Start everything at 0.
# Shape (ny, nx): rows = y, columns = x  (numpy is row-major).
T = np.zeros((ny, nx))
#   ^ this 2D array IS the mesh + the unknown we are solving for.


# --------------------------------------------------------------------
# BOUNDARY CONDITIONS  (part of STEP 1: defining the physical problem)
# --------------------------------------------------------------------
# We hold the four edges at fixed temperatures (Dirichlet conditions).
# This is what makes the problem well-posed: the interior is unknown,
# the edges are KNOWN and never change during the solve.

T_top    = 100.0   # top edge held hot
T_bottom = 0.0     # bottom edge held cold
T_left   = 0.0     # left edge cold
T_right  = 0.0     # right edge cold

T[-1, :] = T_top      # last row  = top edge  -> all x, y = max
T[0,  :] = T_bottom   # first row = bottom edge
T[:,  0] = T_left     # first column = left edge
T[:, -1] = T_right    # last column  = right edge


# --------------------------------------------------------------------
# STEP 3 + STEP 4 :  DISCRETIZATION  and  SOLVE
# --------------------------------------------------------------------
# DISCRETIZATION: approximate the second derivatives with finite
# differences on the grid. For the Laplace equation this collapses to
# the famous 5-point stencil. Solving d^2T/dx^2 + d^2T/dy^2 = 0 for the
# centre node gives:
#
#     T[i,j] = ( T[i+1,j] + T[i-1,j] + T[i,j+1] + T[i,j-1] ) / 4
#
# i.e. every interior node = average of its 4 neighbours.  <-- the rule.
#
# SOLVE: apply that rule everywhere, over and over (Jacobi iteration),
# until the field stops changing. "Stops changing" is measured by the
# RESIDUAL - the same residual plot a commercial solver shows you.

max_iter = 5000        # safety cap on iterations
tolerance = 1e-5       # convergence threshold on the residual
residuals = []         # we log the residual each iteration (STEP 5 data)

for iteration in range(max_iter):

    T_old = T.copy()   # remember the field before this sweep

    # Apply the 5-point average to EVERY interior node at once.
    # Slicing does the whole grid in one vectorized line - no Python loops.
    #   T[1:-1, 1:-1]  = all interior nodes (edges excluded, they're fixed)
    #   T[2:,   1:-1]  = the neighbour ABOVE  each interior node
    #   T[:-2,  1:-1]  = the neighbour BELOW
    #   T[1:-1, 2:  ]  = the neighbour to the RIGHT
    #   T[1:-1, :-2 ]  = the neighbour to the LEFT
    T[1:-1, 1:-1] = 0.25 * (
        T_old[2:,   1:-1] +   # above
        T_old[:-2,  1:-1] +   # below
        T_old[1:-1, 2:  ] +   # right
        T_old[1:-1, :-2 ]     # left
    )

    # RESIDUAL: how much did the field move this sweep? When this is
    # tiny, the averages have settled and we have the solution.
    residual = np.max(np.abs(T - T_old))
    residuals.append(residual)

    if residual < tolerance:
        print(f"Converged after {iteration} iterations "
              f"(residual = {residual:.2e})")
        break
else:
    print(f"Reached max_iter={max_iter} without converging "
          f"(residual = {residual:.2e})")


# --------------------------------------------------------------------
# STEP 5 :  INTERPRET
# --------------------------------------------------------------------
# The number-crunching is done. Interpretation is reading the field:
# where is it hot, where is it cold, did it converge. A commercial code
# shows you a glossy contour plot; it is plotting THIS SAME ARRAY.

print(f"Max temperature in field: {T.max():.2f}")
print(f"Min temperature in field: {T.min():.2f}")
print(f"Centre-node temperature : {T[ny//2, nx//2]:.2f}")
print(f"Final residual          : {residuals[-1]:.2e}")
print(f"Iterations logged       : {len(residuals)}")

if __name__ == "__main__":
    # Optional quick visual if matplotlib is present - not required.
    try:
        import matplotlib.pyplot as plt
        plt.imshow(T, origin="lower", cmap="inferno")
        plt.colorbar(label="Temperature")
        plt.title("Steady-state temperature on the plate")
        plt.savefig("heat_plate_result.png", dpi=120)
        print("Saved heat_plate_result.png")
    except ImportError:
        pass
