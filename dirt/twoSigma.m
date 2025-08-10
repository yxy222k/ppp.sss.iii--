function [out] = twoSigma(origImg, WindowSize,para)

%%%%%%%%%%%%%%%%%%%origImg should have odd size%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%uninterested point in origImg needs setting NaN%%%%%%%%%%%%%%%%%%
%   this function is similar to SpikeHeight(zygo)
%   2 Sigma uses data points that are within two times the rms value
%   in each window and disregards data values that outranges.

%   it is possible to return a graph with 2-sigma spikes removed, 
%   but the elements within the window have been disrupted, and 
%   the complexity of implementing this in the function is higher than rewriting it.
%   the function already removes spikes during the filtering process.
%   However, if the spike removal window is too small, the effect will 
%   not be satisfactory. Therefore, the minimum window size for spike removal
%   should be restricted. Add a judgment: if the window size is smaller than 7 (e.g., 3), 
%   first perform spike removal with a window size of 7, and then conduct filtering with a window size of 3.
[m, ~] = size(origImg);
k = WindowSize;
kp = (k - 1)/2;
cache = zeros(m + 2*kp, m + 2*kp);  % add a surrounding augmentation layer to prevent the window from going out of bounds.
cache(kp + 1:kp + m, kp + 1:kp + m) = origImg;
cachep(kp + 1:kp + m, kp + 1:kp + m) = origImg;
mark = zeros(m,m);
for i = kp + 1:kp + m
    for j = kp + 1:kp + m
        if isnan(origImg(i-kp,j-kp))
            continue
        end
        cacheVector = reshape(cache(i - kp:i + kp, j - kp:j + kp), [], 1);   % convert the matrix into a vector to facilitate calculations.
        cacheVector = sort(cacheVector);
        vs = numel(cacheVector) - numel(find(isnan(cacheVector)));
        cacheVector1 = cacheVector(1:vs,1);
        Th = 2*rms(cacheVector1);  % reason that this function is called 'Two...'
        bi = 0;
        for x = 1:vs  % discard values outside the range of twice the rms
            if abs(cacheVector1(x)) > Th
                cacheVector1(x) = NaN;
                vs = vs - 1;
                bi = bi+1;
            end
        end
        mark(i - kp, j - kp) = bi;
        cacheVector2 = sort(cacheVector1);
        if mod(vs-bi,2) ~= 1        % in case of vector turns even after de-NaN & de-twoSigma
            cacheVector2(vs-bi+1,1) = cacheVector2(vs/2-bi/2,1);
            vs = vs + 1;
            cacheVector2 = sort(cacheVector2);
        end
        cacheVector2 = cacheVector2(1:vs-bi,1);
        if para == 1    % med
            cachep(i,j) = cacheVector2(1/2+vs/2-bi/2);
        end
        if para == 2    % average
            cachep(i,j) = sum(cacheVector2)/(vs-bi);
        end
    end
end
% figure(100);imshow(mark,[])
out = cachep(kp + 1:kp + m, kp + 1:kp + m);