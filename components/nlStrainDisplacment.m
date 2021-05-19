%#codegen
function BN = nlStrainDisplacment(temp, FT_int)
BN = [temp.*repmat(FT_int, 1, 8, 1, 1); ...
        temp.*repmat(circshift(FT_int,[-1 0 0 0]), 1, 8, 1, 1)...
        + circshift(temp,[-1 0 0 0]).*repmat(FT_int, 1, 8, 1, 1)];
end

