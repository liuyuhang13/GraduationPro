%Superresolution_Main.m

clc;
clear;
addpath('KSVD_Matlab_ToolBox')

Test_image_dir='Data\SR_test_images';
psf=fspecial('gauss',7,1.6);
%psf =im2double(imread(sprintf('Data/SR_test_images/%s%s', 'test2_kernel', '.png')));
%psf = psf/sum(sum(psf));
scale=2;

image_name='test2.png';
Output_dir='Data\Result';

[im PSNR SSIM]=Image_Superresolution(psf,scale,Output_dir,Test_image_dir,image_name);
disp(sprintf('%s:PSNR=%3.2f SSIM=%f\n',image_name,PSNR,SSIM));
