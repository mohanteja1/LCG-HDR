function w = lcgWeight(pixelValue, alpha, beta,CamOrY)
 % calculates weight given  w = p^a * (1-p)^b 
 % for Wcam function CamOrY = 1
 % for Wy function CamOrY =0
 if CamOrY==1
   w = 17.6 *( pixelValue ^ alpha * ((1-pixelValue)^beta));
 else
   w= 63.5 *( pixelValue ^ alpha * ((1-pixelValue)^beta));
 end
 
 % fprintf("p:%f ,w:%f\n",pixelValue,w);
    