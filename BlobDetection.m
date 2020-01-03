clc;    % Clear the command window.
clear;  % Erase all existing variables. Or clearvars if you want.
Irgb = imread('potholes5.jpg');
I = rgb2gray(Irgb);
level = 0.6;


%Removing noise
J = imnoise(I,'salt & pepper',0.02);
Kmedian = medfilt2(J);
imshow(Kmedian);

%Convert image to black and white
BW = imbinarize(Kmedian, level);

%Invert black and white image
WB = imcomplement(BW);
imshow(WB);

% Label the blobs (use BW for potholes6, WB for everything else)
[labeledImage, numBlobs] = bwlabel(BW);
imshow(Irgb)
q = [];

props = regionprops(labeledImage, 'BoundingBox');

% Get the diagonal length of each box
for k = 1 : numBlobs
    thisBoundingBox = props(k).BoundingBox;
    b = thisBoundingBox(3);
    c = thisBoundingBox(4);
    b2 = b*b;
    c2 = c*c;
    a = sqrt(b2 - c2);
    a = abs(a);
    q = [q; a];
end

totalA = 0;
counter = 0;
meanA = 0;

% Filter out tiny blobs
for k = 1: length(q)
    if q(k) > 10
        counter = counter + 1;
        totalA = totalA + q(k);
    end
end
meanA = totalA / counter;

% Display the bounding boxes around the blobs, the smallest and 
% largest of which are filtered out.
for k = 1 : numBlobs
    thisBoundingBox = props(k).BoundingBox;
    b = thisBoundingBox(3);
    c = thisBoundingBox(4);
    b2 = b*b;
    c2 = c*c;
    a = sqrt(b2 - c2);
    a = abs(a);
    if numBlobs == 1
        rectangle('Position', thisBoundingBox, ...
        'EdgeColor', 'c', 'LineWidth', 2);
    else
        if (a >= meanA && a <= 8*meanA)
            rectangle('Position', thisBoundingBox, ...
            'EdgeColor', 'c', 'LineWidth', 2);
        end
    end
end