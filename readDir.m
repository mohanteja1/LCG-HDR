% Creates a list of all pictures and their exposure values and the general resolution of the image 
% in a certain directory.
%
% note: the files should be in dng format 
%      if this function doesnt show any of the values correctly then
%         display the imfinfo(image) and match the return values to tags in the info

function [filenames, exposures, numExposures,resolution] = readDir(dirName,imageType)
    
    fprintf('Opening the directory\n');
    fprintf('Opening test image\n');
    
    filenames = dir(strcat(dirName,imageType));
    disp(filenames(1));
    numExposures = length (filenames);
    disp(numExposures);
    exposures =zeros(1,numExposures);
    
    for i=1:numExposures
        imagePath= convertStringsToChars(filenames(i).folder + "\" + filenames(i).name);
        exposures(i) = exposureTimeOfImage(imagePath);
    end
    %disp(filenames(3).name);
    % then inverse to get descending sort order
%     exposures = exposures(end:-1:1);
%     filenames = filenames(end:-1:1);
    
    imagePath= convertStringsToChars(filenames(1).folder + "\" + filenames(1).name);
    resolution=sizeOfImage(imagePath);
end

function [timeOfExposure]= exposureTimeOfImage(imagePath)
%returns time of exposure for the given image
info = imfinfo(imagePath);
timeOfExposure=info.DigitalCamera.ExposureTime;
end

function [imageResolution]= sizeOfImage(imagePath)
%return size of image
% info = imfinfo(imagePath);
% imageResolution=[info.Height,info.Width,info.SamplesPerPixel];
im=imread(imagePath);
imageResolution=size(im);
end


    
    