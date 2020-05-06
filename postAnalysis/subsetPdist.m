function subsetDistMat = subsetPdist(framesStart, framesEnd, len, distMat)
%% Extract subset from a distance matrix, using the original indices and the total number of comparisons underlying the matrix
    subsetDistMat = [];
    segmentLen = framesEnd - framesStart;
    for i = 1:segmentLen
        if i == 1
            lowerIndex = framesStart;
            higherIndex = framesEnd - 1;
        else
            lowerIndex = higherIndex + len - segmentLen;
            higherIndex = lowerIndex + segmentLen - i;
        end
        subsetDistMat = [subsetDistMat, distMat(lowerIndex:higherIndex)];
    end
    subsetDistMat = squareform(subsetDistMat);
end