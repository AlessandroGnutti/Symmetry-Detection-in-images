function A = b3_small_circulant(x, L)

B=zeros(L,length(x));
for k=1:L
    B(k,:)=circshift(x,-(k-1));
end

A=B(:,1:length(x)-L+1);