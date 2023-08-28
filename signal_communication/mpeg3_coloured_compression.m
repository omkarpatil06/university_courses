clear all
close all

image = imread('MonochromeImage.png');    % specify the image to read, this also stores its pixels as a matrix in variable
macro_block = 8;    % specify length and width for macroblock
comp_ratio = 0.99;    % specify the compression ratio for the image


dct_func = @(block_struct) dct2(block_struct.data);    % a function that performs dct transform on macroblock structures
idct_func = @(block_struct) idct2(block_struct.data);    % a function that performs idct transform on macroblock structures

macrob_size = [macro_block, macro_block];    % vector to explicitly define the dimensions of macroblock
transform = blockproc(image, macrob_size, dct_func, 'BorderSize', [0 0]);    % stores the transformed data using the blockprop function 
sorted = sort(abs(reshape(transform, 1, [])));    % sorts the transformed data into ascending order
threshold = prctile(sorted, comp_ratio*100);    % based on the compression ratio the threshold value is decided using prctile
transform(transform < threshold) = 0;    % conditional that equates to 0 any variables that is less threshold
comp_image = blockproc(transform, macrob_size, idct_func, 'BorderSize', [0 0]);    % the inverse dct transform specified above is used to get the compressed images

imshow(comp_image, [], 'InitialMagnification', 'fit', 'Border', 'tight') % displays image stores as a matrix

original_size = whos('image').bytes;
compressed_size = whos('decomp_image').bytes;
disp(compressed_size/original_size); 

%{
titles = {'Red', 'Green', 'Blue'};
index = {[2, 3], [1, 3], [1, 2]}; % index should be a cell array of vectors
for i = 1:3
    subplot(1,3,i);
    sample = image;
    sample(:,:, index{i}) = 0;
    imshow(sample, [], 'InitialMagnification', 'fit', 'Border', 'tight');
    title(titles{i});
end

new_image = 0.3*image(:, :, 1) + 0.59*image(:, :, 2) + 0.11*image(:, :, 3)
imshow(new_image, [], 'InitialMagnification', 'fit', 'Border', 'tight');
%}
