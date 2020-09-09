function [no_clusters, energy] = postClusterEstimate(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, ...
             pos_snout)
    dataChunks = length(laserSwitchOn_idcs);
    % Concatenate the indices of all frames during which the Ca recording
    % laser is on
    recordedFrames = [];
    for N=1:dataChunks
        tmp = laserSwitchOn_idcs(N):laserSwitchOff_idcs(N);
        recordedFrames = [recordedFrames tmp];
    end
    energy = single.empty;
    % this should be set earlier and higher-level in the code
    no_sd = 2;
    for frame=1:length(recordedFrames)
        % read the frames and convert them into HOG vectors
            img = read(vidReader, recordedFrames(frame));
            img = grayCrop(img, pos_snout);
            img2 = read(vidReader, recordedFrames(frame + 1));
            img2 = grayCrop(img2, pos_snout);
            % This was added 2020-09-08: Alternative way to determine the number of clusters
            % present in the data, inspired by Musall et al 2019
            energy(:, :, end+1) = next - current;
    end
    eng_mean = mean(energy(:));  
    no_clusters = clusterEstimate(eng_mean, no_sd);
end
