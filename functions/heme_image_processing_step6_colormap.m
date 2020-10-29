function [minOverall, maxOverall] = nonuniform_illumination_step6_colormap(imageMap)
%% CORRECTING NONUNIFORM ILLUMINATION IN TILED HISTOLOGY IMAGES - STEP 6
% author Benjamin Ahn
% version 1.0 Oct 2020
%
% DESCRIPTION
% A ratio image of the 488/555 channel will have been created in Step 5 .
% 
% Step 6: the min and max value across all images will be found. These will
% then be used as the limits of a color map that can be universally applied
% to all images
%
% INPUT ARGUMENTS
%       imageMap - a hashmap that contains integers (keys) mapped to ratio
%                           images (values)
% OUTPUTS
%       minOverall - an integer that represents the lowest pixel value across all ratio images
%       maxOverall - an integer that represents the highest pixel value across all ratio images 
%
%% Preliminary Variables

index = length(imageMap);

% Will hold the min value for each image
minValueArray = []; 

% Will hold the max value for each image
maxValueArray = [];

%% Find the min and max values in each image

for i = 1:index
    % Find the min value in each column
    minRow = min(imageMap(i));
    
    % Find the min value 
    minValue = min(minRow);
    minValueArray(i) = minValue;
    
    % Find the max value in each column
    maxRow = max(imageMap(i));
    
    % Find the max value
    maxValue = max(maxRow(~isinf(maxRow)));
    maxValueArray(i) = maxValue;
    
end

%% Find the min/max values across images

minOverall = min(minValueArray);
maxOverall = max(maxValueArray);

end
