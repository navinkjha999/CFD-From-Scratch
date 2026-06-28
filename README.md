# CFD From Scratch

Build Computational Fluid Dynamics from first principles — in plain Python, with no black box.

This repo holds the companion code for the **CFD From Scratch** video series. Every lesson derives the method from scratch and implements it in readable NumPy, so you can see exactly what commercial CFD software does at every step: **domain → mesh → discretization → solve → interpret**.

> The philosophy: if you can't read the code, you don't understand the method. So every solver here is written line by line, with each statement explained.

## Lessons

| # | Lesson | Code | Status |
|---|--------|------|--------|
| 00 | The 5 Steps of CFD in Python | [`lesson00_five_steps/`](lesson00_five_steps/) | ✅ Available |
| 01 | Navier–Stokes, term by term | — | 🔜 Coming |
| 02 | Finite differences from scratch | — | 🔜 Coming |
| 03 | 1D linear convection & the CFL condition | — | 🔜 Coming |
| … | (see the series for the full roadmap) | — | 🔜 |

## Quick start

```bash
git clone https://github.com/<your-username>/cfd-from-scratch.git
cd cfd-from-scratch
pip install -r requirements.txt
python lesson00_five_steps/code/cfd_five_steps_in_python.py
```

That runs the complete five-step heat-conduction solver and saves a result figure. The entire CFD pipeline, in one short file you can read top to bottom.

## What you need

- Python 3.9+ (the series is developed on 3.11)
- `numpy`, `matplotlib` (and `scipy` from later lessons)
- For the animations: [Manim Community Edition](https://www.manim.community/) 0.20.x — see [`lesson00_five_steps/manim/`](lesson00_five_steps/manim/)

## Credit

The 1D→2D→Navier–Stokes teaching arc follows the structure pioneered by Prof. Lorena Barba's [**"12 Steps to Navier–Stokes"**](https://github.com/barbagroup/CFDPython) (CC-BY licensed), extended here with animation, finite-volume methods, the SIMPLE algorithm, and validated cases.

## License

Code in this repository is released under the [MIT License](LICENSE).
