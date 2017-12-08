function [sparse_map_median] = medianFilter(sparse_map,k)
    sparse_map_median = zeros(length(sparse_map),2);
    for i = 1: length(sparse_map)
        idx= knnsearch(sparse_map(:,1:2),sparse_map(i,1:2),'k',k);        
        sparse_map_median(i,1:2) = sparse_map(i,1:2);
%         sparse_map_median(i,3) = round(median(sparse_map(idx,3)));
        sparse_map_median(i,3) = median(sparse_map(idx,3));
    end
end
