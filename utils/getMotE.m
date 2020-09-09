function energy = getMotE(frame)
    % read the current frame
    current = img;
    % read the next frame
    img2 = read(vidReader, recordedFrames(frame) + 1); 
    next = img2;
    % calculate motion energy
    energy = next - current;
end
