function cutoff = bootDist(allPatterns)
%% Caculate a cutoff value based on a bootstrap of allPatterns
    bootMat = zeros(10000, 1);
    parfor i=1:10000
        randIdcs = randi(size(allPatterns, 1), [1 2]);
        randPat1 = allPatterns(randIdcs(1), :);
        randPat2 = allPatterns(randIdcs(2), :);
        bootMat(i, 1) = overlapCount(randPat1, randPat2);
    end
    percent = [0.50 0.60 0.70 0.80 0.85 0.90 0.95 0.99];
    cutoff = zeros(3, length(percent));
    cutoff(1, :) = percent;
    for idx=1:length(percent)
        cutoff(2, idx) = quantile(bootMat, percent(idx));
    end
end