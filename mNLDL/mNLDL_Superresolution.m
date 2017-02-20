function [im_out PSNR SSIM psnr_array ssim_array]   =  mNLDL_Superresolution( par )

s           =   par.scale;
lr_im       =   par.LR;
[lh lw ch]  =   size(lr_im);
hh          =   lh*s;
hw          =   lw*s;
 
par.step    =   2;
par.tau     =   par.tau;
 
hrim        =   uint8(zeros(hh, hw, ch));
ori_im      =   zeros(hh,hw);
 
if  ch == 3
    lrim           =  rgb2ycbcr( uint8(lr_im) );
    lrim           =  double( lrim(:,:,1));
    
    b_im           =   imresize( lr_im, s, 'bicubic');
    b_im2          =   rgb2ycbcr( uint8(b_im) );
    hrim(:,:,2)    =   b_im2(:,:,2);
    hrim(:,:,3)    =   b_im2(:,:,3);
    
    if isfield(par, 'I')
        ori_im         =   rgb2ycbcr( uint8(par.I) );
        ori_im         =   double( ori_im(:,:,1));
    end
else
    lrim           =   lr_im;
    
    if isfield(par, 'I')
        ori_im             =   par.I;
    end
end
    
 
[hr_im,psnr_array,ssim_array]       =   Superresolution( lrim, par, ori_im );
 
if isfield(par,'I')
   [h w ch]  =  size(par.I);
   PSNR      =  csnr( hr_im(1:h,1:w), ori_im, 5, 5 );
   SSIM      =  cal_ssim( hr_im(1:h,1:w), ori_im, 5, 5 );
end
 
if ch==3
    hrim(:,:,1)  =  uint8(hr_im);
    im_out       =  double(ycbcr2rgb( hrim ));
else
    im_out  =  hr_im;
end
 
return;
 

function [hr_im,psnr_array,ssim_array]  = Superresolution( lr_im, par, ori_im )

hr_im     =   imresize( lr_im, par.scale, 'bicubic' );
[h   w]   =   size(hr_im);
[h1 w1]   =   size(ori_im);

y         =   lr_im;
lamada    =   par.lamada;
BTY       =   par.B'*y(:);
BTB       =   par.B'*par.B;

[Arr  Wei ArrLR  WeiLR ArrLLR  WeiLLR]    =    Multiscale_NL_means( hr_im, par );
S             =    @(x) Reconstruction_Func(x,par,Arr,Wei,ArrLR,WeiLR,ArrLLR,WeiLLR);
f             =    hr_im;

psnr_array  =  zeros(1,par.nIter);
ssim_array  =  zeros(1,par.nIter);

% par.tau = 0;  % For 2.1.08.bmp and the gaussian kernel add this code

for  iter = 1 : par.nIter

    f_pre    =  f;    
    
    % If use the gaussian kernel, the following code blocks if(iter==600)
    % par.tau=0; end should be included and if use the uniform kernel, this
    % code blocks should be deleted.
    if ( iter == 600 )
        par.tau = 0;
    end

    if (mod(iter, 10) == 0)          
        [Arr  Wei ArrLR  WeiLR ArrLLR  WeiLLR]    =    Multiscale_NL_means( f, par );
        S             =    @(x) Reconstruction_Func(x,par,Arr,Wei,ArrLR,WeiLR,ArrLLR,WeiLLR);
    end 

    f        =   f_pre(:);
    for i = 1:60
        f        =   f + lamada.*(BTY - BTB*f);
    end
    
    f    =  S( reshape(f, h,w) );
    
    if (mod(iter, 40) == 0)
        if isfield(par,'I')
            PSNR     =  csnr( f(1:h1,1:w1), ori_im, 5, 5 );
            fprintf( 'Preprocessing, Iter %d : PSNR = %f\n', iter, PSNR );
        end

%         dif       =  mean((f(:)-f_pre(:)).^2);
%         if (dif<par.eps && iter>=800) 
%             break; 
%         end            
    end

    psnr_array(iter)=csnr( f(1:h1,1:w1), ori_im, 5, 5 );
    ssim_array(iter)=cal_ssim( f(1:h1,1:w1), ori_im, 5, 5 );
end

f(f>255) = 255;
f(f<0) = 0;
hr_im   =  f;
fprintf('\n');    
