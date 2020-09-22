function [scor, classifiedFrames, noClusters] = optimizeMotE(energy, varargin)
%% Find a cutoff value for the linkage of the HOG vectors that corresponds to the motion Energy calculated for the ROI.

% Initialize values, find the threshold for the motion energy
    defaultNoClusters = 130;

    parser = inputParser;
    validNoClusters = @(x) isnumeric(x) && isscalar(x);
    validVector = @(x) isnumeric(x) && size(x, 1) == 1;
%     validLinkage = @(x) isnumeric(x) && size(x, 2) == 3;
    addRequired(parser, 'energy', validVector);
    addRequired(parser, 'links');
    addParameter(parser, 'noClusters', defaultNoClusters, ...
                 validNoClusters);
    parse(parser, energy, varargin{:});
    
    energy = parser.Results.energy;
    links = parser.Results.links;
    noClusters = parser.Results.noClusters;

% Mean plus 2 sd is used to determine threshold for significant energy
% between frames
    mu = mean(energy(:));
    sig = std(energy(:));
    threshold = mu + 2*sig;
        
% Create the logical vector indicating significant motion energy at each
% frame
    bin_motE = energy > threshold;
    scor = 0;
    noClustersOld = NaN;
   
    % Terminate either when the optimatl solution is found or if further
    % iterations don't change the outcome
    while scor ~= length(energy) & noClusters ~= noClustersOld
        classifiedFrames = cluster(links, 'maxclust', noClusters);
        % Find the logical motion Energy of the classifiedFrames
        clusterMotE = diff(classifiedFrames);
        clusterMotE > 0 = 1;
        % Ideally both logical energy descriptions should match
        tmp = clusterMotE == bin_motE;
        scor = sum(tmp);
        noClustersOld = noClusters;
        % Update noClusters to iteratively get closer to
        if length(find(clusterMotE == 1)) > length(find(bin_motE == 1))
            noClusters = floor(noClustersOld/2);
        elseif length(find(clusterMotE == 1)) < length(find(bin_motE == 1))
            noClusters = floor(noClustersOld*1.5);
        else
            disp('noClusters did not change');
        end
    end
end
