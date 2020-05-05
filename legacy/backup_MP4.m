function processMP4_1(video_path, output_path)
    video_path = strcat('choose=', video_path);
    system(strcat('ImageJ --headless -macro ./2020-04-07_extract_laser_pattern.ijm', video_path, ' ', output_path), '-echo')
    %run headless fiji macro
    [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(csv_path);

    for batchNum=1:length(laserSwitchOn_idcs)
        laserSwitchOn_idx = laserSwitchOn_idcs(batchNum);
        laserSwitchOff_idx = laserSwitchOff_idcs(batchNum);
        % batch extract should also do image registration if desired
        batchExtractHOG_par(video_path, laserSwitchOn_idx, laserSwitchOff_idx, batchNum);
    end
    
    cossim_files = dir(strcat(output_folder,'*.mat'));
    cossim_files = cossim_files.name;
    
    for vidOutput=1:length(cossim_files)
        stereotypedFrames = extractStereotyped(cossim_hogs, cutoff);
        save(strcat('stereotyped_frames_N#_', num2str(vidOutput), '.mat'), ...
                    'stereotypedFrames')
    end
end
