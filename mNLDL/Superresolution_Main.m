%Superresolution_Main.m

%clc;
clear;
%for i=1
tic;

Test_image_dir   =   'Data\Test_images';
psf     =   fspecial('gauss',7,1.6);%滤波器种类、大小、方差
% psf     =   ones(7)/49;
scale   =   2;%降采样因子取2
layer   =   4;         %四层金字塔？
patch_size   =   6;%图像块大小6*6

%image_name   =   strcat('2.1.0',num2str(i));
image_name   =  '2.1.01';

image_expandedname   =   '.bmp';
Output_dir   =   'Data\Result_images';

[im PSNR SSIM s_output]  =  Image_Superresolution(psf,scale,patch_size,layer,Output_dir,Test_image_dir,image_name,image_expandedname);
disp(sprintf('%s:PSNR=%f SSIM=%f\n',image_name,PSNR,SSIM));

tElapsed              =   toc;
s_output.psf          =   psf;
s_output.scale        =   scale;
s_output.layer        =   layer;
s_output.patch_size   =   patch_size;
s_output.filename     =   strcat(image_name,image_expandedname);
s_output.runtime      =   tElapsed;

save(fullfile(Output_dir,strcat(image_name,'_store_output_mNLDL.mat')),'s_output');

%end