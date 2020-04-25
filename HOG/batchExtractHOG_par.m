function batchExtractHOG_par(video_path, laserSwitchOn_idx, laserSwitchOff_idx, ...
            batchNum, cropRangeY, cropRangeX)
    vidReader = VideoReader(video_path);
% Get estimated bytesize of the whole vidoe in HOGs
    size_dataChunks = 2000000000;
    [number_dataChunks, numFrames] = separateVideo(vidReader, size_dataChunks, ...
                            laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX);
    lenChunk = floor(numFrames/number_dataChunks);
    % Load only these chunks of 2GB size into memory, one at a time
    for N=1:number_dataChunks
        disp(strcat('Processing chunk ', num2str(N), ' out of_ ', num2str(number_dataChunks)));
        frameRangeLO = 1;
        frameRangeHI = lenChunk*N + 1;
        if frameRangeHI > numFrames
            frameRangeHI = numFrames;
        end
        
        hog_ChunkN = [];
        frame = frameRangeLO;
        % read the frames and convert them into HOG vectors
        parfor frame = frameRangeLO:frameRangeHI
            img = read(vidReader, frame);
            img = grayCrop(img, cropRangeY, cropRangeX);
            hog_vec = extractHOGFeatures(img, 'BlockSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
            hog_ChunkN(frame, :) = hog_vec;
        end
        cossim_hogs = pdist(hog_ChunkN, 'cosine');
        nIter = 10000;
        % Get the randomized distribution
        disp(strcat('Calculating bootstrap for chunk ', num2str(N)));
        avg_distance =  boot(vidReader, nIter, ...
                laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX);
        
        % Read all chunks following the one loaded above to compare them to
        % that one
        for M = N+1:number_dataChunks
            frameRangeLO = frameRangeHI+1;
            frameRangeHI = lenChunk*M + 1;
            if frameRangeHI > numFrames
                frameRangeHI = numFrames;
            end
            if frameRangeLO == numFrames
                break
            end
            hog_ChunkM = [];
            parfor frame = frameRangeLO:frameRangeHI
                img = read(vidReader, frame);
                img = grayCrop(img, cropRangeY, cropRangeX);
                hog_vec = extractHOGFeatures(img, 'BlockSize', [32 32], 'NumBins', 8, ...
                                    'BlockSize', [1 1]);
                hog_ChunkM(frame) = hog_vec;
            end
            cossim_tmp = pdist2(hog_ChunkN, hog_ChunkM, 'cosine');
            try
                cossim_tmp = squareform(cossim_tmp);
            catch
            end
            cossim_hogs = [cossim_hogs; cossim_tmp];
        end
        disp(strcat('Saving results for chunk ', num2str(N)));
        save(strcat('Cos2-dist_Vid#_', num2str(batchNum), '_N#_', num2str(N), '.mat'), 'cossim_hogs', '-v7.3');
        save(strcat('Avg_dist#_', num2str(batchNum), '_N#_', num2str(N), '.mat'), 'avg_distance', '-v7.3');
     %   clear cossim_hogs
    end
end

function [number_dataChunks, numFrames] = separateVideo(vidReader, size_dataChunks, ...
                                laserSwitchOn_idx, laserSwitchOff_idx, cropRangeY, cropRangeX)
%% Estimate in how many 2GB chunks the video needs to be separated       
        frame1 = read(vidReader, 1);
        frame1 = grayCrop(frame1, cropRangeY, cropRangeX);
        hog_vec = extractHOGFeatures(frame1, 'BlockSize', [32 32], 'NumBins', 8, ...
                            'BlockSize', [1 1]);
        hog1_byteSize = whos('hog_vec').bytes;
        numFrames = length(laserSwitchOn_idx:laserSwitchOff_idx);
        estimated_byteSize = numFrames*hog1_byteSize;
        number_dataChunks = ceil(estimated_byteSize/size_dataChunks);
end

