function mp4_2avi()
    reader = VideoReader('C:\Users\Wiessalla\Desktop\WIN_20200331_13_18_07_Pro.mp4');
    writer = VideoWriter('C:\Users\Wiessalla\Desktop\WIN_20200331_13_18_07_Pro.avi', ...
                'Motion JPEG AVI');
    
    % open the writer object for writing
    open(writer);
    
    while hasFrame(reader)
        frame = readFrame(reader);
        writeVideo(writer, frame);
    end
    close(writer)
    endwr