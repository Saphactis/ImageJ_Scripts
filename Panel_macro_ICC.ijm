
dir = "C:/Users/andre/Desktop/MS/RAW/d2+7 ND5/20220622T084547"
dir2 = "C:/Users/andre/Desktop/Test"
//getDirectory("input folder");
setBatchMode(true);
function create_montage(dir, dir2){
	counter = 0;
	channels = newArray("C01","C02","C03");
	colors = newArray("Blue", "Green","Magenta");
	baseChannel = channels[0];
	files = getFileList(dir);
	for (i=0; i<files.length; i++) {
		merged = false;
		if (endsWith(files[0], ".tif")) {
			//print(files[0]);
			if(startsWith(files[i], "A")|startsWith(files[i], "C")){
				first_marker = "MAP2";
				second_marker = "TAU";
			}
			else {
				first_marker = "KI67";
				second_marker = "B-3-Tubulin";
			}
			if (indexOf(files[i], baseChannel) != -1) {
				counter++;
				open(dir + "/" + files[i]);
				run(colors[0]);
				run("Enhance Contrast", "saturated=0.10");
				names = newArray(channels.length);
				names[0] = files[i];

				for (j=1; j<channels.length; j++) {
					 channel = replace(files[i], channels[0], channels[j]);
					 print(channel);
					 open(dir + "/" + channel);
					 names[j] = channel;
					 run(colors[j]);
					 if (colors[j] != "Green"){
						 run("Enhance Contrast", "saturated=0.05");
						 }
					}
					options = "";

				for (j=0; j<names.length;j++) {
					options = options + "c" + (j+1) + "=" + names[j] + " ";
					}

				options = options + "create";
				print(options);
				run("Merge Channels...", options);
				Stack.setDisplayMode("Composite");
				run("Stack to RGB");
				selectWindow("Composite");
				run("Split Channels");
				selectWindow("C1-Composite");
				rename("DAPI");
				selectWindow("C2-Composite");
				rename(first_marker);
				selectWindow("C3-Composite");
				rename(second_marker);
				selectWindow("Composite (RGB)");
				run("Flatten");
				rename("Merged");
				selectWindow("Composite (RGB)");
				close();
				run("Images to Stack");
				run("Make Montage...", "columns=4 rows=1 scale=0.25 label");
				selectWindow("Montage");
				file_name =dir2 +"/" + substring(files[i], 0, 4);
				saveAs( "Tiff", file_name);
				close("*");

			}
		}
	}
}
setBatchMode(false);
create_montage(dir, dir2)
