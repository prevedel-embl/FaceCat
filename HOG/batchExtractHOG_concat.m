function batchExtractHOG_concat(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
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
    % Concatenate the indices of all frames during which the Ca recording
    % laser is on
    recordedFrames = [];
    for N=1:dataChunks
        tmp = laserSwitchOn_idcs(N):laserSwitchOff_idcs(N);
        recordedFrames = [recordedFrames tmp];
    end
    disp(strcat('Processing chunk ', num2str(N), ' out of_ ', num2str(dataChunks)));
    hog_ChunkN = single.empty;
    for frame=1:length(recordedFrames)
        % read the frames and convert them into HOG vectors
            img = read(vidReader, recordedFrames(frame));
            img = grayCrop(img, pos_snout);
            hog_vec = extractHOGFeatures(img, 'CellSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
            hog_ChunkN(end+1, :) = hog_vec;
    end
    try
        cossim_hogs = pdist(hog_ChunkN, 'cosine');
        links = linkage(cossim_hogs, 'average');
    catch 
        disp('No distance calculation');
        save(strcat('Output_', filename, '.mat'), '-v7.3', 'hog_ChunkN');
    end
        disp(strcat('Saving results for chunk ', num2str(N)));
        save(strcat('Output_', filename, '.mat'), '-v7.3', 'hog_ChunkN', ...
                    'cossim_hogs', 'links');
        disp('saved');
       

end


