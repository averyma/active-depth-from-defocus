%Joint denoising and enhancement via Bayesian Residual Transform
%Alexander Wong - a28wong@uwaterloo.ca - University of Waterloo - 2016
function cI = BRTseg(I,radius,regconst)
    numscale = 6;
    alpha = 2;
    
    %Bayesian Residual Transform
    %----------------------------------------------------
    residual = zeros(size(I,1),size(I,2),numscale);
    for i = 1:numscale-1
        E = directionalnonstationaryexpectation(I, radius, regconst);
        residual(:,:,i) = I-E;
        I = E;
        regconst = regconst/alpha;
    end;
    residual(:,:,numscale) = I;

    %Visualization
    %----------------------------------------------------
    figure
     for i = 1:numscale
         subplot(1,numscale,i);imshow(residual(:,:,i),[]);
     end;

    %Coefficient Rescaling
    %----------------------------------------------------
%         coeffweights = [0 0 1 0 0 1];
%     coeffweights = [0 0 6 2 2 1];
%     coeffweights = [5 5 5 0 0 1];
    coeffweights = [0 0 0 0 0 1];
    for i = 1:numscale
        residual(:,:,i)=coeffweights(i)*residual(:,:,i);
    end;
    
    %Inverse Bayesian Residual Transform
    %----------------------------------------------------
    cI = sum(residual,3);
    
