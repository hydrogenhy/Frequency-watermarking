function [tamperedCoeffs,res] = dct_decode(watered)
%     im = imread(tampered);
    im = imread(strcat(extractBefore(watered,"_"),'.bmp'));
    im1 = imread(watered);
    if (ndims(im) == 3)
        im = im(:, :, 1);
    end
    if (ndims(im1) == 3)
        im1 = im1(:, :, 1);
    end
    grayWateredImage = im1;
    grayTamperedImage = im;
    % 对篡改图像进行DCT变换
    waterCoeffs = dct2(grayWateredImage);
    tamperedCoeffs = dct2(grayTamperedImage);

    water_mark = imread('standard3.bmp');
    water_mark = im2double(water_mark);
    [r, c] = size(im);
    water_mark = imresize(water_mark, size(im));
    
%     disp(size(waterCoeffs))
%     disp(size(tamperedCoeffs))
    
    check = abs(waterCoeffs - tamperedCoeffs);
    thresh1 = graythresh(check);
    check = imbinarize(check, thresh1);
    MEAN = mean2(check);
    check0 = check;
    check(check0<MEAN) = 0;
    check(check0>MEAN) = 1;
    water_mark0 = water_mark;
    water_mark(water_mark0 < 0.5) = 0;
    water_mark(water_mark0 >= 0.5) = 1;
    
    figure(1);
    subplot(1, 3, 1)
    imshow(water_mark);
    title('原水印')
    subplot(1, 3, 2)
    imshow(check);
    title('解算水印')
    subplot(1, 3, 3)
    imshow(check ~= water_mark);
    title('差值')
    
%     disp(sum(sum(check ~= water_mark)))
%     disp(sum(sum(water_mark == 1)))
    if sum(sum(check ~= water_mark)) < r * c * 0.1
        res = 0;
    else
        res = 1;
    end
    
    tamperedCoeffs = log(abs(tamperedCoeffs));
end