
function completePostAnalysis(sigma)
    % list of all locations of hog_ChunkN
    paths = {    ...
    'Y:\members\Wiessalla\Code\Convert_Videos\post20200417\Output20200417_618086_concatAll.mat', ...
    'Y:\members\Wiessalla\Code\Convert_Videos\post20200417\Output20200417_91897_ConcatAll.mat' ...
    };
    if isempty(paths)
         disp('Create a cell array "paths" cotaining the full paths of the data to be analyzed');
         keyboard
    end
    % 1) If not done yet, perform the primary HOG analysis on the corresponding
    % videos
    % processWrapper(paths);

    % 2) Perform all post analysis steps and store the results in the same
    % directory as the data
    for i = 1:length(paths)
        path = paths{i};
        try
            load(path, 'hog_ChunkN', 'links')
        catch
            disp('Adjust file name, path not found');
            keyboard
        end
        % Extract experiment ID
        [filepath,name,ext] = fileparts(path);
        % generate tSNE mapped 2D representation of the HOGs
        tSNEmap = tsne(hog_ChunkN);
        [~, ~, boundaries, watershed_map] = watershedClustering(tSNEmap, ...
                                                    sigma);
        % Length of boundaries is the number of clusters detected
        noClusters = length(boundaries);
        classifiedFrames = cluster(links, 'maxclust', noClusters);

        % Generate output for both options, consecutive and sliding window
        % analysis of the cluster patterns
        windowSizes =  [15 30 45 60];
        for j=1:length(windowSizes)
            windowSize = windowSizes(j);
            [patComp] = detectPatterns(classifiedFrames, 'windowSize', windowSize, ...
                        'minOverlap', 'boot', 'windowMode', 'distinct');

            save(strcat(filepath, '\', name, num2str(noClusters), '_window_', ...
                num2str(windowSize), '_distinct_.mat'), 'patComp', 'watershed_map', ...
                'boundaries', '-v7.3')

            [patComp] = detectPatterns(classifiedFrames, 'windowSize', windowSize, ...
                        'minOverlap', 'boot', 'windowMode', 'sliding');

            save(strcat(filepath, '\', name, num2str(noClusters), '_window_', ...
                num2str(windowSize), '_sliding_.mat'), 'patComp', '-v7.3')
        end
    end
end