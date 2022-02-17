function n_p = a2_computePatchSize(cho_patch_size, areaPerc, img)

switch cho_patch_size
    case 'f' % Fixed
        n_p = 100;
    case 'd' % Dynamic - in area percentage        
        n_p = round(sqrt(areaPerc*size(img,1)*size(img,2))/4)*4;
end