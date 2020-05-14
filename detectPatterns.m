function patComp = detectPatterns(stereotypedFrames, windowSize)
    for i=1:length(stereotypedFrames)-windowSize
        allPatterns(i, :) = stereotypedFrames(i:i+windowSize - 1, 1);
    end
    % Remove duplicate patterns to improve speed of the convolution
    allPatterns = unique(allPatterns, 'rows', 'stable');
    patComp = struct('Score', {}, 'Overlap_Locations', {}, 'Count', {});
    for i=1:size(allPatterns,1)
        pattern = allPatterns(i, :);  
        tmp = colfilt(stereotypedFrames, [15 1], 'sliding', @(x) overlapCount(x, pattern'));
        patComp(i).Score = tmp(:,1);
        patComp(i).Overlap_Locations = find(tmp(:,1) == 15);
        patComp(i).Count = length(find(tmp(:,1) == 15));
    end

end

function out = overlapCount(block, pattern)
    out = sum(block == pattern);
end    
