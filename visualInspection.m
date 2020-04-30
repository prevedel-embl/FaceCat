function [behavior_timepoints, cumulativeIntegral] = visualInspection(cossim_hogs, avg_distance, percent_quant)
%% Take the distance matrix and detect cluster assignments and plot the result   
    % C_clusterFrames
    cutoff = quantile(avg_distance, percent_quant);
    links = linkage(cossim_hogs, 'average');
    stereotypedFrames = cluster(links, 'Cutoff', cutoff, 'Criterion', 'distance');
    % Count the number of cluster assignment changes within 0.25s sliding
    % winwow
    amountOfChange = detectClusterChanges(stereotypedFrames);
    % Cumulative plot indicates areas with high change rate as steps
    cumulativeIntegral = cumtrapz(amountOfChange);
    % Display the raw data
    figure
    area(amountOfChange)
    title(strcat('Cluster changes at timepoint x, cutoff=', num2str(percent_quant)))
    % Display the detected steps ifunction [behavior_timepoints, cumulativeIntegral] = visualInspection2(cossim_hogs, avg_distance, percent_quant)
%% Take the distance matrix and detect cluster assignments and plot the result   
    % C_clusterFrames
    cutoff = quantile(avg_distance, percent_quant);
    links = linkage(cossim_hogs, 'average');
    stereotypedFrames = cluster(links, 'Cutoff', cutoff, 'Criterion', 'distance');
    % Count the number of cluster assignment changes within 0.25s sliding
    % winwow
    amountOfChange = detectClusterChangesStep(stereotypedFrames);
    % Cumulative plot indicates areas with high change rate as steps
    cumulativeIntegral = cumtrapz(amountOfChange);
    % Display the raw data
    figure
    area(amountOfChange)
    title(strcat('Cluster changes at timepoint x, cutoff=', num2str(percent_quant)))
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
end


n the graph and save corresponding
    % timepoints
    figure
    findchangepts(cumulativeIntegral, 'MaxNumChanges', 10)
    behavior_timepoints = findchangepts(cumulativeIntegral, 'MaxNumChanges', 10);
    title(strcat('Cluster change rate, 10 biggest changes, cutoff=', num2str(percent_quant)))
    xticks(behavior_timepoints)
    xticklabels(string(behavior_timepoints))
    yticks([])
    yticklabels([])
end


