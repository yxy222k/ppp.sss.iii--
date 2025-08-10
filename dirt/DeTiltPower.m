function [ out ] = DeTiltPower( uwp, mask, para )


[X, Y] = find( mask==1 );
Z = uwp( mask==1 );
out1 = zeros(size(uwp));
X = normalize(X,'center','mean','scale','std');
Y = normalize(Y,'center','mean','scale','std');

if para ==1
    A = [sum(X.^2) sum(X.*Y) sum(X);
        sum(X.*Y) sum(Y.^2) sum(Y);
        sum(X) sum(Y) length(X)];
    B = [sum(X.*Z);sum(Y.*Z);sum(Z)];
    coef = A\B;
    out1(mask==1) = Z - coef(1)*X - coef(2)*Y - coef(3);
end

if para ==1.1
    A = [sum(X.^2) sum(X.*Y) sum(X);
        sum(X.*Y) sum(Y.^2) sum(Y);
        sum(X) sum(Y) length(X)];
    B = [sum(X.*Z);sum(Y.*Z);sum(Z)];
    coef = A\B;
    out1(mask==1) = Z - coef(1)*X - coef(2)*Y;
end

if para ==2 || para ==3
    pol1 = X.^2;
    pol2 = Y.^2;
    pol3 = X.*Y;
    pol4 = pol1 + pol2 ;
    A = [sum(pol4.^2) sum(X.*pol4) sum(Y.*pol4) sum(pol4);
        0 sum(X.^2) sum(pol3) sum(X);
        0 0 sum(Y.^2) sum(Y);
        0 0 0 length(X)];
    A = A+triu(A,1)';
    B = [sum(pol4.*Z);sum(X.*Z);sum(Y.*Z);sum(Z)];
    coef = A\B;
    if para ==2
        out1(mask==1) = Z - coef(1)*pol4;
    end
    if para ==3
        out1(mask==1) = Z - coef(1)*pol4 - coef(2)*X - coef(3)*Y -coef(4);
    end
end
% out = out1/4/pi;
out = out1;
end