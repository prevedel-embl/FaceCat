function processMP4_1_concat(video_path, output_folder)
%     video_path = strcat('choose=', video_path);
%     system(strcat('ImageJ-win64 --headless -macro ./2020-04-07_extract_laser_pattern.ijm ', video_path, ' ', output_path), '-echo')
    %run headless fiji macro
    if ~exist('output_folder', 'var')
        output_folder = pwd;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET RUNTIME VARIABLES
    [pos_snout, pos_eye] = uiDrawRois(video_path)
% The csv_path needs to be set to the file of the grayscale value
% measurement of the mouse eye as provided by ImageJ
%    csv_path = 'Y:\members\Wiessalla\Code\Convert_Videos\M1_20200414_KLS-61899_File5\M1_20200414_KLS-61899_File5.csv';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Measure the grayscale value of the eye to determine laser activity
    grayValue = measureGrayValue(video_path, pos_eye);

    [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(grayValue);

    % batchNum means the number of the recording epoch within a video (i.e.
    % a laser on period)
    batchNum = 1;
    batchExtractHOG_concat(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
            batchNum, pos_snout);
        
end