function Cloop = loopmtimes(varargin)
if length(varargin) == 2
    A = varargin{1};
    B = varargin{2};
elseif length(varargin) == 4
    A = varargin{1};
    B = varargin{3};
    if strcmp(varargin{2}, 'transpose')
        A = permute(A, [2 1 3 4]);
    end
    if strcmp(varargin{4}, 'transpose')
        B = permute(B, [2 1 3 4]);
    end
end

if size(A(:,:,1,1)) == size(2)
    [m,k,p,o] = size(B);
elseif size(B(:,:,1,1)) == size(2)
    [m,k,p,o] = size(A);
else
    [m,~,p,o] = size(A);
    [~,k,~,~] = size(B);
end
Cloop = zeros(m,k,p,o);

for n=1:o
    for i = 1:p
        Cloop(:,:,i,n) = A(:,:,i,n)*B(:,:,i,n);
    end
end
end