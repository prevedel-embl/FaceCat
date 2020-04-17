function stereotypedFrames = thresholdDuration(stereotypedFrames)
    % Modify stereotyped Frames: if the sequential number of frames is
    % shorter than 60 frames (i.e. 1 sec) exclude it from subsequent
    % analysis
    numClusters = unique(stereotypedFrames);
    % Iterate through every cluster number
    for cluster=1:length(numClusters)
        workCopy = stereotypedFrames;
        % De-select all other cluster numbers
        workCopy(workCopy ~= cluster) = 0;
        workCopy = logical(workCopy);
        clusterLocations = regionprops(workCopy, 'PixelIdxList');
        clusterLocations = struct2cell(clusterLocations);
        for cell=1:length(clusterLocations(1))
            if length(clusterLocations(cell)) < 60
                stereotypedFrames(clusterLocations{cell}) = nan;
            end
        end
    end
end
    