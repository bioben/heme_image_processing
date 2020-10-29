import java.util.Scanner;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/*
 * Folder Creator
 * This program is will take in a path that has several directories.
 * Each directory will then need a new folder within it
 */

class heme_image_processing_step0_folderSetup {
    public static void main(String[] args) throws Exception {
        //Find folders to each subfolder
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter project directory:");
        String projectDirectory = scan.nextLine();
        File projDirectory = new File(projectDirectory);
        File[] projDirectoryFolders = projDirectory.listFiles();

        //Get name of new folder to be added to each subfolder
        System.out.println("Enter name of subfolder:");
        String subfolderName = scan.nextLine();

        int count = 0;
        for (File brainCondition : projDirectoryFolders) {
            //Find path to each subfolder
            String brainConditionPath = projectDirectory + "/" + brainCondition.getName();
            System.out.println("Path: " + brainConditionPath);

            //Create folders to be placed in each subfolder
            String subfolderPath = brainConditionPath + "/" + subfolderName;
            File subFolder = new File(subfolderPath);
            subFolder.mkdir();
            System.out.println("Created: " + subfolderPath);
        }
    }
}
