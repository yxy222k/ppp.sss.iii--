function [outputArg,difa] = asmd(bulk,th,pm)
if pm ==1
    for i = 1:9
        im = fft2(bulk(:,:,i));
        im = fftshift(im);
        im(455,455) = 0;
        im = ifftshift(im);
        bulk(:,:,i) = ifft2(im);
    end
end
dif = zeros(889,889,36);

dif(:,:,1) = abs(bulk(:,:,1)-bulk(:,:,2));
dif(:,:,2) = abs(bulk(:,:,1)-bulk(:,:,3));
dif(:,:,3) = abs(bulk(:,:,1)-bulk(:,:,4));
dif(:,:,4) = abs(bulk(:,:,1)-bulk(:,:,5));
dif(:,:,5) = abs(bulk(:,:,1)-bulk(:,:,6));
dif(:,:,6) = abs(bulk(:,:,1)-bulk(:,:,7));
dif(:,:,7) = abs(bulk(:,:,1)-bulk(:,:,8));
dif(:,:,8) = abs(bulk(:,:,1)-bulk(:,:,9));
dif(:,:,9) = abs(bulk(:,:,2)-bulk(:,:,3));
dif(:,:,10) = abs(bulk(:,:,2)-bulk(:,:,4));
dif(:,:,11) = abs(bulk(:,:,2)-bulk(:,:,5));
dif(:,:,12) = abs(bulk(:,:,2)-bulk(:,:,6));
dif(:,:,13) = abs(bulk(:,:,2)-bulk(:,:,7));
dif(:,:,14) = abs(bulk(:,:,2)-bulk(:,:,8));
dif(:,:,15) = abs(bulk(:,:,2)-bulk(:,:,9));
dif(:,:,16) = abs(bulk(:,:,3)-bulk(:,:,4));
dif(:,:,17) = abs(bulk(:,:,3)-bulk(:,:,5));
dif(:,:,18) = abs(bulk(:,:,3)-bulk(:,:,6));
dif(:,:,19) = abs(bulk(:,:,3)-bulk(:,:,7));
dif(:,:,20) = abs(bulk(:,:,3)-bulk(:,:,8));
dif(:,:,21) = abs(bulk(:,:,3)-bulk(:,:,9));
dif(:,:,22) = abs(bulk(:,:,4)-bulk(:,:,5));
dif(:,:,23) = abs(bulk(:,:,4)-bulk(:,:,6));
dif(:,:,24) = abs(bulk(:,:,4)-bulk(:,:,7));
dif(:,:,25) = abs(bulk(:,:,4)-bulk(:,:,8));
dif(:,:,26) = abs(bulk(:,:,4)-bulk(:,:,9));
dif(:,:,27) = abs(bulk(:,:,5)-bulk(:,:,6));
dif(:,:,28) = abs(bulk(:,:,5)-bulk(:,:,7));
dif(:,:,29) = abs(bulk(:,:,5)-bulk(:,:,8));
dif(:,:,30) = abs(bulk(:,:,5)-bulk(:,:,9));
dif(:,:,31) = abs(bulk(:,:,6)-bulk(:,:,7));
dif(:,:,32) = abs(bulk(:,:,6)-bulk(:,:,8));
dif(:,:,33) = abs(bulk(:,:,6)-bulk(:,:,9));
dif(:,:,34) = abs(bulk(:,:,7)-bulk(:,:,8));
dif(:,:,35) = abs(bulk(:,:,7)-bulk(:,:,9));
dif(:,:,36) = abs(bulk(:,:,8)-bulk(:,:,9));
difa = sum(dif,3);
difb = difa;
difb(difa<th) = 0;
difb(difa>=th) = 1;
outputArg = difb;
end

