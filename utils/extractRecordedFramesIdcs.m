function [laserSwitchOn_idcs, laserSwitchOff_idcs] = extractRecordedFramesIdcs(csv_path)
    % Create the gray value array recorded from the Mouse eye to a binary one
    laserOn = readtable(csv_path);
    laserOn = table2array(laserOn(:,2));
    laserOn(laserOn < 200) = 0;
    laserOn(laserOn >= 200) = 1;
    % Get the indices of when the illumination started and stopped
    laserSwitch = ischange(laserOn);
    laserSwitch = logical(laserSwitch);
    % Only every second change is a ON-switch
    laserSwitch_idx = find(laserSwitch == 1);
    laserSwitchOn_idcs = laserSwitch_idx(1:2:end);
    laserSwitchOff_idcs = laserSwitch_idx(2:2:end);
    
    recordLen = laserSwitchOff_idcs - laserSwitchOn_idcs;
    laserSwitchOn_idcs = laserSwitchOn_idcs(find(recordLen > 3600));
    laserSwitchOff_idcs = laserSwitchOff_idcs(find(recordLen > 3600));
end
