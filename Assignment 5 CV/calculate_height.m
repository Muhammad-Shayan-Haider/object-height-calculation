function [] = calculate_height(image_path)
    [labels, image] = thresholding(image_path);
    disp(labels);
    stats = regionprops(labels,'BoundingBox'); 
    figure,imshow(image);                      
    for k = 1 : size(stats)
        BB = stats(k).BoundingBox;
        rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],...
            'EdgeColor','r','LineWidth',2 );
        pixels_height = BB(4) - BB(2);               
        length_of_pixel = 1 / 96;
        height = length_of_pixel * pixels_height;              
        text(BB(1), BB(2), height + " inches");
        set(gcf,'DefaultTextColor','green');
    end
    
end