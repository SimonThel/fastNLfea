function Cloop = loopmtimes(A,B,m,k,p,o)
Cloop = zeros(m,k,p,o);
for i = 1:p
    for n=1:o
        Cloop(:,:,i,n) = A(:,:,i,n)*B(:,:,i,n);
    end
end
end