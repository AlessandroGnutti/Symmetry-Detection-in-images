function [Gmag, Gdir, GmagTh_v1, GmagTh_v2, edge_bw] =...
    c1_calculateGradient(img, angle, gammaH, gammaL)

I               = imrotate(img, angle, 'bilinear', 'crop');
minI = min(min(I));
I(~I) = minI-1;
[Gmag, Gdir]    = imgradient(I);
GmagTh_v1       = c2_processGradient(Gmag, gammaH, gammaL);
GmagTh_v2       = c2_processGradient_v2(Gmag);
edge_bw         = edge(I, 'Canny');