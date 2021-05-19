function inverse = inv_4d(array)

[o, p, n, m] = size(array);
inverse = zeros(o, p, n, m, 'single') ;
for i=1:n
    for j=1:m
        inverse(:,:,i,j) = inv(array(:,:,i,j));
    end
end
        