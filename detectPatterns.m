function patComp = detectPatterns(stereotypedFrames, windowSize)
%% Find repeating sequences, output their number and location
    allPatterns = zeros(length(stereotypedFrames), windowSize);
    for i=1:length(stereotypedFrames)-windowSize
        allPatterns(i, :) = stereotypedFrames(i:i+windowSize - 1, 1);
    end
    % Remove duplicate patterns to improve speed of the convolution
    allPatterns = unique(allPatterns, 'rows', 'stable');
    patComp = struct('Score', {}, 'Overlap_Locations', {}, 'Count', {});
    % Analyze every singular pattern individually
    for i=1:size(allPatterns,1)
        pattern = allPatterns(i, :);  
        tmp = colfilt(stereotypedFrames, [windowSize 1], 'sliding', @(x) overlapCount(x, pattern'));
        % Normalize to obtain score between 0 and 1
        patComp(i).Score = tmp(:,1)/windowSize;
        patComp(i).Overlap_Locations = find(tmp(:,1) == windowSize);
        patComp(i).Count = length(find(tmp(:,1) == windowSize));
    end

end

function out = overlapCount(block, pattern)
    out = sum(block == pattern);
end    
