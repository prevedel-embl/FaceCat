csv_path = 'Y:\members\Wiessalla\Data\Data processed\2020-04-04_eye_grayvalue_KLS-61896.csv';
vid_path = 'Y:\members\Wiessalla\Data\Data raw\20200403\KLS-61896\WIN_20200403_14_10_07_Pro.mp4';
out_path = 'Y:\members\Wiessalla\Data\Data raw\20200403\KLS-61896\WIN_20200403_14_10_07_Pro';

reader = VideoReader(vid_path);
% Create the gray value array recorded from the Mouse eye to a binary one
laserOn = readtable(csv_path);
laserOn = table2array(laserOn(:,2));
laserOn(laserOn < 250) = 0;
laserOn(laserOn >= 250) = 1;
% Get the indices of when the illumination started and stopped
laserSwitch = ischange(laserOn);
laserSwitch = logical(laserSwitch);
% Only every second change is a ON-switch
laserSwitch_idx = find(laserSwitch == 1);
laserSwitchOn_idx = laserSwitch_idx(1:2:end);
laserSwitchOff_idx = laserSwitch_idx(2:2:end);

for recordingEpoch=1:length(laserSwitchOn_idx)
    % Check that recordingEpoch lasts for at least a minute
    recordLen = laserSwitchOff_idx(recordingEpoch) - laserSwitchOn_idx(recordingEpoch);
    if recordLen > 3600
        out_path_iter = strcat(out_path, '_pt-', num2str(recordingEpoch), '.mp4');
        writer = VideoWriter(out_path_iter, 'Grayscale AVI');
        open(writer);
        for frame=laserSwitchOn_idx(recordingEpoch):laserSwitchOff_idx(recordingEpoch) 
            currentFrame = read(reader, frame);
            currentFrame = currentFrame(:,:,1);
            writeVideo(writer, currentFrame);
        end
        close(writer);
    end
end