function X=Get_pyramid_patches(par)

b=par.patch_size;%图像块大小：6                                                           
s=4;                                                                       %不明白什么参数            
delta=4.4;                                                                 %不明白什么参数

X=zeros(0);
Y=zeros(0);
im=imresize(par.LR,par.scale,'bicubic');%
%B = imresize(A,scale) returns image B that is scale times the size of A. 
%The input image A can be a grayscale, RGB, or binary image. If scale is 
%from 0 through 1.0, B is smaller than A. If scale is greater than 1.0, B 
%is larger than A. By default, imresize uses bicubic interpolation.

[Y X]=Get_patches(im,b,s,par.psf);%im是LR插值得到的4倍分辨率的图像          
%X是3为间隔采样的图像块，Y是误差图像得到的图像块，不知道要干嘛
dscale=linspace(1,par.scale,par.layer);
[h w]=size(par.LR);
for k=1:length(dscale)
    dh=round(h/dscale(k));
    dw=round(w/dscale(k));
    im=imresize(par.LR,[dh dw],'bicubic');                                  %所以我觉得这里psf是要变大小的，不能所有层都用原来的大小吧？
    [Py Px]=Get_patches(im,b,s,par.psf);    
    X=[X,Px];
    Y=[Y,Py];                                                               %X是降采样图像块，Y是降采样图像块减去模糊后图像块
end

m=mean(Y);
d=(Y-repmat(m, size(Y,1), 1)).^2;
v=sqrt(mean(d));
[a,idx]=find(v>=delta);         %找到某些值大于delta的列，就是一些图像块的脚标，这些图像块就是最后返回的，也就是说找图像块变化比较大的，不是平坦的图像块
X=X(:,idx);
end