function priority = b4_computef1(bw, peak)
% COMPUTEPRIORITY Computes the priority feature for each symmetry axis.
%
%   PRIORITY = computePriority(BW, PEAK) returns the priority value for
%   each axis identified into binary image BW. PEAK is the image containing
%   the auto-convolution coefficients in peak positions.

priority    = [];   

CC = bwconncomp(bw);
if CC.NumObjects > 0
    intensity = zeros(1, CC.NumObjects);
    lunghezza = zeros(1, CC.NumObjects);  
    for i=1:CC.NumObjects
        lunghezza(i)                = length(CC.PixelIdxList{i});
        intensity(i)                = mean(peak(CC.PixelIdxList{i}));
    end
    priority = sqrt(lunghezza).*(intensity);
end