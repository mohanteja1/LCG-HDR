% -------------------------------------------------------------------------
% Implements a complete hdr and tonemapping cycles based on 
%       1.LCGHDR      [perinen 2007]
%       2.ReinHard
%       3.other default HDR techniques available in matlab
%
%
% 1. Computes the camera response curve according to "Recovering High
% Dynamic Range Radiance Maps from Photographs" by P. Debevec.
% You need a wide range of differently exposed pictures from the same scene
% to get good results.
%
% 2. Recovers a hdr radiance map from the range of ldr pictures using
%                    1.lcg hdr   
%                    2.reinhard 
%                    3.hdr toolbox
% 3. Tonemaps the resulting hdr radiance map according to 
%       1. lcgHDR ---> fussion improved bitonic tonemapping or histogram equalization in larson 97
%       2. reinhard hrd --> reinhard tone mapping
%       3. matlab hdr toolbox algos
% Some code taken from Paul Debevec's implementation of his SIGGRAPH'97
% paper "Recovering High Dynamic Range Radiance Maps from Photographs
% -------------------------------------------------------------------------
% Specify the directory that contains your range of differently exposed
% pictures. Need not to have a '\' at the end.
% The images need to have exposure information encoded in the header of images used.
% See readDir.m for details.

typeOfImages='jpgCompressed' ;
method='lcgHdr';
%method='reinhard';

switch typeOfImages
    case 'rawUncompressed'
        dirName = ("data\ldrs\Raw");
        type=('\*.NEF');
    case 'dngConverted'
        dirName = ("data\ldrs");
        imageType='\*.tiff';
    case 'jpgCompressed'
        dirName = ("data\original\desktop01");
        imageType='\*.jpg';
    otherwise
        error(['Invalid option string -- ', option]);
end


%--------------------------------------reading files-----------------------------------------------

[filenames, exposures, numExposures,resolution] = readDir(dirName,imageType);
fprintf('Opening test image\n');

numPixels = resolution(1) * resolution(2);



% define lamda smoothing factor
l = 50;

%-------------------- load and sample the images for crf------------------------
 
 [zRed, zGreen, zBlue,sampleIndices] = makeImageMatrix(filenames, numPixels);

%----------------------------------------------apply selected----------------------------------------

switch method
    case 'lcgHdr'
        %-------------------------------------lcghdr--------------------------------------------
        fprintf('Computing weighting function\n');
            %---- precompute the weighting function value for each pixel-----------
        
        %------------reinhard weights------------
%         weights = [];
%         for i=1:256
%             weights(i) = weight(i,1,256);
%         end
%         %---- convert the weights Wcam to double---------
        % gets an array from 0 to 255
        weights = uint8(linspace(0,255,256));
        % converts it into float values
        weights=im2double(weights);
        % pass double values into weight function and get weights
        weights=arrayfun(@(x)lcgWeight(x,1,6,1),weights);
        %convert them into ints again
        weights=im2uint8(weights);
        % compensate for zeros
        weights=weights+1;
        weights=double(weights);
        
        %------------\exposure matrix useful in gsolve \-------------
       
        B = zeros(size(zRed,1)*size(zRed,2), numExposures);
        
        fprintf('Creating exposures matrix B\n')
        for i = 1:numExposures
            B(:,i) = log(exposures(i));
        end
        
        %---------------weights Wy -------------------
        
        weightY = uint8(linspace(1,256,256));
        weightY=im2double(weightY);
        weightY=arrayfun(@(x)lcgWeight(x,3,3,0),weightY);
        weightY=im2uint8(weightY);
        weightY=weightY+1;
        weightY=im2double(weightY);                % im2double(weightY); % for showing graphs 
        %-----------------lcghdr----------------------
        
        
        
        %----------calculate zluminance--------------
        zLuminance= uint8(0.299 * zRed + 0.587 * zGreen + 0.114 * zBlue);
        %zLuminance=uint8(0.2126 * zRed + 0.7152 * zGreen + 0.0722 * zBlue);  %for sRGB space;
        
        %--------solve the system for luminance channel-------
        [gLuminance,lEBlue]=gsolve(zLuminance, B, l, weights);
        save('gMatrix.mat','gLuminance');
        
         
        % compute the hdr radiance map
        fprintf('Computing hdr image\n')
        
        
        hdrMap = lcgHdr(filenames,resolution, gLuminance, weightY, B);
        
