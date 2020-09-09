function energy = getMotE(frame, vidReader, recordedFrames)
    % read the current frame
    current = frame;
    % read the next frame
    img2 = read(vidReader, recordedFrames(frame) + 1); 
    next = img2;
    % calculate motion energy
    energy = next - current;
end
