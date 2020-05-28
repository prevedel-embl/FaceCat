function [xx, density] = make_density_plots(zValues, sigma)
    %% Make density plots
    embeddingValues = zValues;


    maxVal = max(max(abs((embeddingValues))));
    maxVal = round(maxVal * 1.1);

    sigma = sigma;
    numPoints = 500; %501;
    rangeVals = [-maxVal maxVal];

    [xx,density] = findPointDensity((embeddingValues),sigma,numPoints,rangeVals);

    figure
    maxDensity = max(density(:));
    imagesc(xx,xx,density)
    axis equal tight off xy
    caxis([0 maxDensity * .8])
    colormap(jet)
    colorbar
end
