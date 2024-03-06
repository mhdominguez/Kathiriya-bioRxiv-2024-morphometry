 macro "Draw ROIs, Quantify, Decrement Stack..." {
	 //get directory to put .roi files
	 directory = getDirectory("Choose save directory for ROI files");
	 
	 //start us off
	Stack.getPosition(channel, slice, frame);
	
	while( slice > 1 ) {

		//user has to draw ROIs here
		Dialog.createNonBlocking("Draw ROIs");
		Dialog.addMessage("Draw your ROIs on this frame now.  Press OK to label and quantify them.") 
		Dialog.show();
		
		//start by renaming ROIs
		roi_count = roiManager("count");
		if ( roi_count == 0 ) {
			roiManager("add")
			roi_count = roiManager("count");
		}
		
		Stack.getPosition(channel, slice, frame);
		
		Dialog.create("Enter ROI names...");
		//roi_names = newArray(roi_count);
		for ( cc=0; cc<roi_count; cc++ ) {
			roiManager("Select", cc);
			Dialog.create("Rename ROI " + d2s(cc,0) + ": " + Roi.getName() );
			Dialog.addString("New name:","");
			Dialog.show();
			roiManager("rename", Dialog.getString());
			//this_name = Dialog.getString();
			//Roi.setName(this_name);
		}
		
		//now, rename and measure
		for ( cc=0; cc<roi_count; cc++ ) {
			roiManager("Select", cc);
			base_name = Roi.getName();
		
			for ( ch=1; ch<4; ch++ ) { //measure three channels from 1:3
				Stack.setChannel(ch);
				roiManager("rename", base_name + "_" + d2s(ch,0));
				roiManager("Measure");
			}
			roiManager("rename", base_name ); //put back basename for save
		}
		
		//save ROIs for possible future use
		roiManager("save", directory + File.separator() + "quant_roi_z" + d2s(slice,0) + ".zip" );
		
		//backpedal one frame, remove ROIs
		if ( slice >= 1 ) {
			Stack.setPosition(channel, slice-1, frame);
		}		
		roiManager("Deselect");
		roiManager("Delete");
		
	}
}

 macro "Quantify Stack with Pre-drawn ROIs..." {
	 //get directory to put .roi files
	 directory = getDirectory("Choose load directory for ROI files");
	 
	//start us off
	getDimensions(dim_width, dim_height, dim_channels, dim_slices, dim_frames);
	Stack.setPosition(1, dim_slices, 1);
	Stack.getPosition(channel, slice, frame);

	while( slice > 1) {

		Stack.getPosition(channel, slice, frame);
		
		//open ROIs for this slice
		this_slice_roi_file = directory + File.separator() + "quant_roi_z" + d2s(slice,0) + ".zip";
		if (!File.exists(this_slice_roi_file) ) {
			Stack.setPosition(channel, slice-1, frame);
			continue;
		}
		roiManager("open", this_slice_roi_file );
		
		//start by renaming ROIs
		roi_count = roiManager("count");
		if ( roi_count == 0 ) {
			Stack.setPosition(channel, slice-1, frame);
			continue;
		}
		
		//now, rename and measure
		for ( cc=0; cc<roi_count; cc++ ) {
			roiManager("Select", cc);
			base_name = Roi.getName();
		
			for ( ch=1; ch<4; ch++ ) { //measure three channels from 1:3
				Stack.setChannel(ch);
				roiManager("rename", base_name + "_" + d2s(ch,0));
				roiManager("Measure");
			}
			roiManager("rename", base_name ); //put back basename for save
		}
		
		//backpedal one frame, remove ROIs
		roiManager("Deselect");
		roiManager("Delete");
		if ( slice >= 1 ) {
			//slice--;
			Stack.setPosition(channel, slice-1, frame);
		}			
	}
}

macro "Update Selection in ROI Manager [u]" {
	roiManager("Update");
}

var global_open_directory = "";
macro "Open saved ROIs in Manager [6]" {
	if ( global_open_directory == "" ) {
		global_open_directory = getDirectory("Choose load directory for ROI files");
	}
	Stack.getPosition(channel, slice, frame);
	roiManager("open",global_open_directory + File.separator() + "quant_roi_z" + d2s(slice,0) + ".zip");
}
