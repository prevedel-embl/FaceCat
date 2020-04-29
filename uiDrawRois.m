function [pos_snout, pos_eye] = uiDrawRois(video_path)
    % Grab and display example frame
    vidReader = VideoReader(video_path)
    frame = read(vidReader, 3);
    fig = uifigure;
    imshow(frame)

    % Let user draw rois for snout and eye
    % uialert(fig,'Select ROI for the snout/nose position, confirm with double-click on ROI', ...
    %             '', 'Icon', '')
    roi = drawrectangle('Label', 'Snout Position', 'LineWidth', 1)
    pos_snout = customWait_test(roi)
    % uialert(fig,'Select ROI for the snout/nose position, confirm with double-click on ROI', ...
    %             '', 'Icon', '')
    roi2 = drawrectangle('Label', 'Eye Center','LineWidth', 1, 'Color', [1 0 0])
    pos_eye = customWait_test(roi2)
    % Format output
    pos_snout = [pos_snout(1):pos_snout(3),pos_snout(2):pos_snout(4)];
    pos_eye = [pos_eye(1):pos_eye(3),pos_eye(2):pos_eye(4)];
    % Close open figures
    close all
end

