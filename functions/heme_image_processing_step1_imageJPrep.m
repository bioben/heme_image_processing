function heme_image_processing_step1_imageJPrep(rootFolderName, totalImageCount, horizontalLength)
%% HEME IMAGE PROCESSING - STEP 1
% author Benjamin Ahn
% version 1.0 Oct 2020
% 
% DESCRIPTION
% ImageJ Prep: This script takes tiles and stitches them into horizontal
% strips. The horizontal strips are then saved, which will then be
% processed in Step2
%
% INPUT ARGUMENTS
%   rootFolderName - a string that contains the path to a directory containing original tile images
%   horizontal - an integer of the width of the fully stitched image, and
%                      in effect, a horizontal strip
%   totalImageCount - an integer of the total number of tiles in the full image

%% Read in images
folderName = rootFolderName;
addpath(genpath(folderName));
image_set = dir(folderName);
image_set(1:2) = [];

%% Read in images into a matrix
for i = 1:totalImageCount
    originalImage = imread(image_set(i).name);
    imageMatrix(:,:,i) = originalImage;
end

%% Add images horizontally. Build horizontal image strips
image_array = [];
image_row_array = [];
horizontalGrowingLength = 0;

arrayOfImageRows = containers.Map('KeyType', 'int32', 'ValueType', 'any');
rowCounter = 1;

for i=1:totalImageCount
        
    % Read a tile image
    current_image = imageMatrix(:,:,i);

    % Crop off left anheightd top sides to adjust for overlap
    % NOTE: this value might change depending on the image
    current_image = current_image(53:736,65:912);

    % Add tile image to image_row_array horizontally
    image_row_array = [image_row_array current_image];
    horizontalGrowingLength = horizontalGrowingLength + 1;

    % When the image row is built, add it vertically to the image_array
    if rem(horizontalGrowingLength, horizontalLength) == 0
        
        % Add horizontal row to arrayOfImageRows to keep
        arrayOfImageRows(rowCounter) = image_row_array;
        rowCounter = rowCounter + 1;  
        image_row_array = [];
        
    end
end

%% Save horizontal image strips

% The ./hor directory should have been built in Step0
savePathRoot = [rootFolderName '/hor'];

% Build the save pathway
originalPathArray = split(rootFolderName, '/');
condition = originalPathArray(length(originalPathArray));

disp(['Condition: ' condition{1, 1}]);

% Save horizontal image strips
for i = 10:length(arrayOfImageRows) + 9
    currentRow = arrayOfImageRows(i - 9);
    savePath = append(savePathRoot, '/', condition, '_', int2str(i), '.tif');
    imwrite(currentRow, savePath{1, 1});
end
