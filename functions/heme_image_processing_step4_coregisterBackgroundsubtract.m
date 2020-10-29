%% Notes
%https://www.mathworks.com/help/images/registering-multimodal-mri-images.html

function [backgroundSubtractedImage, noSensorImageRegisteredOptimized] = heme_image_processing_step4_coregisterBackgroundsubtract(noSensorImage, sensorImage)
%% CORRECTING NONUNIFORM ILLUMINATION IN TILED HISTOLOGY IMAGES - STEP 4
% author Benjamin Ahn
% version 1.0 Sept 2020
%
% DESCRIPTION
% Raw, illumination-corrected, fully stitched images should have been made
% and stored as a full matrix in step 3. 
% 
% Step 4: two images, a non-sensor and a sensor, are taken in and
% co-registered. The non-sensor image is then subtracted from the sensor
% image, creating a single matrix that represents a background-subtracted
% image. 
%
% INPUT ARGUMENTS
%       noSensorImage - a 2D matrix of a raw, illumination-corrected, stitched image built in step 3
%       sensorImage - a 2D matrix of a raw, illumination-corrected, stitched image built in step 3
%     
% OUTPUTS
%       backgroundSubtractedImage - a 2D matrix of a the sensorImage minus the noSensorImage after co-registration
%       noSensorImageRegisteredOptimized - the noSensor image that has been shifted so that it overlaps with the sensor image
%
%% Load images

noSensorImage = noSensorImage;
sensorImage = sensorImage;

%% Get parameters for MATLAB co-registration functions
[optimizer,metric] = imregconfig('multimodal');

%% Adjust default parameters
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
optimizer.MaximumIterations = 300; 

%% Co-register images
noSensorImageRegisteredOptimized = imregister(noSensorImage, sensorImage, 'affine', optimizer, metric);

%% Subtract out background
noSensorImageBackgroundSubtracted = sensorImage - noSensorImageRegisteredOptimized;
backgroundSubtractedImage = noSensorImageBackgroundSubtracted;

end