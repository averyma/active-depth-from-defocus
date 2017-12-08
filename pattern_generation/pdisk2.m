function [result, r] = pdisk2(sizes, n, maxAttempt)
% Generate $n$ evenly spread-out 2d points in given region using Poisson
% disk method
%
% sizes: [xMax, yMax]
%   actual range: 0 <= x < xMax, 0 <= y < yMax
% n: # of points
% maxAttempt: # of candidates generated per iteration (optional)

xMax = sizes(1);
yMax = sizes(2);
if nargin <= 2, maxAttempt = 2.5*log(n); end

% min distance: approximate with tight packing (2*sqrt(3) = 3.464)
r = sqrt(xMax*yMax/n/3.5)*2;
r2 = r*r;
r2_3 = r2*3;

% lookup grid
pitch = r*sqrt(.5);
nX = ceil(xMax/pitch) + 1;
nY = ceil(yMax/pitch) + 1;
G = zeros(nY, nX); % NOTE: not typo

% result point list
active = zeros(n, 2); n_active = 0;
total = zeros(n, 2); n_total = 0;

% update ops
function idx = GI(p)
    ji = floor(p./pitch) + 1;
    idx = sub2ind([nY, nX], ji(2), ji(1));
end
function addPoint(p)
    n_active = n_active + 1;
    active(n_active, :) = p;
    n_total = n_total + 1;
    total(n_total, :) = p;
    G(GI(p)) = n_total;
end
function disablePoint(i)
    p = active(i, :);
    q = active(n_active, :);
    active(i, :) = q;
    n_active = n_active - 1;
end

addPoint(rand.*sizes);
while n_total < n && n_active > 0
    i = randi(n_active);
    p = active(i, :);
    for j = 1:maxAttempt
        succ = false;
        l = sqrt(rand*r2_3 + r2);
        a = rand*(2*pi);
        q = p + l.*[cos(a), sin(a)];
        if all([0 0] <= q) && all(q < sizes)
            gX = floor(q(1)/pitch) + 1;
            gY = floor(q(2)/pitch) + 1;
            gX_lo = max(gX - 2, 1); gX_hi = min(gX + 2, nX);
            gY_lo = max(gY - 2, 1); gY_hi = min(gY + 2, nY);
            gRange = G(gY_lo:gY_hi, gX_lo:gX_hi); % NOTE: not typo
            neighbors = total(gRange(gRange ~= 0), :);
            if size(neighbors, 1) == 0 || min(pdist2(q, neighbors)) >= r
                addPoint(q);
                succ = true;
                break;
            else
                q = q;
            end
        end
    end
    if ~succ
        disablePoint(i);
    end
end

result = total(1:n_total, :);

end