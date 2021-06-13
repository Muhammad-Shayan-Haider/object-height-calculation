function [labels, image] = thresholding(image)
    
    %image = imresize(image, [16 16]);
    [x, y, z] = size(image);
    if z == 3
        image = rgb2gray(image);
    end
    image = ~(imbinarize(image));    
    [labels, image] = labeling_algorithm(image);    
end