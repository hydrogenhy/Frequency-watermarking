function [watermarked_f, watermarkedImage] = dct_encode(x)
    originalImage = imread(x);
    if(ndims(originalImage) == 3 )
        grayImage = originalImage(:, :, 1);
    else
        grayImage = originalImage;
    end
    % 对原始图像进行DCT变换
    dctCoeffs = dct2(grayImage);
    % 生成水印图像
    water_mark = imread('standard3.bmp');
    water_mark = im2double(water_mark);
    water_mark = imresize(water_mark, size(dctCoeffs));
    alpha = 0.1; % 水印强度调节参数
    watermarkedCoeffs = dctCoeffs + alpha * water_mark;
    % 对水印后的系数进行逆DCT变换
    watermarkedImage_r = idct2(watermarkedCoeffs);
    watermarkedImage_r = uint8(watermarkedImage_r);
    watermarkedImage = originalImage;
    watermarkedImage(:, :, 1) = watermarkedImage_r;
    watermarked_f = log(abs(watermarkedCoeffs)); % 返回水印后的系数
end
