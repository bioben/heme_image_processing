/*
 * HEME IMAGE PROCESSING - STEP 2
 * @author Benjamin Ahn
 * @version 1.0 Oct 2020
 *
 * DESCRIPTION
 * This script runs in ImageJ, and uses the BaSiC correction method to correct the 
 * nonuniform illumination in horizontal image strips (created in Step1).
 * 
 * INPUT ARGUMENTS
 *   experiment_path - a string representing the path to the directory, which contains
 *                      the brain conditions
 * Note: BaSiC: https://www.nature.com/articles/ncomms14836, https://www.helmholtz-muenchen.de/icb/research/groups/quantitative-single-cell-dynamics/software/basic/index.html
 * Note: BisAla10 required 2 iterations of BaSiC. Look for the "NOTE:" comments in the code
 */

//INPUTS
experiment_path = "/media/benjamin/Windows/Users/Benja/Documents/Research/heme_imaging_ImageJ/demo/images_demo/imagesCondition1_demo";

// Get all the brain conditions. Each item in the list should be a folder that contains a folder ./hor 
brainConditionList = getFileList(experiment_path);

for (i = 0; i < brainConditionList.length; i++) {
	print(brainConditionList[i]);

	//build path and open image sequence
	//note that ./hor should contain the horizontal image strips created in Step1
	openPath = experiment_path + "/" + brainConditionList[i] + "/hor/"; //NOTE: CHANGE TO /hor_corrected/ FOR BISALA10 GROUP
	run("Image Sequence...", "select=[" + openPath + "] dir=[" + openPath + "] sort");

	//run BaSiC
	run("BaSiC ", 
		"processing_stack=hor " + //NOTE: CHANGE TO hor_corrected FOR BISALA10 GROUP
		"flat-field=None " +
		"dark-field=None " +
		"shading_estimation=[Estimate shading profiles] " +
		"shading_model=[Estimate both flat-field and dark-field] " +
		"setting_regularisationparametes=Automatic " +
		"temporal_drift=Ignore correction_options=[Compute shading and correct images] " +
		"lambda_flat=0.50 lambda_dark=0.50");

	//save corrected image sequence
	//note that ./hor_corrected should have been created in the folder setup Step0
	savePath = experiment_path + "/" + brainConditionList[i] + "/hor_corrected/"; 
	run("Image Sequence... ", "select=[" + savePath + "] dir=[" + savePath + "] format=TIFF use");
	close();
	close();
	close();
	close();

}

print("**********DONE**********");
