function [links, stereotypedFrames, minClusterNumber] = helperPost(cossim_hogs, avg_distance)

    minClusterNumber = [];
    for percent_quant = 2:20
        [stereotypedFrames, behavior_timepoints] = visualInspection(cossim_hogs, avg_distance, percent_quant);
        if ~isempty(behavior_timepoints)
            minClusterNumber(end+1) = percent_quant;
            break
        end
    end
    links = linkage(cossim_hogs, 'average');
    figure
    dendrogram(links, size(links,1)+1);

end