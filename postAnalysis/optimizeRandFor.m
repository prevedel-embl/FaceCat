function [model, Yfit, score] = optimizeRandFor(hog_ChunkN, links, noClusters)
    % Draw 15% of the data randomly for training the classifier
    nIter = ceil(0.15*size(hog_ChunkN, 1));
    rand_idcs = randperm(size(hog_ChunkN, 1), nIter);
    rand_hogs = hog_ChunkN(rand_idcs, :);
    % Cluster the data to obtain labels
    classifiedFrames = cluster(links, 'maxclust', noClusters);
    % Get the labels matching the randomly selected data
    rand_lbls = classifiedFrames(rand_idcs);
    % Train the random forest classifier
    model = TreeBagger(50,rand_hogs,rand_lbls,'OOBPrediction','On',...
    'Method','classification');
    % Obtain the prediction for the rest of the data
    test_hogs = hog_ChunkN;
    test_hogs(rand_idcs, :) = [];
    testClassifiedFrames = classifiedFrames;
    testClassifiedFrames(rand_idcs) = [];
    Yfit = predict(model,test_hogs);
    Yfit = cellfun(@str2num, Yfit, 'UniformOutput', false);
    Yfit = cell2mat(Yfit);
    tmp = Yfit == testClassifiedFrames;
    score = length(find(tmp == 1))/length(tmp);
end