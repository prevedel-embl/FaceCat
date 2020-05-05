function amountOfChange = detectClusterChangesStep(stereotypedFrames)
%% Count how many cluster assignement changes occur within the 15 frame window at every 15th timepoint
    clusterChange = ischange(stereotypedFrames);
    amountOfChange = blockproc(clusterChange, [15 1], @replaceByBlockSum);
end

% The function handle for the blockproc method
function out = replaceByBlockSum(block)
    out = sum(block.data(:));
%     out = ones(block.blockSize)*sum(block.data(:));
end

