function patComp = detectPatterns(stereotypedFrames, windowSize, minOverlap)
%% Find repeating sequences, output their number and location
    if minOverlap > windowSize
        error('minOverlap cannot be bigger than windowSize');
    end
    allPatterns = im2col(stereotypedFrames, [windowSize 1], 'sliding')';
    % Remove duplicate patterns to improve speed of the convolution
    allPatterns = unique(allPatterns, 'rows', 'stable');
    patComp = struct('Score', {}, 'Overlap_Locations', {}, 'Count', {});
    % Analyze every singular pattern individually
    for i=1:size(allPatterns,1)
        pattern = allPatterns(i, :);  
        tmp = colfilt(stereotypedFrames, [windowSize 1], 'sliding', @(x) overlapCount(x, pattern'));
        % Normalize to obtain score between 0 and 1
        patComp(i).Score = tmp(:,1)/windowSize;
        patComp(i).Overlap_Locations = struct(('Overlaps'), {});
        itr_count = 0;
        for j=windowSize:-1:minOverlap+1
            itr_count = itr_count + 1;
            tmpOverlapLoc = find(tmp(:,1) == j);
            patComp(i).Overlap_Locations(itr_count).Overlaps = struct(strcat('MinOverlap', num2str(j)), tmpOverlapLoc);
            patComp(i).Count(itr_count).Counts = struct(strcat('MinOverlap', num2str(j)),length(find(tmp(:,1) == windowSize)));
        end
    end

end

function out = overlapCount(block, pattern)
    out = sum(block == pattern);
end    
