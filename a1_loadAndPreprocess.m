function [img_or, YCBCR] = a1_loadAndPreprocess(str_fold, name_img, minimum_size)

img_or = imread(strcat(str_fold,name_img));
if size(img_or,1) <= minimum_size || size(img_or,2) <= minimum_size
else
    fattore = minimum_size/min(size(img_or,1), size(img_or,2));
%     fattore = 0.5;
    img_or = imresize(img_or, fattore);
end
if length(size(img_or)) == 3
    YCBCR = double(rgb2ycbcr(img_or));
else
    YCBCR = double(img_or);
end

% Tolgo la media ad ogni componente
if length(size(YCBCR))==3
    numbComponents = 3;
elseif length(size(YCBCR))==2    
    numbComponents = 1;
else
    error('Something wrong')
end
for i = 1:numbComponents
    tmp = YCBCR(:,:,i);
    YCBCR(:,:,i) = YCBCR(:,:,i) - mean(tmp(:));
end

% La Y ottenuta da rgb2ycbcr e rgb2gray sono differenti?
% temp = double(rgb2gray(img_or));
% YCBCR(:,:,1) = temp - mean(temp(:));
    