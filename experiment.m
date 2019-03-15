% warning('off')
%--------------reading jpeg----------------
rgbImage=imread('data\original\desktop01\0003.jpg');
ycbImage=im2double(rgb2ycbcr(rgbImage));
y1=ycbImage(:,:,1);
c1=ycbImage(:,:,2);
c2=ycbImage(:,:,3);
ycbFormed= ycbcr2rgb(im2uint8(cat(3,yf,c1f,c2f)));
ycb2Formed= ycbcr2rgb(im2uint8(cat(3,y1,c1,c2)));

%this shit is working-----------------------
rgbDouble=im2double(rgbImage);
yf= 0.30*rgbDouble(:,:,1) + 0.59 * rgbDouble(:,:,2)+ 0.11 * rgbDouble(:,:,3);
c1f= -0.17 * rgbDouble(:,:,1) -0.33* rgbDouble(:,:,2)+ 0.50 *rgbDouble(:,:,3);
c2f= 0.50 * rgbDouble(:,:,1) + -0.42 * rgbDouble(:,:,2) -0.08 * rgbDouble(:,:,3);
%----------------------------bound------------------------

yghg=cat(3,yf,c1f,c2f);
figure
imshow(yghg);

%----------------matrix multiplication----------
rgbToYcbcrMat = [0.30,-0.17,0.50; 0.59, -0.33, -0.42; 0.11, 0.50, -0.08];
ycbcrToRgbMat = inv(rgbToYcbcrMat);
P = reshape(rgbDouble, 699392, 3) * rgbToYcbcrMat;
Result = reshape(P, 683, 1024, 3);
result1=Result(:,:,1);
result2=Result(:,:,2);
result3=Result(:,:,3);
figure
imshow(Result);

P = reshape(Result, 699392, 3) /rgbToYcbcrMat; % or * ycbcrToRgbMat
Result = reshape(P, 683, 1024, 3);
figure
imshow(Result);

%----------------matrix multiplication
% M = rand(numRows, numColumns, 3);
% T = rand(3, 3);





%--------------------------------------------
% m2=double(linspace(0,1,256));
% weig=zeros(256,3);
% weig(:,1)=m2;
% for i=1:256
%     weig(i,2) = weight(weig(i,1),2,2,0);
%     m2(i)=weig(i,2)*255;
% end
% weig(:,3)=m2;
% n = 1 ;  % play around with n
% %x=linspace(0,1,256);
% figure
% plot(weig(1:end-n,1),weig(1:end-n,2),'r-');
% hfline=refline(0,1);
% hfline.color='b';
%----------------checking resolution-------------
% dirName = ("URChapel");
% %readraw;
% [filenames, exposures, numExposures,resolution] = readDir(dirName);
% hdrMat=zeros(resolution);
%-----------------ReadingRaw---------------
%  tiffImage = Tiff('URChapel\DD.dng','r');
%  offsets = getTag(tiffImage,'SubIFD');
%  setSubDirectory(tiffImage,offsets(3));
%  [Y,Cb,Cr] = read(tiffImage);
 %imshow(Y);
 %imgr=read(tiffImage);
 %Cbb=im2double(Cb);
%YCbCr=uint8(cat(3,Y,Cb,Cr));
%  m1=uint8(linspace(1,256,256));
%  m2 = im2double(m1);
%  m3 = im2uint8(m2);
 
 

%  Y=im2double(Y);
%  Cb=im2double(Cb);
%  Cr=im2double(Cr);
%  saturation =sqrt(Cb.*Cb + Cr.*Cr);
 %imshow(ycbcr2rgb(YCbCr));
 
%------------------RGB to YUV-------------
% RGB=double(imread('sample.jpg'));
% R = RGB(:,:,1);
% G = RGB(:,:,2);
% B = RGB(:,:,3);
% 
% Y = 0.299 * R + 0.587 * G + 0.114 * B;
% U = -0.14713 * R - 0.28886 * G + 0.436 * B;
% V = 0.615 * R - 0.51499 * G - 0.10001 * B;
% imshow(Y);
% %imshow(U);
% YUV=uint8(cat(3,Y,U,V));
% %imshow(YUV);
% R = Y + 1.139834576 * V;
% G = Y -.3946460533 * U -.58060 * V;
% B = Y + 2.032111938 * U;
% 
% RGB = cat(3,R,G,B)./255;
% %imshow(RGB); 