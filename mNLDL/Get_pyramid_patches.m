function X=Get_pyramid_patches(par)

b=par.patch_size;%ͼ����С��6                                                           
s=4;                                                                       %������ʲô����            
delta=4.4;                                                                 %������ʲô����

X=zeros(0);
Y=zeros(0);
im=imresize(par.LR,par.scale,'bicubic');%
%B = imresize(A,scale) returns image B that is scale times the size of A. 
%The input image A can be a grayscale, RGB, or binary image. If scale is 
%from 0 through 1.0, B is smaller than A. If scale is greater than 1.0, B 
%is larger than A. By default, imresize uses bicubic interpolation.

[Y X]=Get_patches(im,b,s,par.psf);%im��LR��ֵ�õ���4���ֱ��ʵ�ͼ��          
%X��3Ϊ���������ͼ��飬Y�����ͼ��õ���ͼ��飬��֪��Ҫ����
dscale=linspace(1,par.scale,par.layer);
[h w]=size(par.LR);
for k=1:length(dscale)
    dh=round(h/dscale(k));
    dw=round(w/dscale(k));
    im=imresize(par.LR,[dh dw],'bicubic');                                  %�����Ҿ�������psf��Ҫ���С�ģ��������в㶼��ԭ���Ĵ�С�ɣ�
    [Py Px]=Get_patches(im,b,s,par.psf);    
    X=[X,Px];
    Y=[Y,Py];                                                               %X�ǽ�����ͼ��飬Y�ǽ�����ͼ����ȥģ����ͼ���
end

m=mean(Y);
d=(Y-repmat(m, size(Y,1), 1)).^2;
v=sqrt(mean(d));
[a,idx]=find(v>=delta);         %�ҵ�ĳЩֵ����delta���У�����һЩͼ���Ľű꣬��Щͼ��������󷵻صģ�Ҳ����˵��ͼ���仯�Ƚϴ�ģ�����ƽ̹��ͼ���
X=X(:,idx);
end