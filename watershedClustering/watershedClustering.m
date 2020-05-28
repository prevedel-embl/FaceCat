function [xx, density, boundaries, watershed_map] = watershedClustering(tSNEmap, sigma)
    [xx, density] = make_density_plots(tSNEmap, sigma);
    watershed_max = inv_watershed(density);
    watershed_max(watershed_max>0) = 1;
    [boundaries, watershed_map] = bwboundaries(watershed_max);
    figure
    imagesc(watershed_map)
end