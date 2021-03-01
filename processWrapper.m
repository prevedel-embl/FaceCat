function processWrapper(varargin)
    defaultNoDrop = false;
    parser = inputParser;
    validBool = @(x) islogical(x);
    validCell = @(x) iscell(x);
    addRequired(parser, 'fileNames', validCell);
    addParameter(parser, 'noDrop', defaultNoDrop, validBool);
    parse(parser, varargin{:});
    fileNames = parser.Results.fileNames;
    noDrop = parser.Results.noDrop;
    
    for i = 1:length(fileNames)
        video_path = fileNames{i};
        [pos_snout{i}, pos_eye{i}] = uiDrawRois(video_path);
    end
    for j = 1:length(fileNames)
        video_path = fileNames{j};
        % Measure the grayscale value of the eye to determine laser activity
        grayValue = measureGrayValue(video_path, pos_eye{j});
        % 
        if noDrop==true
            grayValue = ones(length(grayValue), 1);
        end
        [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(grayValue);

        % batchNum means the number of the recording epoch within a video (i.e.
        % a laser on period)
        batchNum = 1;
        savename = batchExtractHOG_concat(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
                batchNum, pos_snout{j});
        % Do the second analysis step immediately
        disp('Done with HOG analysis, now doing post analysis step optimizeMotE.');
        load(savename)
        [scor, classifiedFrames, noClusters, scorList, clusterList] = ...
            optimizeMotE(energy, links);
        save(strcat('optimizeMotE_', savename, '.mat'), '-v7.3')
        disp('Done with HOG analysis, now doing post analysis step tSNE.');
        completePostAnalysis(1.8, savename);
    end
end
        
    
