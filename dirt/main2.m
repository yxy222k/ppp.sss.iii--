% Matlab 2023b
% if you find a '%' followed by number, it means the number(parameter) 
% needs tuning when dealing with different datasets. So when it comes to 
% practical scenario, better prepare a slider for it. 
% yxy222k@gmail.com

close all
clear;clc

sd = 889;
cz = zeros(sd,sd,9);    %constZeros, preserve
bulk = cz;  % where all origImg stored
blrb = cz;  % blurred oriImg     
for i = 1:9
    im = double(imread([num2str(i-1), '.png']));
    bulk(:,:,i) = im(41:929,195:1083);
    blrb(:,:,i) = twoSigma(bulk(:,:,i),5,1);
end
constbulk = bulk;   % preserve

%contrast adjusting, should be of some use, not found yet
% ys = zeros(sd,sd,9);  
% for i = 1:9
%     ys(:,:,i) = log2(blrb(:,:,i)*.95);
% end

[maskCircle,maskCrop] = crtMask(bulk,.985,.24);
suma = sum(blrb,3);
constsuma = suma;
maskdif = asmd(bulk,699,0);     % 699
%%

maskim1 = maskdif.*maskCrop;
figure;imshow(maskim1)

se = strel('square', 19);    % morphological processing, for guiding, it's ok using big para, won't pollute origImg.
maskim2 = imerode(maskim1, se);

[~, zploy, zcoef] = Zernike_36_RMS_5(suma, maskim2);    % zploy: Zernike polynomials, zcoef: ...
surf1 = zeros(sd,sd);
for i = 1:36    % 36
    surf1 = zploy(:,:,i).*zcoef(i) + surf1;
end
suma(maskim2 == 0) = NaN;
surf1(maskim2 == 0) = NaN;
figure;mesh(surf1)
hold on
mesh(suma)
surf1 = restoreHoles(surf1,maskim1);    %something wrong because ..., redoing solves
surf1 = restoreHoles(surf1,maskim1);

difsuma = constsuma - surf1;

refMap = maskCircle;

for i = 1:sd
    for j = 1:sd
        if difsuma(i,j)>280     % 282
            refMap(i,j) = 0;
        end
    end
end
bulk1 = constbulk.*refMap;
se = strel('disk',5);
refMapE = imerode(refMap,se);
mask = refMapE.*maskim1;

dof = constbulk.*mask;
blrdof = cz;
for i = 1:9
    blrdof(:,:,i) = twoSigma(dof(:,:,i),5,1);
    blrdof(:,:,i) = twoSigma(blrdof(:,:,i),5,2);
end

% Here, averaging process is conducted by picking each four adjecent imgs,
% and performing unwrap with them. Then do averaging from six derived wavefronts.
% Time&space clumsy, a better way can be tried out easily.
FringeResult = zeros(sd,sd,6); 
for i = 1:6
    bufferr = blrdof(:,:,i:i+3);
    wp = PhaseExtracting(bufferr,12);
    max_box_radius = 1;
    residue_charge = PhaseResidues(wp);
    branch_cuts=BranchCuts(residue_charge, max_box_radius, mask);
    [IM_unwrapped] = FloodFill(wp, branch_cuts);
    FringeResult(:,:,i) = IM_unwrapped/4/pi;
end
FringeResultp = 1/6*(FringeResult(:,:,1)+FringeResult(:,:,2)+FringeResult(:,:,3)+FringeResult(:,:,4)+FringeResult(:,:,5)+FringeResult(:,:,6));
FringeResultp1 = DeTiltPower(FringeResultp,mask,3);
FringeResultp1(mask == 0) = NaN;
figure;imshow(FringeResultp1,[])
FringeResultp11 = twoSigma(FringeResultp1,7,1);
figure;mesh(FringeResultp11)
figure;imshow(FringeResultp11,[])