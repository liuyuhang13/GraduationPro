function [im PSNR SSIM]=Image_Superresolution(psf,scale,Output_dir,Test_image_dir,image_name)

par.lam_NL=0.04;
par.tau=0.08;
par.c1=0.7;
par.lamada=5.5;
par.scale=scale;
par.psf=psf;
par.nIter=120;
par.eps=2e-6;
par.nblk=10;

par.I=double(rgb2gray(imread(fullfile(Test_image_dir,image_name))));
LR=Blur(par.I,par.psf);
LR=LR(1:par.scale:end,1:par.scale:end,:);
par.LR=LR;
par.B=Set_blur_matrix(par);
par.KSVD_D=Dictionary_Training(par);
[Q R]=grams(par.KSVD_D);
par.KSVD_D=Q;

pp            =   'LR_';
fname         =    strcat(pp, image_name);
imwrite(par.LR./255, fullfile(Output_dir, fname));
 
pp           =   'NN_';
fname        =   strcat(pp, image_name);
NNim         =   imresize(par.LR, par.scale, 'nearest');
imwrite(NNim./255, fullfile(Output_dir, fname));
[h w ch]  =  size(par.I);
if ch  ==  3
    I    =  rgb2ycbcr(uint8(par.I));
    I    =  double(I(:,:,1));
    NNim =  rgb2ycbcr(uint8(NNim));
    NNim =  double(NNim(:,:,1));
    PSNRNN      =  csnr( NNim(1:h,1:w), I, 5, 5 )
    SSIMNN      =  cal_ssim( NNim(1:h,1:w), I, 5, 5 )
else
    PSNRNN      =  csnr( NNim(1:h,1:w), par.I, 5, 5 )
    SSIMNN      =  cal_ssim( NNim(1:h,1:w), par.I, 5, 5 )
end

pp           =   'Bic_';
fname        =   strcat(pp, image_name);
Bicim         =   imresize(par.LR, par.scale, 'bicubic');
imwrite(Bicim./255, fullfile(Output_dir, fname));
[h w ch]  =  size(par.I);
if ch  ==  3
    I     =  rgb2ycbcr(uint8(par.I));
    I     =  double(I(:,:,1));
    Bicim =  rgb2ycbcr(uint8(Bicim));
    Bicim =  double(Bicim(:,:,1));
    PSNRBic      =  csnr( Bicim(1:h,1:w), I, 5, 5 )
    SSIMBic      =  cal_ssim( Bicim(1:h,1:w), I, 5, 5 )
else
    PSNRBic      =  csnr( Bicim(1:h,1:w), par.I, 5, 5 )
    SSIMBic      =  cal_ssim( Bicim(1:h,1:w), par.I, 5, 5 )
end
    
 
[im PSNR SSIM]   =   Implement_Superresolution( par );
fname            =   strcat('SR_', image_name);
imwrite(im./255, fullfile(Output_dir, fname));
