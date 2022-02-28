function A = b3_small_circulant_insieme(x, L, numCh)

B=zeros(L,length(x),numCh);
for k=1:L
    B(k,:,:)=circshift(x,-(k-1));
end

A=B(:,1:length(x)-L+1,:);