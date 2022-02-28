function my_conv =...
    b1_processStack(img, angle, bln_borders, n_p)

% Convolution
I = imrotate(img, angle, 'bilinear', 'crop');
if bln_borders
    my_conv = b2_windowedConv2Dexp_padding_fast(I, [n_p, n_p]);
%     my_conv = windowedConv2D(I, [0, n_p]);
else
    my_conv = b2_windowedConv2Dexp(I, [n_p, n_p]);
end
% Rectification
my_conv(my_conv<0) = 0;

% % Peaks computation
% my_peak = zeros(size(my_conv));
% for r = 1:size(my_conv, 1)
%     [~, peaks] = findpeaks(my_conv(r,:));
%     my_peak(r, peaks) = my_conv(r, peaks);
% end

% % BW stack
% my_bw = imfill( bwareaopen( imbinarize(my_peak, 0) ,P) ,'holes');