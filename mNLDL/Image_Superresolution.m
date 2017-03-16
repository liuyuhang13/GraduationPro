function [im PSNR SSIM s_output]=Image_Superresolution(psf,scale,patch_size,layer,Output_dir,Test_image_dir,image_name,image_expandedname)
%% 参数设置初始化
par.tau=0.08;           %迭代收缩法中阈值为0.08
par.lamada=7;           %这个lamada也不知道什么阈值
par.scale=scale;
par.psf=psf;
par.nIter=120;%迭代次数120（高斯模糊核100次迭代以后MSE下降缓慢）
par.eps=2e-6;                                                               %这个参数目前不知道什么意思？
par.nblk=5;                                                                 %图像块个数5
par.patch_size=patch_size;
par.layer=layer;

par.I=double(rgb2gray(imread(fullfile(Test_image_dir,strcat(image_name,image_expandedname)))));
%% 低分辨率图像由高分辨率图像经过psf模糊得到
%从参考图像获得原始模糊图像
LR=Blur(par.I,par.psf);
LR=LR(1:par.scale:end,1:par.scale:end,:);%低分辨率图像由高分辨率图像模糊+降采样得到
%LR = par.I;
par.LR=LR;
%所以说这个降采样还是有点Low的...
%也不能这么说，Matlab的降采样是做插值的，这里直接降采样。
%得到第二层模糊图像，也就是原始模糊图像的降采样和模糊
LLR=Blur(par.LR,par.psf);
LLR=LLR(1:par.scale:end,1:par.scale:end,:);
par.LLR=LLR;

par.B=Set_blur_matrix(par);                                                 %这个函数没搞懂具体干了什么
X=Get_pyramid_patches(par);         %得到LR、1.33、1.67、2降采样图像块,这些图像块都是一些边缘图像块，变化较大而不是平坦的没什么信息的图像块
[par.KSVD_D,gamma,err]=Dictionary_train(X,par);%直接拿上面的这些图像块进行字典训练，D为字典，gamma是系数矩阵
s_output.Dic=par.KSVD_D;
s_output.Dic_gamma=gamma;
s_output.Dic_err=err;
clear X;
[Q R]=grams(par.KSVD_D);                                                    %G-S正交化是要干嘛？
par.KSVD_D=Q;
s_output.Dic_AftGrams=par.KSVD_D;

[h w ch]  =  size(par.I);
%% 一些输出
% 原始低分辨率图像输出
pp='_LR';
fname=strcat(image_name,pp,image_expandedname);
imwrite(par.LR./255, fullfile(Output_dir, fname));
 
% 最邻近插值得到的高分辨率图像输出
pp='_NN';
fname=strcat(image_name,pp,image_expandedname);
NNim=imresize(par.LR, par.scale, 'nearest');
imwrite(NNim./255, fullfile(Output_dir, fname));
if ch  ==  3
    I=rgb2ycbcr(uint8(par.I));
    I=double(I(:,:,1));
    NNim=rgb2ycbcr(uint8(NNim));
    NNim=double(NNim(:,:,1));
    PSNRNN=csnr( NNim(1:h,1:w), I, 5, 5 )
    SSIMNN=cal_ssim( NNim(1:h,1:w), I, 5, 5 )
else
    PSNRNN=csnr( NNim(1:h,1:w), par.I, 5, 5 )
    SSIMNN=cal_ssim( NNim(1:h,1:w), par.I, 5, 5 )
end

% 双三次插值
pp='_Bic';
fname=strcat(image_name,pp,image_expandedname);
Bicim=imresize(par.LR, par.scale, 'bicubic');
imwrite(Bicim./255, fullfile(Output_dir, fname));
[h w ch]  =  size(par.I);
if ch  ==  3
    I=rgb2ycbcr(uint8(par.I));
    I=double(I(:,:,1));
    Bicim=rgb2ycbcr(uint8(Bicim));
    Bicim=double(Bicim(:,:,1));
    PSNRBic=csnr( Bicim(1:h,1:w), I, 5, 5 )
    SSIMBic=cal_ssim( Bicim(1:h,1:w), I, 5, 5 )
else
    PSNRBic=csnr( Bicim(1:h,1:w), par.I, 5, 5 )
    SSIMBic=cal_ssim( Bicim(1:h,1:w), par.I, 5, 5 )
end
    
%这里是mNLDLd的核心部分了
pp='_mNLDL';
[im PSNR SSIM psnr_array ssim_array]=mNLDL_Superresolution( par );
s_output.reconstrucedimg_mnldl=im;
s_output.psnr_array=psnr_array;
s_output.ssim_array=ssim_array;
fname=strcat(image_name,pp,image_expandedname);
imwrite(im./255, fullfile(Output_dir, fname));

s_output.psnr_nn=PSNRNN;
s_output.psnr_bic=PSNRBic;
s_output.psnr_mnldl=PSNR;
s_output.ssim_nn=SSIMNN;
s_output.ssim_bic=SSIMBic;
s_output.ssim_mnldl=SSIM;
end