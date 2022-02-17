function GmagTh = c2_processGradient_v2(Gmag)

% -1ing the borders
[N,M] = size(Gmag);
for r = 1:N
    idx1 = find(Gmag(r,1:floor(M/2))>0,1);
    idx2 = find(Gmag(r,ceil(M/2):M)>0,1,'last')+ceil(M/2)-1;
    Gmag(r,1:idx1+5) = -1;
    Gmag(r,idx2-5:end) = -1;
end
for c = 1:M
    idx1 = find(Gmag(1:floor(N/2),c)>0,1);
    idx2 = find(Gmag(ceil(N/2):N,c)>0,1,'last')+ceil(N/2)-1;
    Gmag(1:idx1+5,c) = -1;
    Gmag(idx2-5:end,c) = -1;
end
GmagTh= Gmag;