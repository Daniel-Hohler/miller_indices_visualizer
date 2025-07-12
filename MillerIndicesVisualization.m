% Daniel Hohler Miller Indices Visualization ME 1311 Project - 7/11/2025
% This function takes a user inputted Miller Indices and creates a 3D model
% of the plane it creates for crystallography in crystal lattices. This
% function also finds a and 2θ when given the interplanar spacing value on
% top of the Miller indices
% 
% The user has the option to either load in stored values from the last
% attempt through a file that is saved after the miller indices are typed
% in for the first time, or to enter new values
% For the sake of ease of viewing the maximum for the miller indices is set
% to a maximum of 5 for either positive or negative numbers
% *Note negative numbers will cause the plane to appear outside of the cube
% however it remains accurate to how it would appear if another cube were
% visualized(to keep plane inside cube only use positive numbers)*
%
% The lambda functions are found in an excel file tagged to this project,
% and whatever a & 2θ they find is written into the same excel file along
% with the Miller indices and d value they inputted for each material.
% An archive is also created in a .txt file of every run the user has done.
%
% The user also has the choice to just visualize their Miller indices plane
% [1] or to calculate an a and 2θ based on their inputted planar spacing 
% value and Miller Indices[2]. The user can also run both [3].

function MillerIndicesVisualization
clc
help MillerIndicesVisualization
% Boolean variable for reprompting user
varcontinue = false;
% Choice to use Saved Values or not

while ~varcontinue
    choiceOfCalculation = input('Would you like to display the Miller indices [1], Calculate a and 2θ based on input of d and λ [2], or both [3]?: ');
    if ismember(choiceOfCalculation, [1, 2, 3])
        varcontinue = true;
    else
        disp('Please enter 1 , 2, or 3')
        end
end

varcontinue = false;



    while ~varcontinue
        userChoice = input('Would you like to use the previously inputted Miller indices? (y/n): ', 's');
        if strcmpi(userChoice, 'y') || strcmpi(userChoice, 'n')
            varcontinue = true;
        else
            fprintf('Invalid choice. Please enter ''y'' or ''n''.\n');
        end
    end
    if lower(userChoice) =='y'
        load('savedMillerIndices.mat', 'h', 'k', 'l');
        fprintf('Loaded Values, h = %d, k = %d, l = %d''.\n', h, k, l);
    else
        varcontinue = false;
        while ~varcontinue 
            % Prompt user for Miller Indices input
            h = input('Enter Miller Index Value For h: ');
            k = input('Enter Miller Index Value For k: ');
            l = input('Enter Miller Index Value For l: ');
    
            if abs(h) > 5 || abs(k) > 5 || abs(l) > 5
            fprintf('Please enter a Miller indices between -5 and 5 to ensure clarity in visual. Please enter new values''.\n')
            elseif h == 0 && k == 0 && l == 0
            fprintf('Miller indices cannot all be zero undefined. Please enter new values''.\n');
            else
            varcontinue = true;
            end
        end
        save('savedMillerIndices.mat', 'h', 'k', 'l')
        disp('Saved Miller indices to savedMillerIndices.mat')
    end
