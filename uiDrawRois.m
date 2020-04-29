function [pos_snout, pos_eye] = uiDrawRois(video_path)
    % Grab and display example frame
    vidReader = VideoReader(video_path)
    frame = read(vidReader, 3);
    fig = uifigure;
    imshow(frame)

    % Let user draw rois for snout and eye
    % uialert(fig,'Select ROI for the snout/nose position, confirm with double-click on ROI', ...
    %             '', 'Icon', '')
    roi = drawrectangle('Label', 'Snout Position', 'LineWidth', 1, ...
                            'Position', [297, 83, 251, 381]);
    pos_snout = customWait(roi);
    % uialert(fig,'Select ROI for the snout/nose position, confirm with double-click on ROI', ...
    %             '', 'Icon', '')
    roi2 = drawrectangle('Label', 'Eye Center','LineWidth', 1, 'Color', [1 0 0], ...
        'Position', [600, 183, 19, 16]);
    pos_eye = customWait(roi2);
        % Close open figures
    close all
end

