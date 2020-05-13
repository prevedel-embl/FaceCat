function grayValue = measureGrayValue(video_path, pos_eye)
    tic
    vidReader = VideoReader(video_path);
    grayValue = [];
    while hasFrame(vidReader)
        current_frame = readFrame(vidReader);
        eyeArea = grayCrop(current_frame, pos_eye);
        tmp = regionprops(ones(size(eyeArea), 'logical'), eyeArea, 'MaxIntensity');
        tmp = struct2cell(tmp);
        % find empty cells
        emptyCells = cellfun(@isempty,tmp);
        % remove empty cells
        tmp(emptyCells) = [];
        % calculate the grayscale value mean
        tmp = mean(cellfun(@(x) x(:), tmp));
        % append measurement to vector
        grayValue(end+1,1) = tmp;
    end
    toc
end