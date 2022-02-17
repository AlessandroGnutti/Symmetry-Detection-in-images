function GmagTh = c2_processGradient(Gmag, gammaH, gammaL)

tol_zero = 1e-6;

% -1ing the borders
[N,M] = size(Gmag);
for r = 1:N
    idx1 = find(Gmag(r,1:floor(M/2))>tol_zero,1);
    idx2 = find(Gmag(r,ceil(M/2):M)>tol_zero,1,'last')+ceil(M/2)-1;
    Gmag(r,1:idx1+5) = -1;
    Gmag(r,idx2-5:end) = -1;
end
for c = 1:M
    idx1 = find(Gmag(1:floor(N/2),c)>tol_zero,1);
    idx2 = find(Gmag(ceil(N/2):N,c)>tol_zero,1,'last')+ceil(N/2)-1;
    Gmag(1:idx1+5,c) = -1;
    Gmag(idx2-5:end,c) = -1;
end

% Computing the thresholded version
[s,i] = sort(Gmag(:),'descend');
GmagTrue = sum(Gmag(:)>tol_zero);
idxH = floor(gammaH*GmagTrue);
idxL = ceil(gammaL*GmagTrue);

s(i(1:idxH)) = Gmag(i(1:idxH));
s(i(idxL:end)) = 0;
s(i(idxH+1:idxL-1)) = (idxL-idxH-1:-1:1)'/(idxL-idxH).*Gmag(i(idxH+1:idxL-1));
GmagTh= reshape(s,size(Gmag));