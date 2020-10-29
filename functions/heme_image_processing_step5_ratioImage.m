function [finalRatioImage] = heme_image_processing_step5_ratioImage(greenImage, redImage)
%% CORRECTING NONUNIFORM ILLUMINATION IN TILED HISTOLOGY IMAGES - STEP 5
% author Benjamin Ahn
% version 1.0 Sept 2020
%
% DESCRIPTION
% Two co-registered, background-subtracted images, one of the 488 and 555
% channels, should have been created in Step 4. 
% 
% Step 5: a ratio of the images will be taken, creating a final image. This
% new image will then be adjusted to a color map. 
%
% INPUT ARGUMENTS
%       greenImage - a 2D matrix representing a co-registered, background-subtracted image of the 488 channel
%       redImage - a 2D matrix representing a co-registered, background-subtracted image of the 555 channel
%     
% OUTPUTS
%       finalRatioImage - a 2D matrix representing a new image of the greenImage divided by the redImage, which is then adjusted to a color map
%
%% Convert to double

greenImageDouble = double(greenImage);
redImageDouble = double(redImage);

%% Create ratio Image and add color map

ratioImage = greenImageDouble ./ redImageDouble;

% ratioImage_scaled = gray2ind(ratioImage,256);
% jetRGB = ind2rgb(ratioImage_scaled,jet(256));

finalRatioImage = ratioImage;
end