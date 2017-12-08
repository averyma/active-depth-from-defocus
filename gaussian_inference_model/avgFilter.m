% function [sparse_map_avg] = avgFilter(sparse_map,k)
%     sparse_map_avg = zeros(length(sparse_map),2);
%     for i = 1: length(sparse_map)
%         idx= knnsearch(sparse_map(:,1:2),sparse_map(i,1:2),'k',k);
%         sparse_map_avg(i,1:2) = sparse_map(i,1:2);
%         sparse_map_avg(i,3) = mean(sparse_map(idx,3));
%     end
% end
% 
function [sparse_map_r_avg,sparse_map_b_avg] = avgFilter(sparse_map_r,sparse_map_b,k)
    sparse_map = [sparse_map_r;sparse_map_b];
    sparse_map_r_avg = zeros(length(sparse_map_r),2);
    sparse_map_b_avg = zeros(length(sparse_map_b),2);
    
    for i = 1: length(sparse_map_r)
        idx= knnsearch(sparse_map(:,1:2),sparse_map_r(i,1:2),'k',k);
        sparse_map_r_avg(i,1:2) = sparse_map_r(i,1:2);
        sparse_map_r_avg(i,3) = mean(sparse_map(idx,3));
    end
    
    for i = 1: length(sparse_map_b)
        idx= knnsearch(sparse_map(:,1:2),sparse_map_b(i,1:2),'k',k);      
        sparse_map_b_avg(i,1:2) = sparse_map_b(i,1:2);
        sparse_map_b_avg(i,3) = mean(sparse_map(idx,3));
    end
end
