%image is decomposed into lumuninance chrominance and gradient values 
%this module provides the functions for above values extraction.


%driver code 

imagesDecompositionFun("Artist Palette")


%-----------------functions------------------------------------

function []= imagesDecompositionFun(path)
%finding Raw image files in the given path directory
files = dir (strcat(path,'\*.NEF'));
L = length (files);
disp(L);
ti =zeros(1,L);
for i=1:L
   %ensure the path and the images we are reading
   disp(files(i).name);
   imagePath= convertStringsToChars(path+ '\' + files(i).name);
   disp(imagePath);
   imshow(path+'\'+files(i).name);
   
   %extract exposure time of each image
   ti(i)=exposureTimeOfImages(imagePath);
   disp(ti(i));
   
   %convert RGB to YCBCR 
   rgb=imread(imagePath);
   YCBCR = rgb2ycbcr(rgb);
   
   %components
   imshow(YCBCR(1,:,:));
   imshow(YCBCR(:,1,:));
   imshow(YCBCR(:,:,1));
   
   
   
   
end
end


function []=luminanceComponent()
 
end

function [ ]=chrominanceComponent()

end

function [Gmag,Gdir]=gradientComponent(image)
    [Gmag, Gdir] = imgradient(image,'prewitt');

end

function [saturationValue]=Saturation(chrominanceU,chrominanceV)
    saturationValue = ;
  
end

function [hueValue]=Hue(chrominanceU,chrominanceV)
    hueValue = atan(chrominanceU/chrominanceV);
end

function [timeOfExposure]=exposureTimeOfImages(imagePath)

info = imfinfo(imagePath);
timeOfExposure=info.DigitalCamera.ExposureTime;

end





    
 

