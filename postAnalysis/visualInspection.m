function [stereotypedFrames, behavior_timepoints] = visualInspection(cossim_hogs, links, percent_quant)
%% Take the distance matrix and detect cluster assignments and plot the result   
    % C_clusterFrames
%     cutoff = quantile(avg_distance, percent_quant);
    links = linkage(cossim_hogs, 'average');
%     stereotypedFrames = cluster(links, 'Cutoff', cutoff, 'Criterion', 'distance');
    stereotypedFrames = cluster(links, 'MaxClust', percent_quant);
    % Count the number of cluster assignment changes within 0.25s sliding
    % winwow
    amountOfChange = detectClusterChangesStep(stereotypedFrames);
    % Cumulative plot indicates areas with high change rate as steps
    cumulativeIntegral = cumtrapz(amountOfChange);
    % Display the raw data
%     figure
%     area(amountOfChange)
%     title(strcat('Cluster changes at timepoint x, cutoff=', num2str(percent_quant)))
    % Display the detected steps in the graph and save corresponding
    % timepoints
    figure
    findchangepts(cumulativeIntegral, 'MaxNumChanges', 10)
    behavior_timepoints = findchangepts(cumulativeIntegral, 'MaxNumChanges', 10);
    title(strcat('Cluster change rate, 10 biggest changes, cutoff=', num2str(percent_quant)))
    xticks(behavior_timepoints)
    xticklabels(string(behavior_timepoints))
    yticks([])
    yticklabels([])
    xlim([0 length(cumulativeIntegral)]);
end


