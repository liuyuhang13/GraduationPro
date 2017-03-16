function  Px  =  Get_patches( im, b, psf )
 
[h w ch]  =  size(im);
ws        =  floor( size(psf,1)/2 );
 
if  ch==3
    lrim      =  rgb2ycbcr( uint8(im) );
    im        =  double( lrim(:,:,1));    
end
  
N         =  h-b+1;
M         =  w-b+1;
s         =  4;
r         =  [1:s:N];
r         =  [r r(end)+1:N];
c         =  [1:s:M];
c         =  [c c(end)+1:M];
L         =  length(r)*length(c);
Px        =  zeros(b*b, L);
 
k    =  0;
for i  = 1:b
    for j  = 1:b
        k       =  k+1;
        blk     =  im(r-1+i,c-1+j);
        Px(k,:) =  blk(:)';        
    end
end
