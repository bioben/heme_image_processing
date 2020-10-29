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
%                                             ./BisAla0
%                                                 ./noSensor488
%                                                     ./tileimage1
%                                                     ./tileimage2...
%                                                     ./tileimageN
%                                                 ./sensor488
%                                                 ./noSensor555
%                                                 ./sensor555
%                                              ./BisAla10
%                                              ./HS1 0
%                                              ./HS1 10
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

experimentPath = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images';
savePath = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/finalImages2';

%% PRELIMINARY 

% Add path to Step3, Step4, Step5, Step6 and associated functions
addpath(genpath('/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/functions'));

% Get all brain conditions ie. BisAla 0, BisAla 10, HS1 0, HS1 10
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
    
    noSensor488 = step3Map(1);
    sensor488 = step3Map(3);
    noSensor555 = step3Map(2);
    sensor555 = step3Map(4);

    [backgroundsubtracted488, noSensorRegistered488] = heme_image_processing_step4_coregisterBackgroundsubtract(noSensor488, sensor488);
    step4Map('backgroundsubtracted488') = backgroundsubtracted488;
    disp('Step 4 - finished 488 image');

    [backgroundsubtracted555, noSensorRegistered555] = heme_image_processing_step4_coregisterBackgroundsubtract(noSensor555, sensor555);
    step4Map('backgroundusbtracted555') = backgroundsubtracted555;
    disp('Step 4 - finished 555 image');
    
    workflowImageMap('step4') = step4Map;

    % Create figures - coregistration 488
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - coregister - ' brainCondition ' 488']);
    subplot(1, 3, 1);
    imshow(imadjust(noSensor488));
    title('non-sensor image');
    subplot(1, 3, 2);
    imshowpair(noSensorRegistered488, sensor488);
    title('co-registration');
    subplot(1, 3, 3);
    imshow(imadjust(sensor488));
    title('sensor image');
    saveas(expanded, [savePath '/' brainCondition '_step4_coregister488.tif']);

    % Create figures - coregistration 555
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - coregister - ' brainCondition ' 555']);
    subplot(1, 3, 1);
    imshow(imadjust(noSensor555));
    title('non-sensor image');
    subplot(1, 3, 2);
    imshowpair(noSensorRegistered555, sensor555);
    title('co-registration');
    subplot(1, 3, 3);
    imshow(imadjust(sensor555));
    title('sensor image');
    saveas(expanded, [savePath '/' brainCondition '_step4_coregister555.tif']);

    % Create figures - background subtraction 488 & 555
    expanded = figure('Position', get(0, 'Screensize'));
    sgtitle(['Step 4 - subtract background - ' brainCondition]);
    subplot(1, 2, 1);
    imshow(imadjust(backgroundsubtracted488));
    title('488 image');
    subplot(1, 2, 2);
    imshow(imadjust(backgroundsubtracted555));
    title('555 image');
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
workflow_BisAla0 = bigMap('imagesBisAla0');
workflow_BisAla10 = bigMap('imagesBisAla10');
workflow_HS10 = bigMap('imagesHS10');
workflow_HS110 = bigMap('imagesHS110');

ratioImage_BisAla0 = workflow_BisAla0('step5');
ratioImage_BisAla10 = workflow_BisAla10('step5');
ratioImage_HS10 = workflow_HS10('step5');
ratioImage_HS110 = workflow_HS110('step5');

greyImage_BisAla0 = workflow_BisAla0('step3');
greyImage_BisAla10 = workflow_BisAla10('step3');
greyImage_HS10 = workflow_HS10('step3');
greyImage_HS110 = workflow_HS110('step3');

% Final Ratio Images
expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Ratio Images (488/555) and color map');
subplot(1, 4, 1);
imshow(ratioImage_BisAla0);
title('BisAla 0uM');
caxis([minOverall, maxOverall]);
colormap(jet);

subplot(1, 4, 2);
imshow(ratioImage_BisAla10);
title('BisAla 10uM');
caxis([minOverall, maxOverall]);
colormap(jet);

subplot(1, 4, 3);
imshow(rot90(ratioImage_HS10));
title('HS1 0uM');
caxis([minOverall, maxOverall]);
colormap(jet);

subplot(1, 4, 4);
imshow(ratioImage_HS110);
title('HS1 10uM');
caxis([minOverall, maxOverall]);
colormap(jet);

saveas(expanded, [savePath '/' 'allRatioImages.jpg']);

% Build figures - grey scale image and ratio map juxtaposed
expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Step 5 & 6 - ratio image (488/555) and color map - BisAla 0uM');
subplot(1, 2, 1);
imshow(ratioImage_BisAla0);
title('ratio image');
caxis([minOverall, maxOverall]);
colormap(jet);
subplot(1, 2, 2);
imshow(imadjust(greyImage_BisAla0(2)));
title('grey image');
saveas(expanded, [savePath '/' 'imagesBisAla0_step5_6_ratio_colormap.tif']);

expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Step 5 & 6 - ratio image (488/555) and color map - BisAla 10uM');
subplot(1, 2, 1);
imshow(ratioImage_BisAla10);
title('ratio image');
caxis([minOverall, maxOverall]);
colormap(jet);
subplot(1, 2, 2);
imshow(imadjust(greyImage_BisAla10(2)));
title('grey image');
saveas(expanded, [savePath '/' 'imagesBisAla10_step5_6_ratio_colormap.tif']);

expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Step 5 & 6 - ratio image (488/555) and color map - HS1 0uM');
subplot(1, 2, 1);
imshow(ratioImage_HS10);
title('ratio image');
caxis([minOverall, maxOverall]);
colormap(jet);
subplot(1, 2, 2);
imshow(imadjust(greyImage_HS10(2)));
title('grey image');
saveas(expanded, [savePath '/' 'imagesHS10_step5_6_ratio_colormap.tif']);


expanded = figure('Position', get(0, 'Screensize'));
sgtitle('Step 5 & 6 - ratio image (488/555) and color map - HS1 10uM');
subplot(1, 2, 1);
imshow(ratioImage_HS110);
title('ratio image');
caxis([minOverall, maxOverall]);
colormap(jet);
subplot(1, 2, 2);
imshow(imadjust(greyImage_HS110(2)));
title('grey image');
saveas(expanded, [savePath '/' 'imagesHS110_step5_6_ratio_colormap.tif']);

%% Save Images
expanded = figure('Position', get(0, 'Screensize'));
imshow(ratioImage_BisAla0);
caxis([minOverall, maxOverall]);
colormap(jet);
saveas(expanded, [savePath '/' 'imagesBisAla0_finalRatioImage.tif']);

expanded = figure('Position', get(0, 'Screensize'));
imshow(ratioImage_BisAla10);
caxis([minOverall, maxOverall]);
colormap(jet);
saveas(expanded, [savePath '/' 'imagesBisAla10_finalRatioImage.tif']);

expanded = figure('Position', get(0, 'Screensize'));
imshow(ratioImage_HS10);
caxis([minOverall, maxOverall]);
colormap(jet);
saveas(expanded, [savePath '/' 'imagesHS10_finalRatioImage.tif']);

expanded = figure('Position', get(0, 'Screensize'));
imshow(ratioImage_HS110);
caxis([minOverall, maxOverall]);
colormap(jet);
saveas(expanded, [savePath '/' 'imagesHS110_finalRatioImage.tif']);

%% Save the workspace
%bigMap
save([savePath '/bigMap.mat'], bigMap);

%% END
    

