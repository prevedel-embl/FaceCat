function extract_stat_tables(stereotypedFrames, numBatches)
    clusters = unique(stereotypedFrames);
    for i=1:length(clusters)
        temp = stereotypedFrames;
        temp(temp ~= clusters(i)) = 0;
        sterClusters(:,i) = temp;
        noFrames(i,:) = nnz(temp);
    end
    stats = table(clusters, noFrames);
    figure();
    clusterSize = bar(stats.noFrames.');
    save(strcat('stats_N_#', num2str(numBatches), '.mat'), 'stats', 'clusterSize');
end