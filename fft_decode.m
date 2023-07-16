function [fftImage, res] = fft_decode(x)
    im = imread(x);
    if(ndims(im) == 3 )
        grayImage = im(:, :, 1);
    else
        grayImage = im;
    end
    ori_fftImage = fft2(grayImage);
    fftImage = log(ori_fftImage + 1);
    fftImage = fftshift(fftImage);
    
    water_mk = imread('standard3.bmp');
    [r_wm, c_wm] = size(water_mk);
    check = zeros([r_wm, c_wm]);
    check = real(fftImage(1:r_wm, 1:c_wm));
    check = (check - min(check(:))) ./ (max(check(:)) - min(check(:)));

    G=fspecial('gaussian', [50, 50], 100);
    img_gauss=imfilter(check,G,'replicate');
    MEAN = mean(check(:));
    check = check - img_gauss + MEAN;

    water_mk = (water_mk - min(water_mk(:))) ./ (max(water_mk(:)) - min(water_mk(:)));
    thresh1 = graythresh(check);
    check = imbinarize(check, thresh1);
    MEAN = mean2(check);
    check0 = check;
    check(check0<MEAN) = 1;
    check(check0>MEAN) = 0;
    
    figure(1);
    subplot(1, 3, 1)
    imshow(water_mk, []);
    title('原水印')
    subplot(1, 3, 2)
    imshow(check);
    title('解算水印')
    subplot(1, 3, 3)
    imshow(check ~= water_mk);
    title('差值')

    if sum(sum(check ~= water_mk)) < 128*128*0.2
        res = 0;
    else
        res = 1;
    end
     
end