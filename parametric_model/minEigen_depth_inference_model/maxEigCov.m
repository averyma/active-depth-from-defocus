function [maxEigCov] = maxEigCov(I_patch)
    I_patch = round(I_patch *10000);
    [X Y]=meshgrid(1:size(I_patch,1),1:size(I_patch,2));
    sampleConfig = [X(:) Y(:) I_patch(:)];
    sampleSet = zeros(sum(I_patch(:)),2);
    cursor = 1;
    for j = 1:length(sampleConfig)
        if sampleConfig(j,3)~=0
            sampleSet(cursor:cursor+sampleConfig(j,3)-1,:)=repmat(sampleConfig(j,1:2),sampleConfig(j,3),1);
            cursor = cursor + sampleConfig(j,3);
        end
    end

    cov_xy = cov(sampleSet);
    eig_cov = eig(cov_xy);
%     maxEigCov = max(eig_cov);
%     maxEigCov = min(eig_cov);
    maxEigCov = mean(eig_cov);
end