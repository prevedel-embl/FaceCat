function visualizeClustering(video_path, laserSwitchOn_idcs, laserSwitchOff_idcs, pos_snout, classifiedFrames)
vidReader = VideoReader(video_path);
    recordedFrames = [];
    for N=1
        tmp = laserSwitchOn_idcs(N):laserSwitchOff_idcs(N);
        recordedFrames = [recordedFrames tmp];
    end
  
    hog_ChunkN = single.empty;
    energy = single.empty;
    itr = 1;
    
    figure;
    for frame=1:length(recordedFrames)
        
        % read the frames and convert them into HOG vectors
            img = read(vidReader, recordedFrames(frame));
            img = grayCrop(img, pos_snout);
            imshow(img);
            text(49, 49, num2str(classifiedFrames(itr)), 'FontSize', 100,...
                'Color', [1 1 1], 'HorizontalAlignment', 'center', 'VerticalAlignment', ...
                    'top', 'Clipping', 'off'); % Create it.
            pause(0.03);
            itr = itr + 1;
%             delete(hText); % Delete it.k
    end
end