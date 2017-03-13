clear;close all;

for ker = 1: 12
    for img = 1: 4
        if ker>=8 && ker<=11
            mk = 141;nk = 141;
        else
            mk = 51;nk = 51;
        end
        t = clock;
        y = imread(sprintf('./images/Koehler_data/BlurryImages/Blurry%d_%d.png', img, ker));
        y = im2double(rgb2gray(y));
        [x, k] = blind_deblurring_all_levels(y, [mk, nk]);
        imwrite(k/max(k(:)), sprintf('./images/Koehler_data/result/kernel%d_%d.png', img, ker));
        imwrite(x, sprintf('./images/Koehler_data/result/SRSS_deconv%d_%d.png', img, ker));
        fprintf('deblur image %02d_%02d takes %f seconds\n', img, ker, etime(clock, t));
    end
end

for ker = 1: 12
    for img = 1: 4
        t = clock;
        y = imread(sprintf('./images/Koehler_data/BlurryImages/Blurry%d_%d.png', img, ker));
        k = imread(sprintf('./images/Koehler_data/result/kernel%d_%d.png', img, ker));
        y = im2double(y);
        k = im2double(k);
        k = k/sum(k(:));
        x = EPLL_deconv(y, k);
        imwrite(x, sprintf('./images/Koehler_data/result/EPLL_deconv%d_%d.png', img, ker));
        fprintf('deblur image %02d_%02d takes %f seconds\n', img, ker, etime(clock, t));
    end
end
