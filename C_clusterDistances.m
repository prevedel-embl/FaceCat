function C_clusterDistances(output_folder)
%% Take the random and true distribution and use them to calculate a cut-off value and clusters, respectively
    boot_files = dir(strcat(output_folder, 'Avg*'));
    dist_files = dir(strcat(output_folder, 'Cos*'));
    boot_files = {boot_files.name};
    dist_files = {dist_files.name};

    for vidOutput=1:length(dist_files)
        boot = load(boot_files{vidOutput});
        dist = load(dist_files{vidOutput});
        dist = dist.cossim_hogs;
        [links, stereotypedFrames, minClusterNumber] = helperPost(cossim_hogs, avg_distance);
        save(strcat('stereotyped_frames_N#_', num2str(ceil(vidOutput/2)), '.mat'), ...
                    'stereo typedFrames')
    end
end