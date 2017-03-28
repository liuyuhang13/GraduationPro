Test_image_dir   =   'images';
image_name = '2.1.01';
image_format = '.bmp';
scale = 2;
psf_name = 'gauss';
psf     =   fspecial(psf_name,13,1.6);%滤波器种类、大小、方差 'motion'
I = im2double(imread(sprintf('images/%s%s', image_name, image_format)));
%% 低分辨率图像由高分辨率图像经过psf模糊得到
%从参考图像获得原始模糊图像
blurred=Blur(I,psf);
LR=blurred(1:scale:end,1:scale:end,:);%低分辨率图像由高分辨率图像模糊+降采样得到
imwrite(psf/max(psf(:)),sprintf('images/psf/%s%s',psf_name,image_format));
imwrite(blurred, sprintf('images/%s_blurred%s', image_name, image_format));
imwrite(LR, sprintf('images/%s_LR%s', image_name, image_format));
imshow(psf/max(psf(:)));
%hw = size(psf);
%blurred(1:hw(1),1:hw(2))= psf/max(psf(:));
%imshow(blurred);