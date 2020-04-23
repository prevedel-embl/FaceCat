function stereotypedFrames = extractStereotyped(cossim_hogs, cutoff)
%% Assign a cluster number to every stillframe of the video
    links = linkage(cossim_hogs, 'average');
    stereotypedFrames = cluster(links, 'Cutoff', cutoff, 'Criterion', 'distance');   
end