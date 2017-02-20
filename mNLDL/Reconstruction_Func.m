function im_out=Reconstruction_Func(im,par,Arr,Wei,ArrLR,WeiLR,ArrLLR,WeiLLR)

[h w]   =   size(im); 
b          =   par.patch_size;
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

lr_im     =   par.LR;
N_l       =  size(lr_im,1)-b+1;
M_l       =  size(lr_im,2)-b+1;
r_l       =  [1:s:N_l];
r_l       =  [r_l r_l(end)+1:N_l];
c_l       =  [1:s:M_l];
c_l       =  [c_l c_l(end)+1:M_l];
X_l       =  zeros(b*b, N_l*M_l, 'single');
X_m_l     =  zeros(b*b,length(r)*length(c),'single');
k   =   0;
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        blk  =  lr_im(i:end-b+i,j:end-b+j);
        X_l(k,:) =  blk(:)';            
    end
end

llr_im     =   par.LLR;
N_ll       =  size(llr_im,1)-b+1;
M_ll       =  size(llr_im,2)-b+1;
r_ll       =  [1:s:N_ll];
r_ll       =  [r_ll r_ll(end)+1:N_ll];
c_ll       =  [1:s:M_ll];
c_ll       =  [c_ll c_ll(end)+1:M_ll];
X_ll       =  zeros(b*b, N_ll*M_ll, 'single');
X_m_ll     =  zeros(b*b,length(r)*length(c),'single');
k   =   0;
for i  = 1:b
    for j  = 1:b
        k    =  k+1;
        blk  =  llr_im(i:end-b+i,j:end-b+j);
        X_ll(k,:) =  blk(:)';            
    end
end

set      =   1:size(X_m,2);
for i = 1:par.nblk
   v              =  Wei(i,set);
   X_m(:,set)     =  X_m(:,set) + X(:, Arr(i, set)) .*v(ones(b2,1), :);
   v              =  WeiLR(i,set);
   X_m_l(:,set) =  X_m_l(:,set) + X_l(:, ArrLR(i, set)) .*v(ones(b2,1), :);
   v              =  WeiLLR(i,set);
   X_m_ll(:,set) =  X_m_ll(:,set) + X_ll(:, ArrLLR(i, set)) .*v(ones(b2,1), :);
end
X_m  =  0.6*X_m + 0.3*X_m_l + 0.1*X_m_ll;
 
ind         =   zeros(N,M);
ind(r,c)    =   1;
X           =   X(:, ind~=0);
X           =   X  -  X_m;
 
N           =   length(r);
M           =   length(c);
L           =   N*M;
Y           =   zeros( b2, L );
 
 
tau         =   par.tau;
Y    =   par.KSVD_D*soft( par.KSVD_D'*X, tau ) + X_m;
  
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


