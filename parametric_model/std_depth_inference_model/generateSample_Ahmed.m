function [sample] = generateSample_Ahmed(I_patch)

ind = find(I_patch);
cdfA = cumsum(I_patch(:));  % 
cdfA = unique(cdfA);  % remove repetitives caused by the zeros in I_patch
bigVector = zeros(sum(I_patch(:)),1); % row vector to store the linear index of I_patch
bigVector(cdfA) = ind;

bigVectorReversed = bigVector(end:-1:1); % reverse the vector bigVector
lin_idx = find(bigVectorReversed~=0);
d = diff(bigVectorReversed(lin_idx)); 
bigVectorReversed(lin_idx(2:end)) = d;

filled_bigVector = cumsum(bigVectorReversed);
filled_bigVector = filled_bigVector(end:-1:1);

% convert linear index to sunscripts
[Xind,Yind] = ind2sub(size(I_patch),filled_bigVector);

sample = [Xind Yind];

end