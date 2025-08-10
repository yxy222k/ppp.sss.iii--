function  out = restoreHoles(surf,mask)

%   can optimize
surf(isnan(surf)) = 0;  % maybe 0 needs changing to some impossible integer to avoid bug
for i = 1:889
    for j = 1:889
        if surf(i,j) == 0 && mask(i,j) == 1
            surf(i,j) = surf(i,j-1);
        end
    end
end
for i = 1:889
    for j = 1:889
        if surf(i,j) == 0 && mask(i,j) == 1
            surf(i,j) = surf(i-1,j);
        end
    end
end
surfim =rot90(surf,2);
maskim11 = rot90(mask,2);
for i = 1:889
    for j = 1:889
        if surfim(i,j) == 0 && maskim11(i,j) == 1
            surfim(i,j) = surfim(i,j-1);
        end
    end
end
for i = 1:889
    for j = 1:889
        if surfim(i,j) == 0 && maskim11(i,j) == 1
            surfim(i,j) = surfim(i-1,j);
        end
    end
end
out = rot90(surfim,2);
end

