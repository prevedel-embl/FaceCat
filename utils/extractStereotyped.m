function stereotypedFrames = extractStereotyped(cossim_hogs, cutoff)
    links = linkage(cossim_hogs, 'average');
    stereotypedFrames = cluster(links, 'Cutoff', cutoff, 'Criterion', 'distance');
end