function processMP4_1(video_path, output_folder)
%     video_path = strcat('choose=', video_path);
%     system(strcat('ImageJ-win64 --headless -macro ./2020-04-07_extract_laser_pattern.ijm ', video_path, ' ', output_path), '-echo')
    %run headless fiji macro
    if ~exist('output_folder', 'var')
        output_folder = pwd;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET RUNTIME VARIABLES
    cropRangeY = 83:464;
    cropRangeX = 297:548;
% The csv_path needs to be set to the file of the grayscale value
% measurement of the mouse eye as provided by ImageJ
    csv_path = 'Y:\members\Wiessalla\Code\Convert_Videos\M1_20200414_KLS-61899_File5\M1_20200414_KLS-61899_File5.csv';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(csv_path);

    % batchNum means the number of the recording epoch within a video (i.e.
    % a laser on period)
    for batchNum=1:length(laserSwitchOn_idcs)
        laserSwitchOn_idx = laserSwitchOn_idcs(batchNum);
        laserSwitchOff_idx = laserSwitchOff_idcs(batchNum);
        % batch extract should also do image registration if desired
        batchExtractHOG_par(video_path, laserSwitchOn_idx, laserSwitchOff_idx, ...
            batchNum, cropRangeY, cropRangeX);
    end
    
    C_clusterDistances(output_folder);

%     predictor = randForest(vidReader, nIter, ...
%         laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX);
end