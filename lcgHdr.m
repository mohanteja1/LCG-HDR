% Generates a hdr radiance map from a set of pictures
%
% parameters:
% filenames: a list of filenames containing the differently exposed
% pictures used to make a hdr from
% gLuminance: camera response function for the luminance channel
% resolution: image dimensions
% weightY : weighing function for wY in formulae refer paper 
% dt: log exposure values of images


%dt=B;
function [ hdr ,scaleFactor ] = lcgHdr( filenames, resolution ,gLuminance, weightY, dt )

fprintf("\nreadfile\n");
numExposures = length(filenames);
rgbToYcbcrMat = [0.30,-0.17,0.50; 0.59, -0.33, -0.42; 0.11, 0.50, -0.08];

% pre-allocate resulting hdr image

hdr = zeros(resolution);

%pre-allocate equation components
luminanceDenominator = zeros(resolution(1),resolution(2));
luminanceNumerator = zeros(resolution(1),resolution(2));
CvNumerator = zeros(resolution(1),resolution(2));
CuCvDenominator = zeros(resolution(1),resolution(2));
CuNumerator = zeros(resolution(1),resolution(2));
scaleFactorDenominator=zeros(resolution(1),resolution(2));


for i=1:numExposures
    
    fprintf('Adding picture %i of %i \n', i, numExposures);
    
    %read picture converting it to tiff class
    imagePath= convertStringsToChars(filenames(i).folder + "\" + filenames(i).name);
    
    %---------------- for raw and uncompressed reading---------------
    %         tiffImage = Tiff(imagePath,'r');
    %         offsets = getTag(tiffImage,'SubIFD');
    %         setSubDirectory(tiffImage,offsets(3));
    %         %read Y cb cr components
    %         [image(:,:,1),image(:,:,2),image(:,:,3)] = read(tiffImage);
    %         close(tiffImage);
    %-----------------for compressed and sRGB files-------------------
    
    rgbDouble=im2double(imread(imagePath));
    r=rgbDouble(:,:,2);
    %-----------------conversion rgb to ycbcr---------%
    
    ycbcrDouble = reshape(rgbDouble,resolution(1)*resolution(2) , 3) * rgbToYcbcrMat;
    ycbcrDouble = reshape(ycbcrDouble, resolution(1),resolution(2), 3);
    y=im2uint8(ycbcrDouble(:,:,1));
    
    %-------/Luminance composition calculation/----------
    
    WyOfYi = weightY(y + 1);
    luminanceDenominator = luminanceDenominator + WyOfYi;
    luminanceNumerator = luminanceNumerator+ ( WyOfYi .* (gLuminance(y + 1)-dt(1,i)));
    
    %----------/cb Chrominance U composition/------------   
        Yi=ycbcrDouble(:,:,1);
        Cb=ycbcrDouble(:,:,2);   % for debugging
        Cr=ycbcrDouble(:,:,3);
    
    WySi = sqrt(Cb.*Cb + Cr.*Cr);
    WySi=WySi.^ (1.5);
    CuNumerator = CuNumerator + (WySi .^ ycbcrDouble(:,:,2));
    CuCvDenominator = CuCvDenominator + WySi;
    
    %--------/ cr Chrominace V composition /--------------
    
    CvNumerator = CvNumerator + (WySi .^ ycbcrDouble(:,:,3));
    %scaleFactor
    scaleFactorDenominator= scaleFactorDenominator + (WySi .* Yi );
    
end

hdr(:,:,1) = luminanceNumerator ./ luminanceDenominator;
hdr(:,:,2) = (CuNumerator ./ CuCvDenominator);
hdr(:,:,3) =(CvNumerator ./ CuCvDenominator);
 ytemp=exp(hdr(:,:,1));
 cUtemp=(CuNumerator ./ CuCvDenominator);
 cVtemp=(CvNumerator ./ CuCvDenominator);
%apply exponential to
hdr(:,:,1)= exp(hdr(:,:,1));
scaleFactor = (hdr(:,:,1).* CuCvDenominator) ./ scaleFactorDenominator ;

end



