% double checks all conditions are reset
clear all
close all

% opening the right folder in MATLAB folder
cd SCS3_Lab

% completing exercise 1.3
monochrome = imread('MonochromeImage.png');     % read image file and storing its pixels as a matrix in variable
[m n] = size(monochrome);    % stores the size of image matrix in m and n
imshow(monochrome, [], 'InitialMagnification', 'fit', 'Border', 'tight')    % displays image stores as a matrix
macrob = 8;     % the length and width of macroblock
myMacroBlocks = zeros(m, n);    % making a matrix the same size as original image with zeros
% copying images in macroblock slices into a myMacroBlocks matrix
for i = 1:macrob:m
    for j = 1:macrob:n
        myMacroBlocks(i:i+7, j:j+7) = monochrome(i:i+7, j:j+7);
    end
end
imshow(myMacroBlocks, [], 'InitialMagnification', 'fit', 'Border', 'tight')     %verify if initial image is same as the one copied

% completing exercise 1.4
% discrete consine transform on orignal image in macroblock slices saved into a myMacroBlocks matrix
for i = 1:macrob:m
    for j = 1:macrob:n
        myMacroBlocks(i:i+7, j:j+7) = dct2(monochrome(i:i+7, j:j+7));
    end
end
disp(myMacroBlocks(34, 1))      % checking value of myMacroBlocks at position 34, 1 to verify proper conversion
disp(myMacroBlocks(9, 6))       % checking value of myMacroBlocks at position 9, 6 to verify proper conversion

% completing exercise 1.5
reshaped = reshape(myMacroBlocks, 1, []);     % reshapes a matrix into a 1 by x matrix
sorted = sort(reshaped);        % sorts in ascending order the reshaped matrix
[y x] = size(sorted);    % stores the size of image matrix in y and x
ninetieth_perc = round(0.9*x);     % finding the column index of 90th percentile
threshold = sorted(1, ninetieth_perc);     % the value of the column index at the 90th percentile position
for i = 1:m
    for j = 1:n
        myMacroBlocks(i, j) = (abs(myMacroBlocks(i, j)) < threshold) ? 0 : myMacroBlocks(i, j);
    end
end
compressed_img = zeros(m, n);
for i = 1:macrob:m
    for j = 1:macrob:n
        compressed_img(i:i+7, j:j+7) = idct2(monochrome(i:i+7, j:j+7));
    end
end
imshow(compressed_img, [], 'InitialMagnification', 'fit', 'Border', 'tight')



%This code works
image = imread('MonochromeImage.png');
[m, n] = size(image);
macrob = 8;
myMacroBlocks = zeros(m, n);
for i = 1:macrob:m
    for j = 1:macrob:n
        myMacroBlocks(i:i+7, j:j+7) = dct2(image(i:i+7, j:j+7));
    end
end
%imshow(myMacroBlocks, [], 'InitialMagnification', 'fit', 'Border', 'tight')
sorted = sort(reshape(myMacroBlocks, 1, []));
percentile = 100;
threshold = prctile(sorted, percentile);
myMacroBlocks(abs(myMacroBlocks) < threshold) = 0;
%imshow(myMacroBlocks, [], 'InitialMagnification', 'fit', 'Border', 'tight')
for i = 1:macrob:m
    for j = 1:macrob:n
        myMacroBlocks(i:i+7, j:j+7) = idct2(myMacroBlocks(i:i+7, j:j+7));
    end
end
imshow(myMacroBlocks, [], 'InitialMagnification', 'fit', 'Border', 'tight')



image = imread('MonochromeImage.png');
macrob_size = [8 8];
comp_ratio = 99;

dct_func = @(block_struct) dct2(block_struct.data);
idct_func = @(block_struct) idct2(block_struct.data);

transform = blockproc(image, macrob_size, dct_func, 'BorderSize', [0 0]);
sorted = sort(reshape(transform, 1, []));
threshold = prctile(sorted, comp_ratio);
transform(abs(transform) < threshold) = 0;
decomp_image = blockproc(transform, macrob_size, idct_func, 'BorderSize', [0 0]);

imshow(decomp_image, [], 'InitialMagnification', 'fit', 'Border', 'tight')w