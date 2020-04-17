function cossim_hogs = extractHOG_par(video_path)
    vidReader = VideoReader(video_path);
% Get estimated bytesize of the whole vidoe in HOGs
    size_dataChunks = 2000000000;
    number_dataChunks = separateVideo(vidReader, size_dataChunks);
    lenChunk = floor(vidReader.NumFrames/number_dataChunks);
    
    for N=1:number_dataChunks
        frameRangeLO = 1;
        frameRangeHI = lenChunk*N + 1;
        if frameRangeHI > vidReader.NumFrames
            frameRangeHI = vidReader.NumFrames;
        end
        
        hog_ChunkN = [];
%         frame = frameRangeLO;
        parfor frame = frameRangeLO:frameRangeHI
            img = read(vidReader, frame);
            if ndims(img) > 2
                img = rgb2gray(img);
            end
            hog_vec = extractHOGFeatures(img, 'BlockSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
            hog_ChunkN(frame, :) = hog_vec;
%                 frame = frame + 1;
        end
        cossim_hogs = pdist(hog_ChunkN, 'cosine');
%         
%         for M = N+1:number_dataChunks
%             frameRangeLO = frameRangeHI+1;
%             frameRangeHI = lenChunk*M + 1;
%             if frameRangeHI > vidReader.NumFrames
%                 frameRangeHI = vidReader.NumFrames;
%             end
%             
% %             frame = frameRangeLO;
%             if frameRangeLO == vidReader.NumFrames
%                 break
%             end
%             hog_ChunkM = [];
%             parfor frame = frameRangeLO:frameRangeHI
%                 img = read(vidReader, frame);
%                 if ndims(img) > 2
%                     img = rgb2gray(img);
%                 end
%                 hog_vec = extractHOGFeatures(img, 'BlockSize', [32 32], 'NumBins', 8, ...
%                                     'BlockSize', [1 1]);
%                 hog_ChunkM(frame, :) = hog_vec;
% %                     frame = frame + 1;
%                 cossim_tmp = squareform(pdist2(hog_ChunkN, hog_ChunkM, 'cosine'));
%                 cossim_hogs = [cossim_hogs; cossim_tmp];
%             end
        end
        save(strcat('Cos2-dist_N#_', num2str(N), '.mat'), 'cossim_hogs', '-v7.3');
     %   clear cossim_hogs
%     end
end

function number_dataChunks = separateVideo(vidReader, size_dataChunks)
        frame1 = read(vidReader, 1);
        if ndims(frame1) > 2
                frame1 = rgb2gray(frame1);
        end
        hog_vec = extractHOGFeatures(frame1, 'BlockSize', [32 32], 'NumBins', 8, ...
                            'BlockSize', [1 1]);
        hog1_byteSize = whos('hog_vec').bytes;
        estimated_byteSize = vidReader.NumFrames*hog1_byteSize;
        number_dataChunks = ceil(estimated_byteSize/size_dataChunks);
end

