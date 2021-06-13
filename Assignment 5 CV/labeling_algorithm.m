function[buffer, image] = labeling_algorithm(image)
    image = padarray(image, [1 1]);
    [x, y, z] = size(image); % x = rows, y = columns
    
    buffer = zeros(x, y);
    equivalence_table = {};
    count = 1;
    
    for i = 1 : x
        for j = 1 : y
            if (image(i, j) ~= 0)                
                if (buffer(i - 1, j - 1) == 0 && buffer(i - 1, j) == 0 && buffer(i, j - 1) == 0 ... 
                    && buffer(i + 1, j + 1) == 0 && buffer(i + 1, j) == 0 && buffer(i, j + 1) == 0)
                    % if no neighbours are labeled, label this pixel as a new
                    % object.
                    buffer(i, j) = count;                    
                    equivalence_table{count} = count;
                    count = count + 1;
                else
                    % if any of the neighbours are labeled.
                    % assign current pixel the label which is minimum of
                    % them.
                    neighbours = [buffer(i - 1, j - 1) buffer(i - 1, j) buffer(i, j - 1) ...
                        buffer(i + 1, j + 1) buffer(i + 1, j) buffer(i, j + 1)];
                    neighbours = neighbours(find(neighbours ~= 0));
                    buffer(i, j) = min(neighbours);
                    equivalence_table{min(neighbours)} = union(equivalence_table{min(neighbours)}, neighbours);
                end
            end
        end
    end
    
    % building equivalence table by putting all of them against the same
    % label index.
    [a b] = size(equivalence_table);
    for i = 1 : b
        for j = equivalence_table{i}
            equivalence_table{j} = union(equivalence_table{j}, equivalence_table{i});
        end
    end
    
    % combining all wrongly labeled connected components by assigning them
    % minimum labels.
    for i = 1 : x
        for j = 1 : y
            if(buffer(i,j) ~= 0)                
                buffer(i, j) = min(equivalence_table{buffer(i, j)});
            end
        end
    end
        
    
    % buffer = bwlabel(image, 8);
    
    
end





% D (i - 1, j - 1) | C (i - 1, j)
% -----------------|-----------------
% B (i, j - 1)     | A (i, j)
% reference: https://cecas.clemson.edu/~stb/ece847/internal/cvbook/ch02_pixproc.pdf
% reference: https://codedelimma.wordpress.com/