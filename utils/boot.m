function avg_distance = boot(vidReader, nIter, ...
        laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX)
    avg_distance = zeros(nIter, 1);
    parfor i=1:nIter
        range_idcs = laserSwitchOn_idx:laserSwitchOff_idx;
        rand_idcs = range_idcs(randperm(numel(range_idcs), 2));
        rand_frame1 = read(vidReader, rand_idcs(1));
        rand_frame2 = read(vidReader, rand_idcs(2));
        rand_frame1 = grayCrop(rand_frame1, cropRangeY, cropRangeX);
        rand_frame2 = grayCrop(rand_frame2, cropRangeY, cropRangeX);
      
        rand_hog_vec1 = extractHOGFeatures(rand_frame1, 'BlockSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
        rand_hog_vec2 = extractHOGFeatures(rand_frame2, 'BlockSize', [32 32], 'NumBins', 8, ...
            'BlockSize', [1 1]);
        rand_hog_Chunk = [rand_hog_vec1; rand_hog_vec2];
        avg_distance(i) = pdist(rand_hog_Chunk, 'cosine');
    end
end

