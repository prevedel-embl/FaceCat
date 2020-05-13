function avg_distance = boot(vidReader, nIter, ...
        laserSwitchOn_idx, laserSwitchOff_idx, pos_crop)
%% Create a random sample distribution by measuring the cosine distance between two randomly selected vecotrs n times
    if length(laserSwitchOn_idx) > 1
        dataChunks = length(laserSwitchOn_idcs);
        % Load only these chunks of 2GB size into memory, one at a time
        recordedFrames = [];
        for N=1:dataChunks
            tmp = laserSwitchOn_idcs(N):laserSwitchOff_idcs(N);
            recordedFrames(end+1,:) = tmp;
        end
    else
        recordedFrames = laserSwitchOn_idx:laserSwitchOff_idx;
    end
    
    avg_distance = zeros(nIter, 1);
    parfor i=1:nIter
        range_idcs = recordedFrames;
        rand_idcs = range_idcs(randperm(numel(range_idcs), 2));
        rand_frame1 = read(vidReader, rand_idcs(1));
        rand_frame2 = read(vidReader, rand_idcs(2));
        rand_frame1 = grayCrop(rand_frame1, pos_crop);
        rand_frame2 = grayCrop(rand_frame2, pos_crop);
      
        rand_hog_vec1 = extractHOGFeatures(rand_frame1, 'CellSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
        rand_hog_vec2 = extractHOGFeatures(rand_frame2, 'CellSize', [32 32], 'NumBins', 8, ...
            'BlockSize', [1 1]);
        
        rand_hog_Chunk = [rand_hog_vec1; rand_hog_vec2];
        avg_distance(i) = pdist(rand_hog_Chunk, 'cosine');
    end
end

