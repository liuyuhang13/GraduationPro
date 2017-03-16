function [im PSNR SSIM s_output]=Image_Superresolution(psf,scale,patch_size,layer,Output_dir,Test_image_dir,image_name,image_expandedname)
%% �������ó�ʼ��
par.tau=0.08;           %��������������ֵΪ0.08
par.lamada=7;           %���lamadaҲ��֪��ʲô��ֵ
par.scale=scale;
par.psf=psf;
par.nIter=120;%��������120����˹ģ����100�ε����Ժ�MSE�½�������
par.eps=2e-6;                                                               %�������Ŀǰ��֪��ʲô��˼��
par.nblk=5;                                                                 %ͼ������5
par.patch_size=patch_size;
par.layer=layer;

par.I=double(rgb2gray(imread(fullfile(Test_image_dir,strcat(image_name,image_expandedname)))));
%% �ͷֱ���ͼ���ɸ߷ֱ���ͼ�񾭹�psfģ���õ�
%�Ӳο�ͼ����ԭʼģ��ͼ��
LR=Blur(par.I,par.psf);
LR=LR(1:par.scale:end,1:par.scale:end,:);%�ͷֱ���ͼ���ɸ߷ֱ���ͼ��ģ��+�������õ�
%LR = par.I;
par.LR=LR;
%����˵��������������е�Low��...
%Ҳ������ô˵��Matlab�Ľ�����������ֵ�ģ�����ֱ�ӽ�������
%�õ��ڶ���ģ��ͼ��Ҳ����ԭʼģ��ͼ��Ľ�������ģ��
LLR=Blur(par.LR,par.psf);
LLR=LLR(1:par.scale:end,1:par.scale:end,:);
par.LLR=LLR;

par.B=Set_blur_matrix(par);                                                 %�������û�㶮�������ʲô
X=Get_pyramid_patches(par);         %�õ�LR��1.33��1.67��2������ͼ���,��Щͼ��鶼��һЩ��Եͼ��飬�仯�ϴ������ƽ̹��ûʲô��Ϣ��ͼ���
[par.KSVD_D,gamma,err]=Dictionary_train(X,par);%ֱ�����������Щͼ�������ֵ�ѵ����DΪ�ֵ䣬gamma��ϵ������
s_output.Dic=par.KSVD_D;
s_output.Dic_gamma=gamma;
s_output.Dic_err=err;
clear X;
[Q R]=grams(par.KSVD_D);                                                    %G-S��������Ҫ���
par.KSVD_D=Q;
s_output.Dic_AftGrams=par.KSVD_D;

[h w ch]  =  size(par.I);
%% һЩ���
% ԭʼ�ͷֱ���ͼ�����
pp='_LR';
fname=strcat(image_name,pp,image_expandedname);
imwrite(par.LR./255, fullfile(Output_dir, fname));
 
% ���ڽ���ֵ�õ��ĸ߷ֱ���ͼ�����
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

% ˫���β�ֵ
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
    
%������mNLDLd�ĺ��Ĳ�����
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