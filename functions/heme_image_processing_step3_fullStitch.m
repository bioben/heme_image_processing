function [finalImageStitched] = heme_image_processing_step3_fullStitch(rootFolderName)
%% HEME IMAGE PROCESSING - STEP 3
% author Benjamin Ahn
% version 1.0 Oct 2020
% 
% DESCRIPTION
% Full Stitch: this script takes horizontal image strips that have been
% processed in ImageJ using the BaSiC tool (Step2). It will then build
% fully stitched images
%
% INPUT ARGUMENTS
%   rootFolderName - a string that contains the path to a directory containing original tile images
% 
% OUTPUTS
%   finalImageStitched - a 2D matrix that represents a fully stitched image
%

%% Access BaSiC-processed image strips
folderName = rootFolderName;
addpath(genpath(folderName));
image_set = dir(folderName);
image_set(1:2) = [];

% This will be used to build the final image
finalImage = [];

for j = 1:length(image_set)
    
    % Read in each horizontal image strip
    imageRow = imread(rootFolderName + "/" + image_set(j).name);
    
    % Vertically add each image strip
    finalImage = [finalImage; imageRow];
    
end

finalImageStitched = finalImage;

end