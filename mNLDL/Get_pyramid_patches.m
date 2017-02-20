function X=Get_pyramid_patches(par)

b=par.patch_size;
s=4;
delta=4.4;

X=zeros(0);
Y=zeros(0);
im=imresize(par.LR,par.scale,'bicubic');
[Y X]=Get_patches(im,b,s,par.psf);
dscale=linspace(1,par.scale,par.layer);
[h w]=size(par.LR);
for k=1:length(dscale)
    dh=round(h/dscale(k));
    dw=round(w/dscale(k));
    im=imresize(par.LR,[dh dw],'bicubic');
    [Py Px]=Get_patches(im,b,s,par.psf);
    X=[X,Px];
    Y=[Y,Py];
end

m=mean(Y);
d=(Y-repmat(m, size(Y,1), 1)).^2;
v=sqrt(mean(d));
[a,idx]=find(v>=delta);
X=X(:,idx);