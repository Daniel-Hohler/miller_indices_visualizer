# miller_indices_visualizer
MATLAB tool which visualized miller indices in a 3D cubic structure, also computers lattice parameter and diffraction angle when given interplanar spacing and wavelength by user.
User input was carefully managed using simple error checks. Implemented file I/O using save, load, fopen, fclose, xlsread, xlswrite, supporting reading/writing to .mat, .txt, and .xlsx files. This enables seamless data import and export for potential data analysis/reporting.
Extended Documentation
Inputs
 The inputs this function calls for from the user are the following:
•	Miller Indices (Given as h, k, l)
•	Interplanar Spacing (d)
•	Wavelength (Given from choice of materials from excel file)
Outputs
The outputs this function gives are the following:
•	Visualized Miller indices in a cubic crystal structure
•	Diffraction angle
•	Lattice Parameter
•	Excel File with the last “3” runs (saves one last run per material)
•	Full archive of all input and output given by user saved in .txt file
Function Overview
	This function starts by asking the user if they would like to only visualize the miller plane, calculate lattice parameter and diffraction angle or both. It then takes the users inputted Miller indices and ensures that it is not undefined or too large to prevent the visualization from appearing too small, it then saves the users inputted Miller indices in a .mat file for ease of access when using the program again. 
	Then the function uses the Miller indices and finds its intercept values for a 1 x 1 x1 cube by dividing 1 by each Miller index, these are later used to create the points of which the plane is created from.
	After the function creates the unit cell by making a grid with all combinations (the 8 corners of a cube), once the matrices for the grid are created the 3d arrays are turned into column vectors, each row of this created matrix are corresponded with a corner of a cube.
	The display is then initialized with the title, axis, and sets the view model to 3D. Once it has the cube corners the function searches for every possible pair of the 8 corners of the cube and then loops through these points and finds only the points whose length is equal to 1 as any others would be diagonal lines not just the edges of the cube. These lines are then plotted making the cube.
	The intercept values found earlier are then mapped to a new [3x3] matrix. After they are mapped, we ensure that all numbers are finite as it is assumed if there is a 0 for one of the intercept values then its true value is infinite, this ensures that the only mapped plane points are those in the matrix whose row does not contain an infinite number.	
	Then to plot the function there needs to be 2 assumed cases by the function, the first one is where all 3 points reside within the cube and the plane is created by creating a plane between all 3 of the points creating a triangular plane. However, if one of these values is 0 it is technically infinite as mentioned before therefore, we must call to the miller plane equation to individually create a grid for each part of the axis. A mesh grid composed of many points with small gaps is utilized to mimic the plane. 
Once this is solved for a mask is created to ensure that the values of the planes reside within the cube as the sides which go infinitely would otherwise clip outside of the cube, so for any values in the newly created grids that are >=0 and <=1 are kept the rest are then set to NaN. Then finally it is plotted using the surf command, and the individual intercept points are also plotted for viewing. 
If the user had selected both or to calculate only the lattice parameter and diffraction angle, then the following code is run. The code asks the user to enter in an interplanar spacing value in nanometers, and after displays the excel file with the materials available to chose from for which they desire, giving the function the corresponding wavelength. If the user inputs anything incorrectly here the function will ask the user to try again until they input something that works with the function.
The next step finds a row index adding 1 to make sure it doesn’t overwrite the headings row, afterwards it pulls the lambda function based on the row index and calculates for the lattice parameter based on the interplanar spacing formula. Then the function uses Bragg’s law and solves for the diffraction angle. The answers are then printed to the console and written into the excel file to its corresponding material. After the excel, file is done writing a text file is opened and all inputs and outputs from the function are saved as into the text file, with the text file acting as an archive. Once it is done writing it is closed, and the program ends.
