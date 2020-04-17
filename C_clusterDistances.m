function C_clusterDistances(output_folder)
boot_files = dir(strcat(output_folder, 'Avg*'));
dist_files = dir(strcat(output_folder, 'Cos*'));
boot_files = {boot_files.name};
dist_files = {dist_files.name};

for vidOutput=1:length(dist_files)
    boot = load(boot_files{vidOutput});
    dist = load(dist_files{vidOutput});
    dist = dist.cossim_hogs;
    cutoff = quantile(boot.avg_distance, 0.95);
    stereotypedFrames = extractStereotyped(dist, cutoff);
    save(strcat('stereotyped_frames_N#_', num2str(ceil(vidOutput/2)), '.mat'), ...
                'stereo typedFrames')
end