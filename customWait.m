function pos = customWait(hROI)
%% Copy from https://de.mathworks.com/help/images/use-wait-function-after-drawing-roi-example.html
% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);

% Return the current position
pos = hROI.Position;


end