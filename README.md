# HEME IMAGE PROCESSING 
@ author Benjamin Ahn  
@ version 1.0 Sept 2020 - Oct 2020  
This project aims to develop a computational pipeline in MATLAB and ImageJ that  
* Corrects nonuniform microscopic illumination 
* Stitches tile images
* Applies a background correction method
* Builds a ratio image    
Scripts and the pipeline are programmed by Benjamin Ahn 

### Technologies
MATLAB  
ImageJ  
Java  

### Launch
MATLAB scripts can be opened in the MATLAB environment  
ImageJ script can be launched using FIJI  

### Table of Contents
* Background  
* Running the Workflow
* Step 0: Folder Setup (Java)  
* Step 1: ImageJ Prep (MATLAB)
* Step 2: BaSiC Correction (ImageJ)
* Step 3: Full Stitch (MATLAB)
* Step 4: Co-registration and Background Subtraction (MATLAB)
* Step 5: Ratio Image (MATLAB)
* Step 6: Color Map (MATLAB)
* Outputs
* Demo
* Credits

### Background
Tiled histology images are stacks of images that when stitched together, create a full image. The images contain uneven lighting from the microscope, creating image abberations on the edges of each tile. When stitched together, each tile could be distinguished when in reality, the stitched image should be one, smooth image. Once smoothed, the images can be co-registered, subtracted from each other (background subtraction), then combined to build a ratio image. 

### Running the Workflow
The user should run the Java program under Step 0 first. The user should next run the 'heme_runscript_ImageJ_prep.m' script which runs Step 1. The user should next run the ImageJ script under Step 2. The user should next run the 'heme_runscript_ImageJ.m' script which runs Step 4, 5, 6.  
The workflow takes approximately 20 minutes per image condition. 

### Step 0 Folder Setup
Folders should be organized as following  
./images  
&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_488  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_488_nosensor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_555  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_555_nosensor  
&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition2  
&nbsp;&nbsp;&nbsp;&nbsp;./brainConditionN  

The FolderSetup is a Java Program which can be run off the terminal. This program takes in the path to a directory, takes each subfolder within that path, and adds a subfolder with a user-input name.  

It will ask you to "Enter project directory" which should be /path/to/images/brainCondition. It will then ask you to "Enter name of subfolder" which should be "hor". This program should be then run again, but using "hor_corrected" for the subfolder. 
The ./functions directory should be added to all run scripts 
Tiled images should be organized such that all tiles are named in numerical order.  

The folders should be organized as follows  
./images  
&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_488  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor_corrected  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_488_nosensor 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor_corrected   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_555  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor_corrected  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition1_555_nosensor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./hor_corrected  
&nbsp;&nbsp;&nbsp;&nbsp;./brainCondition2  
&nbsp;&nbsp;&nbsp;&nbsp;./brainConditionN  

Additionally, a folder should be made to save the final images. The user should make this folder themselves. The heme_runscript_ImageJ.m will ask for the path to this save folder.  

### heme_runscript_ImageJ_Prep
This script contains the paths to ./brainCondition directories which should contain ./hor (empty), ./hor_corrected (empty), and tile images. This will then execute the step1 function.  

### Step 1: ImageJ Prep (MATLAB)
The function will stitch the tiles into horizontal strips and save them to the ./hor folder

### Step 2: BaSiC Correction (ImageJ)
This will take the horizontal image strips created from Step 1 and apply the BaSiC plug-in. It uses the method from https://www.nature.com/articles/ncomms14836, https://www.helmholtz-muenchen.de/icb/research/groups/quantitative-single-cell-dynamics/software/basic/index.html which estimates the flat-field and dark-field, then applies a correction method. The corrected horizontal images are then saved in ./hor_corrected folder.  

### heme_runscript_ImageJ
This script executes the following other functions. It additionally builds images and figures that show the workflow for each step. It also contains a manual method to set the limits for the color map in Step6.  

### Step 3: Full Stitch (MATLAB)
The function takes the corrected horizontal image strips (saved in ./hor_corrected) and stitches them together to build a full image.  

### Step 4: Co-registration and Background Subtraction (MATLAB)
The function takes two matrices that represent corrected, fully stitched images developed from step 3. Note that these two images should be of the same sample, one with the heme sensor and one without, on the same channel. The function applies an optimized co-registration algorithm such that the nonsensor image is aligned to the sensor image. The nonsensor image is then subtracted from the sensor image, pixel for pixel, creating a background subtracted image.  
Note: make sure that the correct images from step 3 are being used in step 4. Look at the 'heme_image_processing_ImageJ.m' script.  
  
The co-registration processes uses co-registration methods from MATLAB: https://www.mathworks.com/help/images/registering-multimodal-mri-images.html   

### Step 5: Ratio Image (MATLAB)
The function takes two matrices that represent co-registered, background subtracted images. Note that these two images should be of the same sample, one of the 555 channel and one of the 488 channel. The 488 image will be divided by the 555 image creating a ratio image.  

### Step 6: Color Map (MATLAB)
The function takes a hashmap of the ratio images and finds the min/max values across all images. It will then use those values to apply a color map to those images. Note that the color limits for the color map can be manually adjusted in the heme_runscript_ImageJ.m script. With the min and max values, the same color limits can be applied to all ratio images, thus creating a universal color map. 

### Outputs
* allRatioImages.jpg: all ratio images with universal color map
* finalRatioImage: the individual ratio image with universal color map
* step4_backgroundsubtract.jpg: 488 & 555 images that represent the sensor minus nonsensor images
* step4_coregister: nonsensor and sensor image (from Step3), and the two images overlapped
* step5_6_ratio_colormap: individual ratio image with universal color map and juxtaposed grey scale image  

### Demo
The demo has an example set of images for a single condition with the proper folder hierarchy. 

### Credits
@author Benjamin Ahn  
BaSiC Method: https://www.nature.com/articles/ncomms14836  