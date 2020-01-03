clc;    % Clear the command window.
clear;  % Erase all existing variables. Or clearvars if you want.
Irgb = imread('potholes2.jpg');
I = rgb2gray(Irgb);
level = 0.2;

%potholes5.jpg
%level = 0.6;

%Removing noise
J = imnoise(I,'salt & pepper',0.02);
Kmedian = medfilt2(J);
imshow(Kmedian);

%Convert image to black and white
BW = imbinarize(Kmedian, level);

%Invert black and white image
WB = imcomplement(BW);
imshow(WB);

%Edge detection
S = edge(WB, 'sobel');
C = edge(WB, 'canny');
R = edge(WB, 'roberts');
P = edge(WB, 'Prewitt');
imshow(Irgb);

%Draw circles
[centers, radii, metric] = imfindcircles(C,[5 30]);
viscircles(centers, radii,'EdgeColor','b');