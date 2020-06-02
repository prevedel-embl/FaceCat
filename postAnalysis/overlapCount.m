function out = overlapCount(block, pattern)
%% Determine the number of same elements in block and pattern, gets similarity
    out = sum(block == pattern, 2);
end 