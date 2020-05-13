function batchExtractHOG_par(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
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
    recordedFrames = [];
    for N=1:dataChunks
        tmp = laserSwitchOn_idcs(N):laserSwitchOff_idcs(N);
        recordedFrames = [recordedFrames tmp];
    end
    disp(strcat('Processing chunk ', num2str(N), ' out of_ ', num2str(dataChunks)));
    hog_ChunkN = [];
    for frame=1:length(recordedFrames)
        % read the frames and convert them into HOG vectors
            img = read(vidReader, frame);
            img = grayCrop(img, pos_snout);
            hog_vec = extractHOGFeatures(img, 'CellSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
            hog_ChunkN(end+1, :) = hog_vec;
    end
        cossim_hogs = pdist(hog_ChunkN, 'cosine');
        nIter = 10000;
        % Get the randomized distribution
        disp(strcat('Calculating bootstrap for chunk ', num2str(N)));
        avg_distance =  boot(vidReader, nIter, ...
                laserSwitchOn_idcs, laserSwitchOff_idcs, pos_snout);
        
        disp(strcat('Saving results for chunk ', num2str(N)));
        save(strcat('Cos2-dist_Vid#_', num2str(batchNum), '_N#_', num2str(N), '_', filename, '.mat'), 'cossim_hogs', '-v7.3');
        save(strcat('Avg_dist#_', num2str(batchNum), '_N#_', num2str(N), '_', filename, '.mat'), 'avg_distance', '-v7.3');
     %   clear cossim_hogs
end


