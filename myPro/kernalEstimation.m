%kernalEstimation
%A simple implementation of the BlindS-R Algorithm

%% 利用给定模糊核模糊和降采样参考高分图来得到低分图并保存
TEST_IMAGE_DIR   =   'images';
OUTPUT_DIR = 'LR_images'
IMAGE_NAME = '2.1.05';
IMAGE_FORMAT = '.bmp';
DOWN_SAMPLE_FACTOR = 2;%降采样因子
I_H = im2double(imread(sprintf('%s/%s%s',TEST_IMAGE_DIR, IMAGE_NAME, IMAGE_FORMAT)));
Ground_truth_k = fspecial('gauss',9,2.5);
%低分辨率图像是高分辨率图像的模糊加降采样
I_L = Blur(I_H,Ground_truth_k);
I_L = I_L(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);

figure;%高分辨图与低分辨率图展示
subplot(1,3,1)
imshow(I_H);
title('I\_H')
subplot(1,3,2)
imshow(I_L);
title('I\_L')
subplot(1,3,3)
imshow(Ground_truth_k/Ground_truth_k(5,5));
title('Ground\_truth\_k');
fname = strcat(IMAGE_NAME,'_LR',IMAGE_FORMAT);
imwrite(I_L, fullfile(OUTPUT_DIR, fname));
%% 恢复模糊核
k_hat = fspecial('gauss',9,0.01);
I_LL = Blur(I_L,k_hat);
I_LL = I_LL(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);
figure;
imshow(I_LL);

