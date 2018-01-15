function [result, r] = pdisk2_Sequential(sizes, dot_location)

xMax = sizes(1);
yMax = sizes(2);
maxAttempt = 20;
n = length(dot_location);

% min distance between previous generated dot_location
r = findShortestDistance(dot_location);
r2 = r*r;
r2_3 = r2*3;

% result point list
active = zeros(n, 2); n_active = 0;
total = zeros(n, 2); n_total = 0;

% update ops
function addPoint(p)
    n_active = n_active + 1;
    active(n_active, :) = p;
    n_total = n_total + 1;
    total(n_total, :) = p;
end
function disablePoint(i)
    p = active(i, :);
    q = active(n_active, :);
    active(i, :) = q;
    n_active = n_active - 1;
end

%% plot existing plot %%
plot_dot = ceil(dot_location);

% convert coordinate to index locations
dot_index = sub2ind(sizes,plot_dot(:,1),plot_dot(:,2));

dot_pattern = zeros(sizes);
dot_pattern(dot_index) = 1;

dot_zero = zeros(sizes(1),sizes(2),3);
dot_zero(:,:,1) = dot_pattern;
dot_pattern = dot_zero;

figure(1), imshow(dot_pattern)

%% add first point
c =0;
while n_total ==0
    q = rand.*sizes;
%     c = c+1
    if min(pdist2(q,dot_location)) > r*0.6
        addPoint(q);
        
        dot_pattern(ceil(q(1)),ceil(q(2)),2)=1;
        figure(1), imshow(dot_pattern)
    end
end

% while n_total < n && n_active > 0
while n_active > 0
    i = randi(n_active);
    p = active(i, :);
    for j = 1:maxAttempt
        succ = false;
        l = sqrt(rand*r2_3 + r2);
        a = rand*(2*pi);
        q = p + l.*[cos(a), sin(a)];
        if all([0 0] <= q) && all(q < sizes)
            dot_pattern(ceil(q(1)),ceil(q(2)),3)=1;
            figure(1), imshow(dot_pattern)
            % check with previous generated dot || new dots
            if min(pdist2(q,dot_location)) > r*0.6 && min(pdist2(q,total)) >r 
                addPoint(q);
                
                dot_pattern(ceil(q(1)),ceil(q(2)),2)=1;
                dot_pattern(ceil(q(1)),ceil(q(2)),3)=0;
                figure(1), imshow(dot_pattern)
                
                succ = true;
                break;
            end
        end
    end
    if ~succ
        disablePoint(i);
    end
end

result = total(1:n_total, :);

end