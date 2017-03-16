function [im_out PSNR SSIM]   =  Implement_Superresolution( par )

s           =   par.scale;
lr_im       =   par.LR;
[lh lw ch]  =   size(lr_im);
hh          =   lh*s;
hw          =   lw*s;
 
par.win     =   7;
par.step    =   3;
par.sigma   =   1.5;
par.h       =   hh;
par.w       =   hw;
par.tau     =   par.tau;
par.delta   =   4.5;
 
hrim        =   uint8(zeros(hh, hw, ch));
ori_im      =   zeros(hh,hw);
 
% RGB->YUV
%
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
    
 
hr_im       =   Superresolution( lrim, par, ori_im );
 
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
 
 
%----------------------------------------------------------------------
% The sparse approximation based image restoration
%
%----------------------------------------------------------------------
function hr_im  = Superresolution( lr_im, par, ori_im )
 
hr_im     =   imresize( lr_im, par.scale, 'bicubic' );
[h   w]   =   size(hr_im);
[h1 w1]   =   size(ori_im);
 
y         =   lr_im;
lamada    =   par.lamada;
BTY       =   par.B'*y(:);
BTB       =   par.B'*par.B;
Tau       =   zeros(0);
flag      =   0;

    
   
        
N            =   Compute_NLM_Matrix( hr_im, 5, par );
NTN          =   N'*N*par.lam_NL;


[Arr  Wei]    =    find_blks( hr_im, par );
S             =    @(x) Iter_Shri(x,par,Arr,Wei);
f             =    hr_im;

for  iter = 1 : par.nIter

    f_pre    =  f;      

    if (iter== 300 || iter==600)          
        N            =   Compute_NLM_Matrix( f, 5, par );                
        NTN          =   N'*N*par.lam_NL;
        [Arr  Wei]   =    find_blks( f, par );
        S            =    @(x) Iter_Shri(x,par,Arr,Wei);                 
    end            

    f        =   f_pre(:);
    for i = 1:5
        f        =   f + lamada.*(BTY - BTB*f);
    end

    f         =  f  - NTN*f_pre(:);      
    f    =  S( reshape(f, h,w) );


    if (mod(iter, 40) == 0)
        if isfield(par,'I')
            PSNR     =  csnr( f(1:h1,1:w1), ori_im, 5, 5 );
            fprintf( 'Preprocessing, Iter %d : PSNR = %f\n', iter, PSNR );
        end

        dif       =  mean((f(:)-f_pre(:)).^2);
        if (dif<par.eps && iter>=800) 
            break; 
        end            
    end

end
hr_im   =  f;
fprintf('\n');    

 
