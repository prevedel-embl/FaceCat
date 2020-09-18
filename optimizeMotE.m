function [score, classifiedFrames] = optimizeMotE(energy, varargin)
%% Find a cutoff value for the linkage of the HOG vectors that corresponds to the motion Energy calculated for the ROI.

% Initialize values, find the threshold for the motion energy
    defaultNoClusters = 130;

    parser = inputParser;
    validNoClusters = @(x) isnumeric(x) && isscalar(x);
    validVector = @(x) isnumeric(x) && size(x, 2) == 1;
    validLinkage = @(x) isnumeric(x) && size(x, 2) == 3;
    addRequired(parser, 'energy', validVector);
    addRequired(parser, 'links', validLinkage);
    addParameter(parser, 'noClusters', defaultNoClusters, ...
                 validNoClusters);
    parse(parser, energy, varargin{:});
    
    mu = mean(energy(:));
    sig = std(energy(:));
    threshold = mu + 2*sig;
        
% Create the logical vector indicating significant motion energy at each
% frame
    bin_motE = energy > threshold;

    % Terminate either when the optimatl solution is found or if further
    % iterations don't change the outcome
    while score ~= length(energy) || noClusters ~= noClustersOld
        classifiedFrames = cluster(links, 'maxclust', noClusters);
        % Find the logical motion Energy of the classifiedFrames
        clusterMotE = ischange(classifiedFrames);
        % Ideally both logical energy descriptions should match
        score = sum(clusterMotE == bin_motE);
        noClustersOld = noClusters;
        % Update noClusters to iteratively get cluser to
        if length(find(clusterMotE == 1)) => length(find(bin_MotE))
            noClusters = floor(noClustersOld/2);
        else
            noClusters = floor(noClustersOld*1.5);
        end
    end
end