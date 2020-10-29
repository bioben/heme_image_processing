clear;clc;

%% CORRECTING NONUNIFORM ILLUMINATION IN TILED HISTOLOGY IMAGES - STEP 1
% author Benjamin Ahn
% version 1.0 Oct 2020
% 
% DESCRIPTION
% This script contains the paths to directories which contain the tile
% images. It will then pass the directory into a function that will build
% horizontal image strips and saves them to ./hor
%
% INPUT ARGUMENTS
%       rootFolderName - a string that represents the path to a directory
%       that contains the tile images, an emtpy ./hor folder, and an empty ./hor_corrected folder
%       horizontal - an integer that represents the number of tiles needed to construct a full horizontal row image
%       total_images - an integer that represents the total number of tile in an image
%

% Edit this so that it leads to ./heme_imaging_ImageJ/functions
addpath(genpath('/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/functions'));

for i = 1:4
    % Read in images
    
    % imageCondition1_demo **************************************************************************************
    if i == 1
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo/imagesCondition1_demo/imagesCondition1_channel1_demo';
        horizontal = 7;
        total_images = 98;
    end
    if i == 2
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo/imagesCondition1_demo/imagesCondition1_channel1_sensor_demo';
        horizontal = 6;
        total_images = 84;
    end
     if i == 3   
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo/imagesCondition1_demo/imagesCondition1_channel2_demo';
        horizontal = 7;
        total_images = 98;
     end
     if i == 4   
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo/imagesCondition1_demo/imagesCondition1_channel2_sensor_demo';
        horizontal = 6;
        total_images = 84;
     end

     % Add more conditions **************************************************************************************
%      if i == 5
%         rootFolderName = "";
%         horizontal = ;
%         total_images = ;
%     end
%     if i == 6
%         rootFolderName = "";
%         horizontal = ;
%         total_images = ;
%     end
%      if i == 7
%         rootFolderName = "";
%         horizontal = ;
%         total_images = ;
%      end
%      if i == 8   
%         rootFolderName = "";
%         horizontal = ;
%         total_images = ;
%      end
        
     % End of inputs **************************************************************************************
     
     disp('Running Step1 ImageJ Prep');
     heme_image_processing_step1_imageJPrep(rootFolderName, total_images, horizontal);
     
end

disp('Done - ImageJ Prep');
