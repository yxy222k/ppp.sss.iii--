function [out] = mRMS(cur1,cur2,mask)

cur1(isnan(cur1))=0;
cur2(isnan(cur2))=0;
mask(isnan(mask))=0;

subsum = cur1(mask==1);
subsump = cur2(mask==1);
sum2 = (subsump - subsum).^2;
out = sqrt(sum(sum2)/length(subsum));