function laserOn = stitchThresholdHoles(laserOn, laserSwitch)
    % This bit makes sure that single frames that fall below the threshold
    % don't impact the separation of recording epochs
        changes = find(laserSwitch == 1); % Where are laser switch on events detected?
        snippetLengths = diff(changes); % How long are the corresponding record-off snippets?
        shortBits = find(snippetLengths < 50); % All snippets shorter than 50 frames are probably just outliers, not true switch-off events
        shortBitStart = changes(shortBits);
        shortBitEnd = shortBitStart + snippetLengths(shortBits) - 1;
        if ~isempty(shortBitStart)
            for bitIter = 1:length(shortBitStart)
                laserOn(shortBitStart(bitIter):shortBitEnd(bitIter)) = laserOn(shortBitStart(bitIter) - 1); % replace the outlier holes with the value just before they start (i.e. a 1)
            end
        end
end