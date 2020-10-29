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

addpath(genpath('/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/functions'));

for i = 1:16
    disp(i);
    % Read in images
    
    % BisAla 0uM **************************************************************************************
    if i == 1
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/BisAla 0uM heme_brain1_488';
        horizontal = 7;
        total_images = 98;
    end
    if i == 2
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/BisAla 0uM heme_sensor_brain1_488';
        horizontal = 6;
        total_images = 84;
    end
     if i == 3   
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/BisAla 0uM heme_brain1_555';
        horizontal = 7;
        total_images = 98;
     end
     if i == 4   
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/BisAla 0uM heme_sensor_brain1_555';
        horizontal = 6;
        total_images = 84;
     end

     % BisAla 10uM **************************************************************************************
     if i == 5
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesBisAla10/BisAla 10uM heme_brain1_488';
        horizontal = 10;
        total_images = 120;
    end
    if i == 6
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesBisAla10/BisAla 10uM heme_sensor_brain1_488';
        horizontal = 10;
        total_images = 110;
    end
     if i == 7
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesBisAla10/BisAla 10uM heme_brain1_555';
        horizontal = 10;
        total_images = 120;
     end
     if i == 8   
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesBisAla10/BisAla 10uM heme_sensor_brain1_555';
        horizontal = 10;
        total_images = 110;
     end
     
     % HS1 0uM **************************************************************************************
     if i == 9
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesHS10/HS1 0uM heme_brain2_488';
        horizontal = 13;
        total_images = 78;
    end
    if i == 10
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesHS10/HS1 0uM heme_sensor_brain2_488';
        horizontal = 12;
        total_images = 72;
    end
     if i == 11  
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesHS10/HS1 0uM heme_brain2_555';
        horizontal = 13;
        total_images = 78;
     end
     if i == 12  
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/imagesHS10/HS1 0uM heme_sensor_brain2_555';
        horizontal = 12;
        total_images = 72;
     end
     
     % HS1 10uM **************************************************************************************
     if i == 13
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/imagesHS110/HS1 10uM heme_brain2_488';
        horizontal = 6;
        total_images = 72;
    end
    if i == 14
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/imagesHS110/HS1 10uM heme_sensor_brain2_488';
        horizontal = 8;
        total_images = 112;
    end
     if i == 15
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/imagesHS110/HS1 10uM heme_brain2_555';
        horizontal = 6;
        total_images = 72;
     end
     if i == 16 
        rootFolderName = '/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/images/imagesHS110/HS1 10uM heme_sensor_brain2_555';
        horizontal = 8;
        total_images = 112;
     end

     % End of inputs **************************************************************************************
     
     heme_image_processing_step1_imageJPrep(rootFolderName, total_images, horizontal);
     
end