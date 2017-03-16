function im_out=Iter_Shri(im,par,Arr,Wei)

[h w ch]   =   size(im); 
b          =   par.win;
b2         =   b*b;
k          =   0;
s          =   par.step;
 
N     =  h-b+1;
M     =  w-b+1;
r     =  [1:s:N];
r     =  [r r(end)+1:N];
c     =  [1:s:M];
c     =  [c c(end)+1:M];
X     =  zeros(b*b,N*M,'single');
X_m   =  zeros(b*b,length(r)*length(c),'single');
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        blk  =  im(i:h-b+i,j:w-b+j);
        X(k,:) =  blk(:)';            
    end
end
 
set      =   1:size(X_m,2);
 
for i = 1:par.nblk
   v            =  Wei(i,set);
   X_m(:,set)   =  X_m(:,set) + X(:, Arr(i, set)) .*v(ones(b2,1), :);
end 
 
ind         =   zeros(N,M);
ind(r,c)    =   1;
X           =   X(:, ind~=0);
 
N           =   length(r);
M           =   length(c);
L           =   N*M;
Y           =   zeros( b2, L );
 
 
tau         =   par.tau;
Y    =   par.KSVD_D*soft( par.KSVD_D'*X, tau );
  

% Output the processed image
im_out   =  zeros(h,w);
im_wei   =  zeros(h,w);
k        =  0;
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        im_out(r-1+i,c-1+j)  =  im_out(r-1+i,c-1+j) + reshape( Y(k,:)', [N M]);
        im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + 1;       
    end
end
 
im_out  =  im_out./(im_wei+eps);


