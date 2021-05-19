function determinant = det_4d(array)
[~, ~, n, m] = size(array);
determinant = zeros(1, 1, n, m, 'single') ;
for i=1:n
    for j=1:m
        determinant(:,:,i,j) = det(array(:,:,i,j));
    end
end