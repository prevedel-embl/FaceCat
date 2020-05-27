function [patComp, distMat] = detectPatterns(classifiedFrames, varargin)
%% Find all sequential patterns of length windowSize in classifiedFrames, store their count and index locations
% Set default input values and parse input arguments
    defaultWindowSize = 15;
    defaultWindowMode = 'distinct';
    expectedWindowMode = {'distinct', 'sliding'};
    defaultMinOverlap = 'boot';
    
    
    parser = inputParser;
    validVector = @(x) isnumeric(x) && size(x, 2) == 1;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    validMinOverlap = @(x) isnumeric(x) && isscalar(x) || strcmp(x, 'boot');
    addRequired(parser, 'classifiedFrames', validVector);
    addParameter(parser, 'windowSize', defaultWindowSize, ...
                 validScalarPosNum);
    addParameter(parser, 'minOverlap', defaultMinOverlap, ...
                 validMinOverlap);
    addParameter(parser, 'windowMode', defaultWindowMode, ...
                 @(x) any(validatestring(x,expectedWindowMode)));
    parse(parser, classifiedFrames, varargin{:});
    
    classifiedFrames = parser.Results.classifiedFrames;
    minOverlap = parser.Results.minOverlap;
    windowSize = parser.Results.windowSize;
    windowMode = parser.Results.windowMode;
%% Find repeating sequences, output their number and location
    if isnumeric(minOverlap) && minOverlap > windowSize
        error('minOverlap cannot be bigger than windowSize');
    end
    
    % Extract all possible patterns given the windowMode constraint
    if strcmp(windowMode, 'distinct')
        allPatterns = im2col(classifiedFrames, [windowSize 1], 'distinct')';
    else
        allPatterns = im2col(classifiedFrames, [windowSize 1], 'sliding')';
    end
    
    % Remove duplicate patterns to improve speed of the convolution
    allPatterns = unique(allPatterns, 'rows', 'stable');
    % Optionally: calculate cutoff based on bootstrap rather than
    % specifying the minimum overlap
    if strcmp(minOverlap, 'boot')
        cutoff = bootDist(allPatterns);
        cutoff(3, :) = cutoff(2, :)/windowSize;
        minOverlap = cutoff(2, 1);
    end
    % Initialize structure to store the results
    patComp = struct('Score', {}, 'Overlap_Locations', {}, 'Count', {}, ...
        'distMat', [], 'cutoff', []);
    distMat = patMat(allPatterns, windowSize);
    patComp(1).distMat = distMat;
    patComp(1).cutoff = array2table(cutoff', ...
        'VariableNames', {'Percent_Cutoff', 'Corresponding_Overlap_in_Frames', ...
        'Corresponding_similarity'});
    
    % Analyze every singular pattern individually
    for i=1:size(allPatterns,1)
        pattern = allPatterns(i, :);  
        tmp = colfilt(classifiedFrames, [windowSize 1], [windowSize 1], ...
            'sliding', @(x) overlapCount(x, pattern'));
        % Normalize to obtain score between 0 and 1
        % Downsample ('distinct' == true) to align with Ca recording
        if windowMode == 'distinct'
            patComp(i).Score = tmp(1:windowSize:end,1)/windowSize;
        else
            patComp(i).Score = tmp(:,1)/windowSize;
        end
        patComp(i).Overlap_Locations = struct(('Overlaps'), {});
        
        itr_count = 0;
        for j=minOverlap:windowSize
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

function distMat=patMat(allPatterns, windowSize)
    [rows, ~] = size(allPatterns);
    distMat = zeros([rows rows]);
    for i=1:rows
        d = bsxfun(@eq,allPatterns, allPatterns(i,:));
        distMat(i,:) = sum(d,2)/windowSize;
    end
end

function cutoff = bootDist(allPatterns)
    bootMat = zeros(10000, 1);
    for i=1:10000
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