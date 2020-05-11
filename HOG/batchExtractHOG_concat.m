function batchExtractHOG_par(video_path, laserSwitchOn_idx, laserSwitchOff_idx, ...
            batchNum, pos_snout)
    vidReader = VideoReader(video_path);
    % Extract File Name, for savename generation
    try
        filename = regexp(video_path, '[/\\](\w+)\.', 'tokens');
        filename = filename{1}{1};
    catch
        disp('Remove any special characters from the file name');
        keyboard
    end
    dataChunks = length(laserSwitchOn_idcs);
    % Load only these chunks of 2GB size into memory, one at a time
    for N=1:number_dataChunks
        disp(strcat('Processing chunk ', num2str(N), ' out of_ ', num2str(number_dataChunks)));
        frameRangeLO = laserSwitchOn_idcs(N);
        frameRangeHI = laserSwitchOff_idcs(N);
        if frameRangeHI > numFrames
            frameRangeHI = numFrames;
        end
        
        hog_ChunkN = [];
        frame = frameRangeLO;
        % read the frames and convert them into HOG vectors
        for frame = frameRangeLO:frameRangeHI
            img = read(vidReader, frame);
            img = grayCrop(img, pos_snout);
            hog_vec = extractHOGFeatures(img, 'CellSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
            hog_ChunkN(end+1, :) = hog_vec;
        end
    end
        cossim_hogs = pdist(hog_ChunkN, 'cosine');
        nIter = 10000;
        % Get the randomized distribution
        disp(strcat('Calculating bootstrap for chunk ', num2str(N)));
        avg_distance =  boot(vidReader, nIter, ...
                laserSwitchOn_idx, laserSwitchOff_idx, pos_snout);
        
        disp(strcat('Saving results for chunk ', num2str(N)));
        save(strcat('Cos2-dist_Vid#_', num2str(batchNum), '_N#_', num2str(N), '_', filename, '.mat'), 'cossim_hogs', '-v7.3');
        save(strcat('Avg_dist#_', num2str(batchNum), '_N#_', num2str(N), '_', filename, '.mat'), 'avg_distance', '-v7.3');
     %   clear cossim_hogs
    end
end


