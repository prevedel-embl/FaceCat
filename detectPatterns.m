
function patComp = detectPatterns(stereotypedFrames)
    for i=1:length(stereotypedFrames)-15
        a(i, :) = stereotypedFrames(i:i+14, 1);
    end
    % Remove duplicate patterns to improve speed of the convolution
    a = unique(a, 'rows', 'stable');
    for i=1:length(a)
        patComp(i,:) = conv(stereotypedFrames, a(i,:), 'same');
        patComp(i,:) = patComp(i,:)/max(patComp(i,:));
    end
end
