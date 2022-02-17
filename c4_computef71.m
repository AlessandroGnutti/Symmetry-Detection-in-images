function f7 = c4_computef71(img, Gmag, Gdir, edge_bw, n_p)

temp        = im2bw(img, 0);
skel        = bwmorph(skeleton(temp) > 0, 'skel', Inf);
CC          = bwconncomp(skel);   
l           = length(CC.PixelIdxList{1});
[I, J]      = ind2sub(size(Gmag), CC.PixelIdxList{1});
[r, ind]    = sort(I, 'ascend');
c           = J(ind);

[~, C] = size(img);
Nrow = zeros(l,1); % Patch sul gradiente variabile
for k=1:l
    brLeft = c(k)-find(Gmag(r(k),1:c(k))<0, 1, 'last' )-1;
    if isempty(brLeft)
        brLeft = c(k)-1;
    end
    brRight = find(Gmag(r(k),c(k):end)<0, 1, 'first' )-2;
    if isempty(brRight)
        brRight = C-c(k);
    end
    Nrow(k) = min(brLeft,brRight);
    Nrow(k) = min(Nrow(k),n_p/2-1);
    Nrow(k) = n_p/2-1;
end

% Filtro tutto con gli edge
Gmag_edge = Gmag.*edge_bw;
Gdir_edge = Gdir.*edge_bw;

patch_w = cell(l,1);
patch_dir = cell(l,1);
for k=1:l
    patch_w{k} = Gmag_edge(r(k), c(k)-Nrow(k):c(k)+Nrow(k));
%     patch_dir{k} = (Gdir(r(k), c(k)-Nrow(k):c(k)+Nrow(k)))*pi/180;
    patch_dir{k} = (Gdir_edge(r(k), c(k)-Nrow(k):c(k)+Nrow(k)));
end

Gdir_edge_filt = cell(l,1);
base = 0.1;
alphaW = 90;
for k = 1:l
    Gdir_edge_filt{k} = abs(patch_dir{k}+fliplr(patch_dir{k}));
    idx = (180-alphaW)<Gdir_edge_filt{k} & Gdir_edge_filt{k}<(180+alphaW);
    Gdir_edge_filt{k}(idx) = (1-abs(Gdir_edge_filt{k}(idx)-180)/alphaW)*(1-base);
    Gdir_edge_filt{k}(~idx) = 0;
    Gdir_edge_filt{k} = Gdir_edge_filt{k}+base;
end

f7 = 0;
for k = 1:l
    if sum(patch_w{k})>0
        magTimesDir = patch_w{k}.*Gdir_edge_filt{k};
        f7 = f7 + sum(magTimesDir.*fliplr(magTimesDir))./sum(magTimesDir.^2);
    end
end
f7 = f7/sqrt(l);