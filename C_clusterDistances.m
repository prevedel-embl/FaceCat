function C_clusterDistances(output_folder)
cossim_files = dir(strcat(output_folder,'/*.mat'));
[~, idx] = sort([cossim_files.datenum]);
cossim_files = cossim_files(idx);
cossim_files = {cossim_files.name};

for vidOutput=1:2:length(cossim_files)
    boot = load(cossim_files{vidOutput});
    dist = load(cossim_files{vidOutput + 1});
    dist = dist.cossim_hogs;
    cutoff = quantile(boot.avg_distance, 0.95);
    stereotypedFrames = extractStereotyped(dist, cutoff);
    save(strcat('stereotyped_frames_N#_', num2str(ceil(vidOutput/2)), '.mat'), ...
                'stereo typedFrames')
end