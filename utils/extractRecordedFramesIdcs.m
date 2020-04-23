function [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(csv_path)
    % Convert the gray value array recorded from the Mouse eye to a binary one
    laserOn = readtable(csv_path);
    laserOn = table2array(laserOn(:,2));
    laserOn(laserOn < 200) = 0;
    laserOn(laserOn >= 200) = 1;
    
    % Get the indices of when the illumination started and stopped
    laserSwitch = ischange(laserOn);
    % This util removes single values that fall below the threshold above
    % (i.e. outliers)
    laserOn = stitchThresholdHoles(laserOn, laserSwitch);
    laserSwitch = ischange(laserOn); % when laser switches on/off
    laserSwitch = logical(laserSwitch);
    % Only every second change is a ON-switch
    laserSwitch_idx = find(laserSwitch == 1);
    laserSwitchOn_idcs = laserSwitch_idx(1:2:end);
    laserSwitchOff_idcs = laserSwitch_idx(2:2:end);
    
    recordLen = laserSwitchOff_idcs - laserSwitchOn_idcs;
    % Only take epochs of the laser turned on for more than 1 minute
    laserSwitchOn_idcs = laserSwitchOn_idcs(find(recordLen > 3600));
    laserSwitchOff_idcs = laserSwitchOff_idcs(find(recordLen > 3600));
end
