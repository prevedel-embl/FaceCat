function no_clusters = clusterEstimate(eng_mean, no_sd)
    % Get mean and sd to calculate threshold
    eng_mean_tot = mean(eng_mean(:));
    eng_mean_sd = std(eng_mean(:));
    % obtain threshold
    significant_energy = eng_mean_tot + no_sd*eng_mean_sd;
    % output logical mask containing 1s whenever significant motion engergy
    % is exceeded
    no_clusters = eng_mean > significant_energy;
    no_clusters = length(find(no_clusters == 1));
end
