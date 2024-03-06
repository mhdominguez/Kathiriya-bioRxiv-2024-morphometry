var directionality_method="Fourier components";
//var directionality_method="Local gradient orientation";

macro "Automatically adjust images and assess directionality by Directionality..." {
	//get directory to put .roi files
	while( 1 ) {
	directory = getDirectory("Choose load directory for TIF files");
	fileList = getFileList(directory);
	
	//declare expandable arrays
	process_file_list = newArray(0);
	master_final_list = newArray(0);
	
	for (i=0; i<fileList.length; i++) {
		if (endsWith(fileList[i], ".tif")) {
			process_file_list = Array.concat(process_file_list, fileList[i] );
		}
	}
	
	for (i=0; i<process_file_list.length; i++) {
		//open each image and allow user to 
		open(directory + File.separator() + process_file_list[i]);
		rand_num = floor(random() * 1000000 );
		origstack = "Image" + d2s(rand_num,0);
		rename( origstack );		
		
		getDimensions(dim_width, dim_height, dim_channels, dim_slices, dim_frames);
		channelList = newArray(0);
		
		if ( dim_channels > 1 ) {
			run("Split Channels");
			for (b=1; b<=dim_channels; b++ ) {
				channelList = Array.concat( channelList, "C" + IJ.pad(b,1) + "-" + origstack ); 
			}
		} else if ( dim_channels == 1 ) {
			channelList = Array.concat( channelList, origstack );
		} else {
			continue; //skip this series altogether	
		}
		
		//now give user time to make changes to the intensity curve to maximize good directional hits on Fourier components analysis
		/*run("Brightness/Contrast...");
		Dialog.createNonBlocking("Please manually adjust brightness/contrast...");
		Dialog.addMessage("Please prepare images for directionality assessment before clicking OK.") 
		Dialog.show();*/
		
		for (b=0; b<channelList.length; b++ ) {
			selectWindow(channelList[b]);
			//run("Median...", "radius=2");
			//run("Subtract Background...", "rolling=5 sliding");
			run("Subtract Background...", "rolling=200");
			run("Subtract Background...", "rolling=20");
			//run("Median...", "radius=2");
			run("Enhance Contrast...", "saturated=0.01 normalize" );
			run("8-bit");
			saveAs("Tiff", directory + File.separator() + channelList[b] + ".tif" );
			master_final_list = Array.concat(master_final_list, channelList[b] );
			close();
		}
		close("*");
	}
	
	//now, re-open all images and run directionality
	for (i=0; i<master_final_list.length; i++) {
		//open each image and run directionality
		open(directory + File.separator() + master_final_list[i] + ".tif");
		newstack = getTitle();
		
		//Directionality plugin (included with Fiji)
		run("Directionality", "method=["+directionality_method+"] nbins=181 histogram_start=-90 histogram_end=90 build display_table");
		selectWindow("Directionality histograms for " + master_final_list[i] + " (using "+directionality_method+")");
		saveAs("Results", directory + File.separator() + master_final_list[i] + ".csv");
		close(master_final_list[i] + ".csv");
		selectWindow("Orientation map for " + master_final_list[i] );
		saveAs("Tiff", directory + File.separator() + master_final_list[i] + "_orientation_map" + ".tif" );
		selectWindow(master_final_list[i] + ".tif");
		close();
		close("*");
	}

	}
}

