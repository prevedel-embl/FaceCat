function randForest(batchNum, vidReader, ...
        laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX)
    %% Train a random forest classifier
    load(strcat('stereotyped_frames_N#_', num2str(batchNum), '.mat'));
    % Load uninitialized variables
    if ~exist('vidReader', 'var')
        csv_path = 'WIN_20200403_14_10_07_Pro.csv';
        video_path='Y:/members/Wiessalla/Data/Data_raw/20200403/KLS-61896/WIN_20200403_14_10_07_Pro.mp4';   
        [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(csv_path);
        cropRangeY = 88:472;
        cropRangeX = 752:1026;
        laserSwitchOn_idx = laserSwitchOn_idcs(batchNum);
        laserSwitchOff_idx = laserSwitchOff_idcs(batchNum);
        vidReader = VideoReader(video_path);
    end
    range_idx = laserSwitchOn_idx:laserSwitchOff_idx;
    nIter = ceil(0.15*numel(range_idx));
    % Randomly select 15% of the frames within the recording epoch
    rand_idcs = range_idx(randperm(numel(range_idx), nIter));    
    % Initialize array to store the HOG vectors resulting from these frames
    rand_hog = []; 
    for i=1:nIter
        rand_frameIter = read(vidReader, rand_idcs(nIter));
        rand_frameIter = grayCrop(rand_frameIter, cropRangeY, cropRangeX);      
        rand_hog_vecIter = extractHOGFeatures(rand_frameIter, 'BlockSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
        rand_hog(nIter, :)  = rand_hog_vecIter;
    end
    % Train the classifier
    predictor = fitctree(rand_hog, stereotypedFrames(rand_idcs-laserSwitchOn_idx), 'MaxNumCategories', length(unique(stereotypedFrames)));
    save(strcat('trained_predictor_batch#_', num2str(batchNum), '.mat'), 'predictor', 'rand_idcs')
    
end