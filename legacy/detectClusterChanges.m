function amountOfChange = detectClusterChanges(stereotypedFrames)
%% Count how many cluster assignement changes occur within the 0.25 s window around each timepoint
    clusterChange = ischange(stereotypedFrames);
    window = ones(1, 15);
    amountOfChange = conv(clusterChange, window, 'same');
end

    
    