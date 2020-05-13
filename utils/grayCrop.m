function frame = grayCrop(frame, cropRangeY, cropRangeX)
    if ndims(frame) > 2
                frame = rgb2gray(frame);
    end
    frame = frame(cropRangeY, cropRangeX);
end