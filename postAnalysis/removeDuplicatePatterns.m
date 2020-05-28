function allPatterns = removeDuplicatePatterns(allPatterns)
%% Remove all circular permutations of the activity patterns detected
    duplicateRows = [];
    for i=1:size(allPatterns, 1)
        % Duplicate the patterns to detect the circular permutations, see
        % https://www.geeksforgeeks.org/a-program-to-check-if-strings-are-rotations-of-each-other/?ref=rp
        testedRow = [allPatterns(i,:) allPatterns(i,:)];
        parfor j=i+1:size(allPatterns, 1)
            itrRow = allPatterns(j,:);
            if any(strfind(testedRow, itrRow))
                % Store indices of duplicates
                duplicateRows(j,:) = j;
            end
        end
    end
    duplicateRows(duplicateRows == 0) = [];
    % Pairs of duplicates are detected twice with the method above
    duplicateRows = unique(duplicateRows);
    % Remove the duplicate rows
    allPatterns(duplicateRows, :) = [];
end