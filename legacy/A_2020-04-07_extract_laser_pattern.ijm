args = split(getArgument(), " ");
vidFile = args[0]
outFile = args[1]
print("Running batch analysis with file:" +vidFile)
print("Save location is: " +outFile)
run("Movie (FFMPEG)...", "choose="+vidFile+" use_virtual_stack first_frame=0 last_frame=-1");
setTool("oval");
makeOval(693, 180, 27, 21);
run("ROI Manager...");
roiManager("Add");
run("Set Measurements...", "mean redirect=None decimal=3");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", "+outFile");
