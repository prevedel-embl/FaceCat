function clusterEstimateWrapper()
    fileNames = {...
        '/Users/Tristan/Desktop/20200417_91898_concatAll.mp4' ...
      };
    for i = 1:length(fileNames)
        video_path = fileNames{i};
        [pos_snout{i}, pos_eye{i}] = uiDrawRois(video_path);
    end
    disp('snout position set');
    for j = 1:length(fileNames)
        video_path = fileNames{j};
        % Measure the grayscale value of the eye to determine laser activity
        grayValue = measureGrayValue(video_path, pos_eye{j});
        disp('Eye grayscale value measured');
        [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(grayValue);
        disp('Run cluster estimate function');
        [no_clusters, energy] = postClusterEstimate(video_path, laserSwitchOn_idcs, l    aserSwitchOff_idcs, ...
                pos_snout)        
    save(strcat(filename, '_cluster_estimate.m'), '-v7.3');
    end
end
