function [mask1, mask2, mask3, mask4] = crtMask(ip, scale, th3, th4, th5)

% crtMask: create masks
% ip: input pictures, which should have odd size m, and include n pictures
% scale: needed to calculate mask2
% th3: thresh hold needed to calculate mask3
% th4: needed to calculate mask4
% th5: needed to calculate mask5
% mask1: a circle contact to picture size
% mask2: a circle cropped by 'scale' from mask1
% mask3: mask calculated by modulation coefficient
% mask4: mask derived by substration
% mask5: mask derived by adding

[m,~,n] = size(ip);

% mask1 & mask2 

mask1 = zeros(m,m);
mask2 = zeros(m,m); 
[X,Y] = find(mask1 == 0);
x = normalize(X,'center')/(m-1)*2;
y = normalize(Y,'center')/(m-1)*2;
mask1(mask1 == 0) = ceil(-x.*x - y.*y + 1^2);
mask2(mask2 == 0) = ceil(-x.*x - y.*y + scale^2);

% mask3

% mc = zeros(m,m,n-3);
% for i = 1:n-3
%     mc(:,:,i) = 2*sqrt((ip(:,:,i+3) - ip(:,:,i+1)).^2 + (ip(:,:,i) - ip(:,:,i+2)).^2)./(ip(:,:,i)+ip(:,:,i+1)+ip(:,:,i+2)+ip(:,:,i+3));
% end
% masks = zeros(m,m,n-3);
% for i = 1:n-3
%     masks(:,:,i)=mask;
%     im = masks(:,:,i);
%     im(mc(:,:,i)<th3) = 0;
%     masks(:,:,i) = im;
% end
% mask3 = ~(~masks(:,:,1)+~masks(:,:,2)+~masks(:,:,3)+~masks(:,:,4)+~masks(:,:,5)+~masks(:,:,6)); %%%%%%%%
% mask3(mask3~=0) = 1;

