function watershed_max = inv_watershed(density)
    % Create the correct watershed segmentation
    inv_density = density.*(-1);
    watershed_max = watershed(inv_density);
end