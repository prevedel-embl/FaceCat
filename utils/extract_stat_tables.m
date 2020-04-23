function extract_stat_tables(stereotypedFrames, numBatches)
%% Create and write table holding information about number of frames assigned to a cluster
    clusters = unique(stereotypedFrames);
    for i=1:length(clusters)
        temp = stereotypedFrames;
        % Select only the instances of the particular cluster assignment
        temp(temp ~= clusters(i)) = 0;
        % This could be the place to adjust the count
        
        sterClusters(:,i) = temp;
        noFrames(i,:) = nnz(temp);
    end
    stats = table(clusters, noFrames);
    figure();
    clusterSize = bar(stats.noFrames.');
    save(strcat('stats_N_#', num2str(numBatches), '.mat'), 'stats', 'clusterSize');
end