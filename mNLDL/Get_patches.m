function  [Py  Px]  =  Get_patches( im, b, s, psf )

[h w ch]  =  size(im);
ws        =  floor( size(psf,1)/2 );    %3

if  ch==3
    lrim      =  rgb2ycbcr( uint8(im) );    %还是把RGB转到亮度一个通道去处理
    im        =  double( lrim(:,:,1));    
end

lp_im     =  conv2( psf, im );
lp_im     =  lp_im(ws+1:h+ws, ws+1:w+ws);   %感觉这里边缘海是没有处理好，边缘一到两个像素是黑的，不知道是否有影响 
hp_im     =  im - lp_im;

N         =  h-b+1;
M         =  w-b+1;
r         =  [1:s:N];
r         =  [r r(end)+1:N];
c         =  [1:s:M];
c         =  [c c(end)+1:M];
L         =  length(r)*length(c);
Py        =  zeros(b*b, L);
Px        =  zeros(b*b, L);

k    =  0;
for i  = 1:b
    for j  = 1:b
        k       =  k+1;
        blk     =  hp_im(r-1+i,c-1+j);
        Py(k,:) =  blk(:)';
        
        blk     =  im(r-1+i,c-1+j);
        Px(k,:) =  blk(:)';        
    end
end
