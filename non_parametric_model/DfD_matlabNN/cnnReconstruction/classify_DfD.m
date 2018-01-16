        function [labels, scores] = classify_DfD(this, X, varargin)
            % classify   Classify data with a network           
            %            
            %   [labels, scores] = classify(net, X) will classify the data
            %   X using the network net. labels will be an N-by-1
            %   categorical vector where N is the number of observations,            
            %   and scores will be an N-by-K matrix where K is the number 
            %   of output classes. The format of X will depend on the input            
            %   layer for the network.            
            %            
            %   For an image input layer, X may be:            
            %       - A single image.            
            %       - A four dimensional numeric array of images, where the            
            %         first three dimensions index the height, width, and            
            %         channels of an image, and the fourth dimension            
            %         indexes the individual images.            
            %       - An image datastore.            
            %            
            %   [labels, scores] = classify(net, X, 'PARAM1', VAL1)
            %   specifies optional name-value pairs described below:
            %
            %       'MiniBatchSize'     - The size of the mini-batches for
            %                             computing predictions. Larger
            %                             mini-batch sizes lead to faster
            %                             predictions, at the cost of more
            %                             memory. The default is 128.
            %
            %   See also SeriesNetwork/predict, SeriesNetwork/activations.
            
            scores = this.predict( X, varargin{:} );
%             labels = iUndummify( scores, iClassNames( this.PrivateNetwork ) );
            
        end