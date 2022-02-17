function [f5] = c4_computef5(img, Gmag, Gdir, n_p)

temp        = imbinarize(img, 0);
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

patch_w = cell(l,1);
patch_dir = cell(l,1);
for k=1:l
    patch_w{k} = Gmag(r(k), c(k)-Nrow(k):c(k)+Nrow(k));
%     patch_dir{k} = (Gdir(r(k), c(k)-Nrow(k):c(k)+Nrow(k)))*pi/180;
    patch_dir{k} = (Gdir(r(k), c(k)-Nrow(k):c(k)+Nrow(k)));
end

G_dir = cell(l,1);
base = 0.1;
alphaW = 90;
for k = 1:l
    G_dir{k} = abs(patch_dir{k}+fliplr(patch_dir{k}));
    idx = (180-alphaW)<G_dir{k} & G_dir{k}<(180+alphaW);
    G_dir{k}(idx) = (1-abs(G_dir{k}(idx)-180)/alphaW)*(1-base);
    G_dir{k}(~idx) = 0;
    G_dir{k} = G_dir{k}+base;
end

f5 = 0; norm = 0;
for k = 1:l
    if sum(patch_w{k})>0
        wF = sum(patch_w{k}.*fliplr(patch_w{k}))./sum(patch_w{k}.^2);
        f5 = f5+sum(wF*sum(patch_w{k}.*G_dir{k}));
        norm = norm+sum(patch_w{k});
    end
end
if norm>0
    f5 = f5/norm*sqrt(l);
%     f5 = f5/norm;
end