function simMat=patMat(allPatterns, windowSize)
%% Create a similarity matrix comparing allPatterns
    [rows, ~] = size(allPatterns);
    simMat = zeros([rows rows]);
    parfor i=1:rows
        d = bsxfun(@eq,allPatterns, allPatterns(i,:));  
        simMat(i,:) = sum(d,2)/windowSize;
    end
end