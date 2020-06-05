function [patComp] = detectPatterns(classifiedFrames, varargin)
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
    % Extend array for frequency alignment
    frameRate = 60;
    caRate = 3.91;
    precision = 3;
    [ratio, classifiedFrames] = alignSamplingRates(classifiedFrames, ...
                frameRate, caRate, precision);
    windowSize = windowSize*10^precision;
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
    % Downsample ('distinct' == true) to align with Ca recording
    % Normalize to obtain score between 0 and 1
    if strcmp(windowMode, 'distinct')
        scoreMatConv = scoreMat(:, 1:windowSize:end)/windowSize;
        classifiedFramesConv = classifiedFrames(1, 1:windowSize:end);
    else
        scoreMatConv = scoreMat/windowSize;
        classifiedFramesConv = classifiedFrames;
    end
    % Initialize structure to store the results
    patComp = struct('Pattern', num2cell(allPatterns, 2), ...
        'Score', num2cell(scoreMatConv, 2));
    simMat = patMat(allPatterns, windowSize);
    patComp(1).Assigned_Clusters = classifiedFramesConv(1, :);
    patComp(1).simMat = simMat;
    patComp(1).cutoff = array2table(cutoff', ...
        'VariableNames', {'Percent Cutoff', 'Corresponding Overlap in Frames', ...
        'Corresponding similarity'});
    % Store the locations for the varying degrees of overlap
    scoreMat = scoreMat(:, 1:windowSize:end);
    parfor k = 1:noPatterns
        itr_count = 0;
        patComp(k).Overlap_Locations = struct(('Overlaps'), {});
        for j=minOverlap:windowSize
            itr_count = itr_count + 1;
            tmpOverlapLoc = find(scoreMat(k,:) == j);
            patComp(k).Overlap_Locations(itr_count).Overlaps = ...
                struct(strcat('MinOverlap', num2str(j)), tmpOverlapLoc);
        end
   end
end






