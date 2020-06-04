function processWrapper(fileNames)
%     fileNames = {...
%         'Y:\members\Boffi\data\M1\20200417\KLS-91898\Concat_analysis\20200417-91898_concatAll.mp4' ...
%       };
    
    for i = 1:length(fileNames)
        video_path = fileNames{i};
        [pos_snout{i}, pos_eye{i}] = uiDrawRois(video_path);
    end
    for j = 1:length(fileNames)
        video_path = fileNames{j};
        % Measure the grayscale value of the eye to determine laser activity
        grayValue = measureGrayValue(video_path, pos_eye{j});

        [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(grayValue);

        % batchNum means the number of the recording epoch within a video (i.e.
        % a laser on period)
        batchNum = 1;
        batchExtractHOG_concat(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
                batchNum, pos_snout{j});
    end
end
        
    