function D_checkSequentiality(directory)
    numBatches = length(dir(strcat(directory, '/stereotyped_frames*')));
    for i=1:numBatches
        disp(strcat('loading stereotyped_frames_N#_', num2str(i), '.mat'))
        load(strcat(strcat(directory, '/stereotyped_frames_N#_', num2str(i), '.mat')))
        stereotypedFrames(isnan(stereotypedFrames))=0;
        change = ischange(stereotypedFrames);
        change = logical(change);
        change = ~change;
        sequences = regionprops(change, 'Area');
        sequences = {sequences.Area};
        sequences = cell2mat(sequences);
        disp(strcat('median for batch', num2str(i), ' is_', num2str(median(sequences))))
        extract_stat_tables(stereotypedFrames, i);
    end
end