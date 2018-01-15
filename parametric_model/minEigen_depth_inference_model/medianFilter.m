function [sparse_map_median] = medianFilter(sparse_map,k)
    sparse_map_median = zeros(length(sparse_map),2);
    for i = 1: length(sparse_map)
        idx= knnsearch(sparse_map(:,1:2),sparse_map(i,1:2),'k',k);
        sparse_map_median(i,1:2) = sparse_map(i,1:2);
        sparse_map_median(i,3) = median(sparse_map(idx,3));
    end
end
% 
% function [sparse_map_r_median,sparse_map_b_median] = medianFilter(sparse_map_r,sparse_map_b,k)
%     sparse_map = [sparse_map_r;sparse_map_b];
%     sparse_map_r_median = zeros(length(sparse_map_r),2);
%     sparse_map_b_median = zeros(length(sparse_map_b),2);
%     
%     for i = 1: length(sparse_map_r)
%         idx= knnsearch(sparse_map(:,1:2),sparse_map_r(i,1:2),'k',k);
%         sparse_map_r_median(i,1:2) = sparse_map_r(i,1:2);
%         sparse_map_r_median(i,3) = median(sparse_map(idx,3));
%     end
%     
%     for i = 1: length(sparse_map_b)
%         idx= knnsearch(sparse_map(:,1:2),sparse_map_b(i,1:2),'k',k);      
%         sparse_map_b_median(i,1:2) = sparse_map_b(i,1:2);
%         sparse_map_b_median(i,3) = median(sparse_map(idx,3));
%     end
% end
