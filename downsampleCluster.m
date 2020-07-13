function [idcs, classifiedFrames] = downsampleCluster(classifiedFrames, outLen)
    idcs = linspace(1, length(classifiedFrames), outLen);
    idcs = round(idcs);
    classifiedFrames = classifiedFrames(idcs);
end