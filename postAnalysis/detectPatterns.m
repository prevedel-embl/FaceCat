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
    % Remove circular shifts/permutations of patterns
    allPatterns = removeDuplicatePatterns(allPatterns);
    % Optionally: calculate cutoff based on bootstrap rather than
    % specifying the minimum overlap
    if strcmp(minOverlap, 'boot')
        cutoff = bootDist(allPatterns);
        cutoff(3, :) = cutoff(2, :)/windowSize;
        minOverlap = cutoff(2, 1);
    end
    % Initialize structure to store the results
    patComp = struct('Pattern', {}, 'Assigned_Clusters', [], ...
        'Score', {}, 'Overlap_Locations', {}, 'distMat', [], ...
        'cutoff', []);
    distMat = patMat(allPatterns, windowSize);
    patComp(1).Assigned_Clusters = classifiedFrames;
    patComp(1).distMat = distMat;
    patComp(1).cutoff = array2table(cutoff', ...
        'VariableNames', {'Percent Cutoff', 'Corresponding Overlap in Frames', ...
        'Corresponding similarity'});
    % Convert classifiedFrames to a column vector
    if size(classifiedFrames, 2) == 1
        classifiedFrames = classifiedFrames';
    end
    % Expand classified frames, do all overlap comparisons with the
    % remaining patterns at once for every frame
    noPatterns = size(allPatterns, 1);
    noConvItr = size(classifiedFrames, 2) - windowSize + 1;
    classifiedFrames = repmat(classifiedFrames, noPatterns, 1);
    scoreMat = zeros(noPatterns, noConvItr);
    for i=1:noConvItr
        scoreMat(:,i) = overlapCount(classifiedFrames(:, i:i + (windowSize-1)), ...
                        allPatterns);
    end
    
    for k = 1:noPatterns
        itr_count = 0;
        patComp(k).Pattern = allPatterns(k,:);
        % Downsample ('distinct' == true) to align with Ca recording
        if strcmp(windowMode, 'distinct')
            patComp(k).Score = scoreMat(k, 1:windowSize:end);
        else
            patComp(k).Score = scoreMat(k, :);
        end
        patComp(k).Overlap_Locations = struct(('Overlaps'), {});
        for j=minOverlap:windowSize
            itr_count = itr_count + 1;
            tmpOverlapLoc = find(patComp(k).Score(:) == j);
            patComp(k).Overlap_Locations(itr_count).Overlaps = ...
                struct(strcat('MinOverlap', num2str(j)), tmpOverlapLoc);
        end
    end
    
    % Normalize to obtain score between 0 and 1
    patComp(1).Score = patComp(1).Score/windowSize;
    
end

function out = overlapCount(block, pattern)
    out = sum(block == pattern, 2);
end    

function distMat=patMat(allPatterns, windowSize)
    [rows, ~] = size(allPatterns);
    distMat = zeros([rows rows]);
    parfor i=1:rows
        d = bsxfun(@eq,allPatterns, allPatterns(i,:));  
        distMat(i,:) = sum(d,2)/windowSize;
    end
end

function cutoff = bootDist(allPatterns)
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