macro "Automatically adjust images and assess directionality by OrientationJ..." {
	//get directory to put .roi files
	while( 1 ) {
	directory = getDirectory("Choose load directory for TIF files");
	fileList = getFileList(directory);
	
	//declare expandable arrays
	process_file_list = newArray(0);
	master_final_list = newArray(0);
	
	for (i=0; i<fileList.length; i++) {
		if (endsWith(fileList[i], ".tif")) {
			process_file_list = Array.concat(process_file_list, fileList[i] );
		}
	}
	
	for (i=0; i<process_file_list.length; i++) {
		//open each image and allow user to 
		open(directory + File.separator() + process_file_list[i]);
		rand_num = floor(random() * 1000000 );
		origstack = "Image" + d2s(rand_num,0);
		rename( origstack );		
		
		getDimensions(dim_width, dim_height, dim_channels, dim_slices, dim_frames);
		channelList = newArray(0);
		
		if ( dim_channels > 1 ) {
			run("Split Channels");
			for (b=1; b<=dim_channels; b++ ) {
				channelList = Array.concat( channelList, "C" + IJ.pad(b,1) + "-" + origstack ); 
			}
		} else if ( dim_channels == 1 ) {
			channelList = Array.concat( channelList, origstack );
		} else {
			continue; //skip this series altogether	
		}
		
		//now give user time to make changes to the intensity curve to maximize good directional hits on Fourier components analysis
		/*run("Brightness/Contrast...");
		Dialog.createNonBlocking("Please manually adjust brightness/contrast...");
		Dialog.addMessage("Please prepare images for directionality assessment before clicking OK.") 
		Dialog.show();*/
		
		for (b=0; b<channelList.length; b++ ) {
			selectWindow(channelList[b]);
			//run("Median...", "radius=2");
			//run("Subtract Background...", "rolling=5 sliding");
			run("Subtract Background...", "rolling=200");
			run("Subtract Background...", "rolling=20");
			//run("Median...", "radius=2");
			run("Enhance Contrast...", "saturated=0.01 normalize" );
			run("8-bit");
			saveAs("Tiff", directory + File.separator() + channelList[b] + ".tif" );
			master_final_list = Array.concat(master_final_list, channelList[b] );
			close();
		}
		close("*");
	}
	
	//now, re-open all images and run directionality
	for (i=0; i<master_final_list.length; i++) {
		//open each image and run directionality
		open(directory + File.separator() + master_final_list[i] + ".tif");
		newstack = getTitle();
		
		//Orientation J
		//run("OrientationJ Distribution", "tensor=10.0 gradient=0 radian=off histogram=off table=on min-coherency=0 min-energy=5.0 ");
		run("OrientationJ Distribution", "tensor=25 gradient=3 radian=off histogram=off table=on min-coherency=0 min-energy=10 ");
		selectWindow("OJ-Distribution-1");
		saveAs("Results", directory + File.separator() + master_final_list[i] + ".csv");
		if ( isOpen("OJ-Distribution-1") )
			close("OJ-Distribution-1");
		if ( isOpen(directory + File.separator() + master_final_list[i] + ".csv") )
			close(directory + File.separator() + master_final_list[i] + ".csv");		
		selectWindow(newstack);
		run("OrientationJ Dominant Direction", "tensor=25 gradient=3 radian=off histogram=off table=on min-coherency=0 min-energy=10 ");
		selectWindow("Dominant Direction of " + master_final_list[i] + ".tif");
		saveAs("Results", directory + File.separator() + master_final_list[i] + "_dd.csv");
		if ( isOpen("Dominant Direction of " + master_final_list[i] + ".tif") )
			close("Dominant Direction of " + master_final_list[i] + ".tif");
		if ( isOpen(directory + File.separator() + master_final_list[i] + "_dd.csv") )
			close(directory + File.separator() + master_final_list[i] + "_dd.csv");		
		selectWindow(newstack);
		close();
		close("*");
	}

	}
}





/*

open("/media/martin/Dominguez-Bk/Irfan/E14.5 hearts for Irfan Figure/New 7/heart 1 mut/Directionality/Posterior Basal IVS/1.tif");
run("Directionality", "method=[Fourier components] nbins=90 histogram_start=-90 histogram_end=90 build display_table");

run("Save");
saveAs("Tiff", "/media/martin/Dominguez-Bk/Irfan/E14.5 hearts for Irfan Figure/New 7/heart 1 mut/Directionality/Posterior Basal IVS/Orientation map for 1.tif");
close();
run("Tiff...");
selectWindow("1.tif");
close();
run("Tiff...");
run("Selection...");
open("/media/martin/Dominguez-Bk/Irfan/E14.5 hearts for Irfan Figure/New 7/heart 1 mut/Directionality/Posterior Basal IVS/5.tif");
run("Directionality", "method=[Fourier components] nbins=90 histogram_start=-90 histogram_end=90 build display_table");
run("Close All");




 
if (isOpen("Directionality analysis for 4(using Fourier components)")) {
	print( "open" );
	selectWindow("Directionality analysis for 4(using Fourier components)");
         run("Close" );
}*/
//selectWindow("Directionality histograms for 4 (using Fourier components)");
//run("Close" );
//selectWindow("Directionality for 4 (using Fourier components)");
//run("Close" );


//"Orientation map for 4"
//"Directionality histograms for 4 (using Fourier components)"
