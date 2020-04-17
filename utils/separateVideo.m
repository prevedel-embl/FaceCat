function [number_dataChunks, numFrames] = separateVideo(vidReader, size_dataChunks, ...
                                laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX)
        frame1 = read(vidReader, 1);
        frame1 = grayCrop(frame1, cropRangeY, cropRangeX);
        hog_vec = extractHOGFeatures(frame1, 'BlockSize', [32 32], 'NumBins', 8, ...
                            'BlockSize', [1 1]);
        hog1_byteSize = whos('hog_vec').bytes;
        numFrames = length(laserSwitchOn_idx:laserSwitchOff_idx);
        estimated_byteSize = numFrames*hog1_byteSize;
        number_dataChunks = ceil(estimated_byteSize/size_dataChunks);
end