function [shortestDistance] = findShortestDistance(point_set)
% find shortest distance pair within a point set
% input: point_set: 2 column point set with x y coordinates
% output: shortestDistance: distance between the cloest 2 points

p = point_set;
tri = delaunay(p(:,1),p(:,2));
d2fun = @(k,l) sum((p(k,:)-p(l,:)).^2,2);
d2tri = @(k) [d2fun(tri(k,1),tri(k,2)) ...
              d2fun(tri(k,2),tri(k,3)) ...
              d2fun(tri(k,3),tri(k,1))];
dtri = cell2mat(arrayfun(@(k) d2tri(k),...
               (1:size(tri,1))','UniformOutput',0));
shortestDistance = sqrt(min(dtri(:)));
