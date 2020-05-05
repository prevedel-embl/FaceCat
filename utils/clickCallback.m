function clickCallback(~,evt)
%% Copy from https://de.mathworks.com/help/images/use-wait-function-after-drawing-roi-example.html
if strcmp(evt.SelectionType,'double')
    uiresume;
end

end

