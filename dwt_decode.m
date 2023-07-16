function [tamperedLocations, res] = dwt_decode(watered)
%         im=imread(tampered);
        im = imread(strcat(extractBefore(watered,"_"),'_dwt.bmp'));
%         im = imread('lenna_dwt.bmp');
        im1=imread(watered);
        if(ndims(im)==3)
            im = im(:, :, 1);
        end
        if(ndims(im1)==3)
            im1 = im1(:, :, 1);
        end
        grayTamperedImage=im;
        grayWateredImage=im1;
        % 对篡改图像进行DWT变换
        level=1;
        [tCA, ~, ~, ~] = dwt2(grayTamperedImage, 'db1', level);
        [wCA, ~, ~, ~] = dwt2(grayWateredImage, 'db1', level);
        % 计算DWT系数之间的差异
        diffCA = abs(wCA - tCA);
        if(sum(sum(diffCA))<100)
            res=0;
            tamperedLocations = zeros(size(diffCA));
        else
            res=1;
        % 设置差异阈值，超过阈值则认为是篡改区域
        threshold = 20;
        % 标记出篡改位置
        tamperedLocations = diffCA > threshold;
        end
end