function [ratio, classifiedFrames] = alignSamplingRates(classifiedFrames, ...
                frameRate, caRate, precision)
%% Adjust the sampling rate of the video to the one of the Ca imaging
    ratio = frameRate/caRate;
    ratio = round(ratio, precision);
    ratio = ratio*10^precision;
    
    classifiedFrames = repelem(classifiedFrames, 10^precision);
%     classifiedFrames = classifiedFrames(1:ratio:end);
end