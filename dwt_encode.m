function [watermarkedCA, watermarked] = dwt_encode(x)
        originalImage = imread(x);
        if(ndims(originalImage)==3)
            grayImage=originalImage(:, :, 1);
        else
            grayImage = originalImage;
        end
        % 对原始图像进行DWT变换
        level = 1; % DWT变换的层数
        [cA, cH, cV, cD] = dwt2(grayImage, 'db1', level);
        % 生成水印图像
        water_mark = imread('standard3.bmp');
        water_mark = im2double(water_mark);
        water_mark = imresize(water_mark,size(cA));
        alpha = 0.1; % 水印强度调节参数
        watermarkedCA = cA + alpha * water_mark;
        watermarkedImage = idwt2(watermarkedCA, cH, cV, cD, 'db1');
        watermarkedImage = uint8(watermarkedImage);
        
        watermarked = originalImage;
        watermarked(:, :, 1) = watermarkedImage;        
        
end