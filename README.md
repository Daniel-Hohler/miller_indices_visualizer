# Overview
**Features**


3D visualization of Miller indices in a cubic crystal structure

Calculates lattice parameter and diffraction angle using Bragg’s Law

User input validation and error handling

File I/O support for .mat, .txt, and .xlsx formats

Archives last used miller indices to .mat file

Archives inputs/outputs the last result per material to .xlsx file

Archives inputs/outputs all results into .txt file

**User Inputs**


Miller indices: h, k, l

Interplanar spacing d (nm)

Wavelength (selected from .xlsx material file)

**Outputs**


3D visual of Miller planes

Lattice parameter

Diffraction angle

.xlsx file with last 3 runs per material

.txt archive log of all runs

**Function Workflow**


Ask user whether to visualize, calculate, or both

Validate and save Miller indices

Compute intercepts, draw unit cell and cube edges

Plot Miller plane using either:

Three-point triangle (when finite)

Mesh grid with clipping (when infinite axis)

If selected, calculate:

Lattice parameter

Diffraction angle using Bragg’s Law

Save results to Excel and log to text file
