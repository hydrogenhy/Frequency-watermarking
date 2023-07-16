function [water_mark_f, water_marked] = fft_encode(x)
    originalImage = imread(x);
    if(ndims(originalImage) == 3 )
        r = originalImage(:,:,1);
        g = originalImage(:,:,2);
        b = originalImage(:,:,3);
        grayImage = rgb2gray(originalImage);
        % 对原始图像进行FFT变换
        ori_fftImage = fft2(r);
        fftImage = log(ori_fftImage + 1);
        fftImage = fftshift(fftImage);
        % 生成水印图像
        water_mark = imread('standard3.bmp');
        water_mark = im2double(water_mark);
        [r_wm, c_wm] = size(water_mark);
        [r, c] = size(grayImage);
        tmp = fftImage(1:r_wm, 1:c_wm);
        water_mark1 = zeros(size(water_mark));
        water_mark1(water_mark < 0.5) = tmp(water_mark < 0.5);
        water_mark2 = rot90(water_mark1, 2);
        % 将水印图像嵌入到FFT系数中
        water_mark_f = fftImage;
        water_mark_f(1:r_wm, 1:c_wm) = water_mark;
        water_mark_f(1:r_wm, 1:c_wm) = water_mark1;
        water_mark_f(r-r_wm + 1:r, c-c_wm+1:c) = water_mark2;
        r_after = ifft2(exp(ifftshift(water_mark_f)) - 1);
        
        water_marked = zeros(size(originalImage));
        water_marked(:, :, 1) = real(r_after);
        water_marked(:, :, 2) = g;
        water_marked(:, :, 3) = b;       
        
    else
        grayImage = originalImage;
        % 对原始图像进行FFT变换
        ori_fftImage = fft2(grayImage);
        fftImage = log(ori_fftImage + 1);
        fftImage = fftshift(fftImage);
        % 生成水印图像
        water_mark = imread('standard3.bmp');
        water_mark = im2double(water_mark);
        [r_wm, c_wm] = size(water_mark);
        [r, c] = size(grayImage);
        tmp = fftImage(1:r_wm, 1:c_wm);
        water_mark1 = zeros(size(water_mark));
        water_mark1(water_mark < 0.5) = tmp(water_mark < 0.5);
        water_mark2 = rot90(water_mark1, 2);
        % 将水印图像嵌入到FFT系数中
        water_mark_f = fftImage;
        water_mark_f(1:r_wm, 1:c_wm) = water_mark1;
        water_mark_f(r-r_wm + 1:r, c-c_wm+1:c) = water_mark2;
        water_marked = zeros(size(originalImage));
        water_marked = ifft2(exp(ifftshift(water_mark_f)) - 1);
    end
end