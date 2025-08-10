 function [out] = PhaseExtracting(cell,para)
%相位主值提取函数，仅适用于不多于五帧条纹图的移相。
%   输出的out为包裹相位，cell是存有五帧干涉条纹图的元胞。
%   para为1，采用的是常规五步相位提取算法，移相量为pi/2，公式由理想五幅干涉条纹图公式导出。
%   参考Malacara著《光学车间检测》第三版P427。
%   para为2，采用的是线性相移误差不敏感四帧算法，参考惠梅著《微观形貌测量技术》P65。
%   para为3，卡雷算法（未实现）
%   para为4，
%   para为5，
%   para为6，三步算法
%   para为7，四步算法
%   para为8，Stoilov算法

    if para==1
        out = atan2(2*(cell{4} - cell{2}), (cell{1} - 2*cell{3} + cell{5}));
    end

    if para==2
        out = -atan2(3*cell{2} - (cell{1} + cell{3} + cell{4}), ...
            cell{1} + cell{2} + cell{4} - 3*cell{3});
    end
    if para==12
        out = -atan2(3*cell(:,:,2) - (cell(:,:,1) + cell(:,:,3) + cell(:,:,4)), ...
            cell(:,:,1) + cell(:,:,2) + cell(:,:,4) - 3*cell(:,:,3));
    end

    if para==3  %需要额外判据
        r1 = cell{2} - cell{3};
        r2 = cell{1} - cell{4};
        r3 = (3*r1 - r2).*(r1 + r2);
        r3(r3<0) = -r3(r3<0);
        r4 = cell{2} + cell{3} - cell{1} - cell{4};
        r5 = sqrt(r3);
        out = atan2(r5, r4);
    end

    if para==4
        out = atan2(sqrt(3)*(cell{1} - 2*cell{2} + 2*cell{3} - cell{4}), ...
            cell{1} - 2*cell{3} + 3*cell{4} - 2*cell{5});
    end

    if para==5
        out = atan2(sqrt(sqrt((2*(cell{4} - cell{2}) + cell{1} - cell{5}).*(2*(cell{4} - cell{2}) - cell{1} + cell{5}))), ...
                cell{1} - 2*cell{3} + cell{5}); 
    end

    if para==6
        out = atan2(cell{1} - cell{3}, 2*cell{2} -cell{1} - cell{3});
    end

    if para==7
        out = atan2(cell{2} - cell{4}, cell{3} - cell{1});
    end
    
    if para==8
        bb = 1 - 0.25*(  (cell{1} - cell{5})./(cell{2} - cell{4})  ).^2;
        bb(bb<0) = 0.8;
        cc = sqrt(bb);
        out = atan2(2*(cell{2} - cell{4}).*cc, 2*cell{3} - cell{1} - cell{5});
    end
    
    if para==9
        out = atan2(cell{1} - 4*cell{2} + 4*cell{4} - cell{5}, cell{1} + 2*cell{2} - 6*cell{3} + 2*cell{4} + cell{5});
    end

    if para==10
        out = atan2(3*cell{1} - 6*cell{2} + 4*cell{3} - 2*cell{4} + cell{5}, 2*cell{1} + 2*cell{2} - 3*cell{3} + 2*cell{4} - 2*cell{5});
    end

    if para==11
        out = atan2(cell{1} - 2*cell{2} + 2*cell{4} - cell{5}, 2*cell{2} - 4*cell{3} + 2*cell{4});
    end

end