if ismember(choiceOfCalculation, [1, 3])
    % Calculate the reciprocal/intercept for user values
    % Assuming for this model that the cube is 1 x 1 x 1
    a = 1; b = 1; c = 1;
    interceptValues = [inf inf inf];
    
    if h ~= 0 
        interceptValues(1) = a / h; end
    if k ~= 0
        interceptValues(2) = b / k; end
    if l ~= 0
        interceptValues(3) = c / l; end
    
    % Creates the unit cell and maps points to matrix
    [X, Y, Z] = meshgrid(0:1, 0:1, 0:1);
    pointMatrix = [X(:), Y(:), Z(:)];
    % Create Cube
    figure;
    hold on;
    axis equal;
    xlabel('x axis'); ylabel('y axis'); zlabel('z axis')
    view(3)
    title('Miller Plane');
    
    % Create all combinations of 2 points possible from the corners
    edge = nchoosek(1:8, 2);
    for i = 1:size(edge,1)
        point1 = pointMatrix(edge(i,1), :);
        point2 = pointMatrix(edge(i,2), :);
        if sum(abs(point1-point2)) == 1
            plot3([point1(1),point2(1)], [point1(2), point2(2)], [point1(3), point2(3)], 'k');
        end
    end
    % Create the points of the plane based on the Miller Index Intercepts
    planePoints = [interceptValues(1), 0, 0; 0, interceptValues(2), 0; 0, 0, interceptValues(3)];
    planePoints = planePoints(all(isfinite(planePoints), 2), :);
    
    % KEY EQUATION FOR PLANE = hx + ky + lz = 1
    % If all points are not inside of the cube then here we use plane equation
    % to find the the rest of the points needed
    if size(planePoints, 1) < 3
        % Create small matrices to assign points to make model appear like a
        % sheet/plane (creating a grid)
        if h ~= 0
            [yGrid, zGrid] = meshgrid(0:0.05:1, 0:0.05:1);
            xGrid = (1 - k * yGrid - l * zGrid) / h;
        elseif k ~= 0
            [xGrid, zGrid] = meshgrid(0:0.05:1, 0:0.05:1);
            yGrid = (1 - h * xGrid - l * zGrid) / k;
        elseif l ~= 0
            [xGrid, yGrid] = meshgrid(0:0.05:1, 0:0.05:1);
            zGrid = (1 - h * xGrid - k * yGrid) / 1;
        end
        % Create a mask to clip any parts of grid that would stretch outside 
        maskValues = (zGrid >= 0 & zGrid <= 1) & ...
        (yGrid >= 0 & yGrid <= 1) & ...
        (xGrid >= 0 & xGrid <= 1);
        xGrid(~maskValues) = NaN;
        yGrid(~maskValues) = NaN;
        zGrid(~maskValues) = NaN;
        surf(xGrid, yGrid, zGrid, 'FaceColor', 'b','FaceAlpha', .5, 'EdgeColor','none');
    else
        % Plotting triangle if theres 3 points inside cube
        fill3(planePoints(:,1),planePoints(:,2),planePoints(:,3), 'b', 'FaceAlpha', 0.5);
    end
    
    scatter3(planePoints(:,1),planePoints(:,2),planePoints(:,3), 50, 'ro', 'filled')

end
% If user chose to calculate runs this if statement
varcontinue = false;
if ismember(choiceOfCalculation, [2,3])
    % Asks for user planar spacing value
    while ~varcontinue 
        d = input('Please enter interplanar spacing value(nm): \n');
        if isnumeric(d) && isscalar(d) && d > 0
            varcontinue = true;
        else
            ('Please Enter an Integer \n')
        end
    end
    varcontinue = false;
    % Reads excel file that contains material and the wavelength typically
    % Associated with it for X-ray diffraction
    excelFile = 'wavelengthsinfo.xlsx';
    [~, ~, raw] = xlsread(excelFile);
    % Asks User to choose from list given from the excel file
    fprintf('Choose a material: \n')
    while ~varcontinue
        materialNames = raw(2:end,1);
        disp('Available materials: ')
        disp(materialNames);
        selectedMaterial = input('Enter material name exactly as listed: ', 's')
        if any(strcmpi(selectedMaterial, materialNames))
            varcontinue = true;
        else
            fprintf('Invalid material. Please choose one from the list''.\n')
        end
    end 
    % Save index for where xslwrite should be used later
    rowIndex = find(strcmpi(materialNames, selectedMaterial)) + 1;

    lambda = raw{rowIndex, 2};
    % d = a/(sqrt(h^2 + k^2 + l^2)
    a = d * sqrt(h^2 + k^2 + l^2);

    % Assuming here that n = 1 
    % Bragg's Law
    % nλ = 2dsinθ

    thetaRAD = asin(lambda / (2 * d));
    thetaDegrees = 2*(rad2deg(thetaRAD));

    fprintf('Angle 2θ = %.2f degrees, a = %.4f nm',thetaDegrees,a);
    xlswrite(excelFile, {h,k,l,d,thetaDegrees, a}, 'Sheet1', ['C' num2str(rowIndex)]);
    archiveFile = 'MillerIndicesArchive.txt';
    fileID = fopen(archiveFile, 'a');
    if fileID == -1
        warning('File unable to open')
    else 
        fprintf(fileID, 'Material: %s, h: %d, k: %d, l: %d, d: %.4f nm, λ: %.4f nm, 2θ: %.2f, a = %.4f nm \n', selectedMaterial, h, k, l, d, lambda, thetaDegrees, a);
        fclose(fileID);
    end
end
end
