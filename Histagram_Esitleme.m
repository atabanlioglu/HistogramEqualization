% Histogram Equalization
clc; clear all;

img = imread('c:\h4450pi.jpg');
 if(size(img,3) > 1)
    img = rgb2gray(img);
end;


img = imresize(img,[256 256],'bicubic');
max_r = size(img,1);
max_c = size(img,2);
histogram = zeros([1 256]);
cumulative_hist = zeros([1 256]);
for r=1:max_r
    for c=1:max_c
        for count=1:256
            if(img(r,c) == count-1)
                histogram(count) = histogram(count) + 1;
                break;
            end
        end
    end
end

%find cumulative histogram
current_value = 0;
for count=1:256
    current_value = current_value + histogram(count);
    cumulative_hist(count) = current_value;
end
%find h = (cdf-cdf(min)/(MN-cdf(min)))*255
%this is the normalized cumulative histogram
normalized_hist = zeros([1 256]);
cdf_min = min(cumulative_hist);
for count=1:256
    normalized_hist(count) = cumulative_hist(count) - cdf_min;
    normalized_hist(count) = normalized_hist(count) / ( (max_r*max_c) - cdf_min);
    normalized_hist(count) = round(normalized_hist(count) * 255);
end
%replace the values with the given equalized values
equalized_image = zeros([max_r max_c]);
for r=1:max_r
    for c=1:max_c
       
        for count=1:256
           
            if(img(r,c) == (count-1))
                %we have got the value of intensity for this pixel, replace
                %this with the equalized intensity
                equalized_img(r,c) = normalized_hist(count);
                break;
            end
        end
    end
end
subplot(2,2,1)
imshow(img);
title('Original Image');
subplot(2,2,2);
imhist(img);
title('Histogram of Original Image');
subplot(2,2,3);
imshow(uint8(equalized_img));
title('Histogram Equalized Image');
H=uint8(equalized_img);
subplot(2,2,4);
imhist(H);
title('Histogram of Histogram Equalized Image');