%         y=hdrMap(:,:,1);
%         c=hdrMap(:,:,2);
%         cr=hdrMap(:,:,3);
%         imshow(hdrMap);
        
%         % compute the hdr luminance map from the hdr radiance map. It is needed as
%         % an input for the Reinhard tonemapping operators.
%         fprintf('Computing luminance map\n');
%         luminance = 0.2125 * hdrMap(:,:,1) + 0.7154 * hdrMap(:,:,2) + 0.0721 * hdrMap(:,:,3);
%         
%         % apply Reinhard local tonemapping operator to the hdr radiance map
%         fprintf('Tonemapping - Reinhard local operator\n');
%         saturation = 0.6;
%         eps = 0.05;
%         phi = 8;
%         [ldrLocal, luminanceLocal, v, v1Final, sm ]  = reinhardLocal(hdrMap, saturation, eps, phi);
%         
%         % apply Reinhard global tonemapping oparator to the hdr radiance map
%         fprintf('Tonemapping - Reinhard global operator\n');
%         % specify resulting brightness of the tonampped image. See reinhardGlobal.m
%         % for details
%         a = 0.72;
%         % specify saturation of the resulting tonemapped image. See reinhardGlobal.m
%         % for details
%         saturation = 0.6;
%         [ldrGlobal, luminanceGlobal ] = reinhardGlobal( hdrMap, a, saturation );
        
    case 'reinhard' 
        %---------------------------------------reinhard---------------------------------
        
        fprintf('Computing weighting function\n');
        % precompute the weighting function value
        % for each pixel
        weights = [];
        for i=1:256
            weights(i) = weight(i,1,256);
        end
        
        % load and sample the images
        [zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, numPixels);
   
        B = zeros(size(zRed,1)*size(zRed,2), numExposures);
        
        fprintf('Creating exposures matrix B\n')
        for i = 1:numExposures
            B(:,i) = log(exposures(i));
        end
        
        % solve the system for each color channel
        fprintf('Solving for red channel\n')
        [gRed,lERed]=gsolve(zRed, B, l, weights);
        fprintf('Solving for green channel\n')
        [gGreen,lEGreen]=gsolve(zGreen, B, l, weights);
        fprintf('Solving for blue channel\n')
        [gBlue,lEBlue]=gsolve(zBlue, B, l, weights);
        save('gMatrix.mat','gRed', 'gGreen', 'gBlue');
        
      
        % compute the hdr radiance map
        fprintf('Computing hdr image\n')
        hdrMap = hdr(filenames,resolution, gRed, gGreen, gBlue, weights, B);
        %imshow(hdrMap);
        % compute the hdr luminance map from the hdr radiance map. It is needed as
        % an input for the Reinhard tonemapping operators.
        fprintf('Computing luminance map\n');
        luminance = 0.2125 * hdrMap(:,:,1) + 0.7154 * hdrMap(:,:,2) + 0.0721 * hdrMap(:,:,3);
        
        % apply Reinhard local tonemapping operator to the hdr radiance map
        fprintf('Tonemapping - Reinhard local operator\n');
        saturation = 0.6;
        eps = 0.05;
        phi = 8;
        [ldrLocal, luminanceLocal, v, v1Final, sm ]  = reinhardLocal(hdrMap, saturation, eps, phi);
        
        % apply Reinhard global tonemapping oparator to the hdr radiance map
        fprintf('Tonemapping - Reinhard global operator\n');
        % specify resulting brightness of the tonampped image. See reinhardGlobal.m
        % for details
        a = 0.72;
        % specify saturation of the resulting tonemapped image. See reinhardGlobal.m
        % for details
        saturation = 0.6;
        [ldrGlobal, luminanceGlobal ] = reinhardGlobal( hdrMap, a, saturation );
        
        
    case 'matlabHdrTools'
        %--------------------------------matlabHdrTools-----------------------------------------------------
        
        
    otherwise
         error(['Invalid option string -- ', option]);

        
        
end
