clear;clc;

%% CORRECTING NONUNIFORM ILLUMINATION IN TILED HISTOLOGY IMAGES - RUN SCRIPT
% author Benjamin Ahn
% version 1.0 Oct 2020
%
% DESCRIPTION
% This script is the run script which executes the final steps in
% nonuniform illumination correction and stitching (Step3), coregistration
% and background subtraction (Step4), ratio calculation (Step5), and
% coloration (Step6)
%
% INPUT ARGUMENTS
%       experimentPath - a string representing the path to a folder of
%                                   images
%                               Example: experimentPath = '/folder/to/images'
%                                        ./images
%                                             ./Condition1
%                                                 ./noSensor488
%                                                     ./tileimage1
%                                                     ./tileimage2...
%                                                     ./tileimageN
%                                                 ./sensor488
%                                                 ./noSensor555
%                                                 ./sensor555
%                                              ./Condition2
%                                              ./Condition3...
%                                              ./ConditionN
%
%       savePath - a string representing the path to a folder that will save the workflow & final images
%
% OUTPUTS
%         allRatioImages.jpg - all ratio images with universal color map
%         finalRatioImage - the individual ratio image with universal color map
%         step4_backgroundsubtract.jpg - 488 & 555 images that represent the sensor minus nonsensor images
%         step4_coregister - nonsensor and sensor image (from Step3), and the two images overlapped
%         step5_6_ratio_colormap - individual ratio image with universal color map and juxtaposed grey scale image  
%

%% INPUTS 

experimentPath = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo';
savePath = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/finalImages_demo';

%% PRELIMINARY 

% Add path to Step3, Step4, Step5, Step6 and associated functions
addpath(genpath('/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/functions'));

% Get all brain conditions ie. Condition1
brainConditionLists = dir(experimentPath);
brainConditionLists(1:2) = [];

% This will hold all the workflowImageMap's
bigMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

disp('Preliminary complete');

for i = 1:length(brainConditionLists)
    %% PRELIMINARY FOR EACH BRAIN CONDITION
    
    % This will hold all the workflow images. Will be accessed later
    workflowImageMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % Access a single brain condition and build the path
    % ie. '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/imagesBisAla0'
    pathBrainCondition = [brainConditionLists(i).folder '/' brainConditionLists(i).name];
    sensorSet = dir(pathBrainCondition);
    sensorSet(1:2) = [];
    brainCondition = brainConditionLists(i).name;
    
    %% STEP 3 - FINISH NONUNIFORM ILLUMINATION CORRECTION & STITCH IMAGES

    % Build Map which will store fully stitched images
    step3Map = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    
    % Parse through the sensor and nonsensor images for a single brain
    % condition
    for j = 1: length(sensorSet)

        % Build path to image tiles that have been corrected in Step2
        pathToFolderName = [sensorSet(j).folder '/' sensorSet(j).name '/hor_corrected'];

        % Stitch
        fullImage = heme_image_processing_step3_fullStitch(pathToFolderName);

        % Save stitched image to Map
        step3Map(j) = fullImage;
        
    end
    
    workflowImageMap('step3') = step3Map;
    
    disp('Step 3 complete');

    %% STEP4 - COREGISTER IMAGES & SUBTRACT BACKGROUND
    
    % Build Map which will store backgroundsubtrcted images
    step4Map = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % Note: ensure that the correct images are being used
    noSensor488 = step3Map(1);
    sensor488 = step3Map(2);
    noSensor555 = step3Map(3);
    sensor555 = step3Map(4);

    [backgroundsubtracted488, noSensorRegistered488] = heme_image_processing_step4_coregisterBackgroundsubtract(noSensor488, sensor488);
    step4Map('backgroundsubtracted488') = backgroundsubtracted488;
    disp('Step 4 - finished channel1 image');

    [backgroundsubtracted555, noSensorRegistered555] = heme_image_processing_step4_coregisterBackgroundsubtract(noSensor555, sensor555);
    step4Map('backgroundusbtracted555') = backgroundsubtracted555;
    disp('Step 4 - finished channel2 image');
    
    workflowImageMap('step4') = step4Map;

    % Create figures - coregistration 488
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - coregister - ' brainCondition ' channel1']);
    subplot(1, 3, 1);
    imshow(imadjust(noSensor488));
    title('non-sensor image');
    subplot(1, 3, 2);
    imshowpair(noSensorRegistered488, sensor488);
    title('co-registration');
    subplot(1, 3, 3);
    imshow(imadjust(sensor488));
    title('sensor image');
    saveas(expanded, [savePath '/' brainCondition '_step4_coregisterChannel1.tif']);

    % Create figures - coregistration 555
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - coregister - ' brainCondition ' channel2']);
    subplot(1, 3, 1);
    imshow(imadjust(noSensor555));
    title('non-sensor image');
    subplot(1, 3, 2);
    imshowpair(noSensorRegistered555, sensor555);
    title('co-registration');
    subplot(1, 3, 3);
    imshow(imadjust(sensor555));
    title('sensor image');
    saveas(expanded, [savePath '/' brainCondition '_step4_coregisterChannel2.tif']);

    % Create figures - background subtraction 488 & 555
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - subtract background - ' brainCondition]);
    subplot(1, 2, 1);
    imshow(imadjust(backgroundsubtracted488));
    title('Channel1 image');
    subplot(1, 2, 2);
    imshow(imadjust(backgroundsubtracted555));
    title('Channel2 image');
    saveas(expanded, [savePath '/' brainCondition '_step4_backgroundsubtract.tif']);

    disp('Step 4 - complete');

    %% STEP 5 - CREATE RATIO IMAGE
    
    ratioImage_555_488 = heme_image_processing_step5_ratioImage(backgroundsubtracted488, backgroundsubtracted555);

    workflowImageMap('step5') = ratioImage_555_488;
    
    % Save workflow
    bigMap(brainCondition) = workflowImageMap;
end


%% STEP 6 - APPLY UNIVERSAL COLORMAP

% Option1 - find the limits across all ratio images
%[minOverall, maxOverall] = nonuniform_illumination_step6_colormap(imageArray);

% Option2 - can also adjust color limits manually
maxOverall = 4;
minOverall = 0;

% Build figures - all ratio final images together
workflow_Condition1 = bigMap('imagesCondition1_demo');
ratioImage_Condition1 = workflow_Condition1('step5');

greyImage_Condition1 = workflow_Condition1('step3');

% Final Ratio Images
expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Ratio Images (Channel1/Channel2) and color map');
imshow(ratioImage_Condition1);
title('Condition1 Demo');
caxis([minOverall, maxOverall]);
colormap(jet);

saveas(expanded, [savePath '/' 'RatioImages.jpg']);

% Build figures - grey scale image and ratio map juxtaposed
expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Step 5 & 6 - ratio image (Channel1/Channel2) and color map - Condition1 Demo');
subplot(1, 2, 1);
imshow(ratioImage_Condition1);
title('ratio image');
caxis([minOverall, maxOverall]);
colormap(jet);
subplot(1, 2, 2);
imshow(imadjust(greyImage_Condition1(2)));
title('grey image');
saveas(expanded, [savePath '/' 'imagesCondition1Demo_step5_6_ratio_colormap.tif']);

%% Save Images
expanded = figure('Position', get(0, 'Screensize'));
imshow(ratioImage_Condition1);
caxis([minOverall, maxOverall]);
colormap(jet);
saveas(expanded, [savePath '/' 'imagesCondition1Demo_finalRatioImage.tif']);

%% END
    

