function frame = grayCrop(frame, pos_crop)
    if ndims(frame) > 2
                frame = rgb2gray(frame);
    end
    frame = frame(pos_crop(1):pos_crop(1) + pos_crop(3), ...
                        pos_crop(2):pos_crop(2) + pos_crop(4));
end