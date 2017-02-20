function [blk_arr, wei_arr, blk_arr_lr, wei_arr_lr, blk_arr_llr, wei_arr_llr]  =  Multiscale_NL_means(im, par)
 
S         =  25;
S_l       =  13;
S_ll      =  7;
f         =  par.patch_size;
f2        =  f^2;
nv        =  par.nblk;
s         =  par.step;
hp        =  75;
 
N         =  size(im,1)-f+1;
M         =  size(im,2)-f+1;
r         =  [1:s:N];
r         =  [r r(end)+1:N];
c         =  [1:s:M];
c         =  [c c(end)+1:M];
L         =  N*M;
X         =  zeros(f*f, L, 'single');

N_l       =  size(par.LR,1)-f+1;
M_l       =  size(par.LR,2)-f+1;
L_l       =  N_l*M_l;
X_l       =  zeros(f*f, L_l, 'single');

N_ll       =  size(par.LLR,1)-f+1;
M_ll       =  size(par.LLR,2)-f+1;
L_ll       =  N_ll*M_ll;
X_ll       =  zeros(f*f, L_ll, 'single');
 
% For the Y component
k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  im(i:end-f+i,j:end-f+j);
        X(k,:) =  blk(:)';
    end
end

k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  par.LR(i:end-f+i,j:end-f+j);
        X_l(k,:) =  blk(:)';
    end
end

k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  par.LLR(i:end-f+i,j:end-f+j);
        X_ll(k,:) =  blk(:)';
    end
end
 
% Index image
I     =   (1:L);
I     =   reshape(I, N, M);
N1    =   length(r);
M1    =   length(c);
blk_arr   =  zeros(nv, N1*M1 );
wei_arr   =  zeros(nv, N1*M1 ); 
X         =  X';

I_l   =   (1:L_l);
I_l   =   reshape(I_l, N_l, M_l);
blk_arr_lr   =  zeros(nv, N1*M1 );
wei_arr_lr   =  zeros(nv, N1*M1 );
X_l   =  X_l';

I_ll   =   (1:L_ll);
I_ll   =   reshape(I_ll, N_ll, M_ll);
blk_arr_llr   =  zeros(nv, N1*M1 );
wei_arr_llr   =  zeros(nv, N1*M1 );
X_ll   =  X_ll';

for  i  =  1 : N1
    for  j  =  1 : M1
        
        row     =   r(i);
        col     =   c(j);
        off     =  (col-1)*N + row;
        off1    =  (j-1)*N1 + i;
                
        rmin    =   max( row-S, 1 );
        rmax    =   min( row+S, N );
        cmin    =   max( col-S, 1 );
        cmax    =   min( col+S, M );
         
        idx     =   I(rmin:rmax, cmin:cmax);
        idx     =   idx(:);
        B       =   X(idx, :);        
        v       =   X(off, :);
        
        row_l   =   ceil(row/par.scale);
        col_l   =   ceil(col/par.scale);
        rmin_l  =   max( row_l-S_l, 1 );
        rmax_l  =   min( row_l+S_l, N_l );
        cmin_l  =   max( col_l-S_l, 1 );
        cmax_l  =   min( col_l+S_l, M_l );
         
        idx_l   =   I_l(rmin_l:rmax_l, cmin_l:cmax_l);
        idx_l   =   idx_l(:);
        B_l     =   X_l(idx_l, :);
        
        row_ll   =   ceil(row/par.scale/par.scale);
        col_ll   =   ceil(col/par.scale/par.scale);
        rmin_ll  =   max( row_ll-S_ll, 1 );
        rmax_ll  =   min( row_ll+S_ll, N_ll );
        cmin_ll  =   max( col_ll-S_ll, 1 );
        cmax_ll  =   min( col_ll+S_ll, M_ll );
         
        idx_ll   =   I_ll(rmin_ll:rmax_ll, cmin_ll:cmax_ll);
        idx_ll   =   idx_ll(:);
        B_ll     =   X_ll(idx_ll, :);
        
        dis     =   (B(:,1) - v(1)).^2;
        for k = 2:f2
            dis   =  dis + (B(:,k) - v(k)).^2;
        end
        dis   =  dis./f2;
        [val,ind]   =  sort(dis);        
        dis(ind(1))  =  dis(ind(2));
        wei         =  exp( -dis(ind(1:nv))./hp );
        wei         =  wei./(sum(wei)+eps);
        indc        =  idx( ind(1:nv) );
        blk_arr(:,off1)  =  indc;
        wei_arr(:,off1)  =  wei;
        
        dis     =   (B_l(:,1) - v(1)).^2;
        for k = 2:f2
            dis   =  dis + (B_l(:,k) - v(k)).^2;
        end
        dis   =  dis./f2;
        [val,ind]   =  sort(dis);        
        wei         =  exp( -dis(ind(1:nv))./hp );
        wei         =  wei./(sum(wei)+eps);
        indc        =  idx_l( ind(1:nv) );
        blk_arr_lr(:,off1)  =  indc;
        wei_arr_lr(:,off1)  =  wei;
        
        dis     =   (B_ll(:,1) - v(1)).^2;
        for k = 2:f2
            dis   =  dis + (B_ll(:,k) - v(k)).^2;
        end
        dis   =  dis./f2;
        [val,ind]   =  sort(dis);        
        wei         =  exp( -dis(ind(1:nv))./hp );
        wei         =  wei./(sum(wei)+eps);
        indc        =  idx_ll( ind(1:nv) );
        blk_arr_llr(:,off1)  =  indc;
        wei_arr_llr(:,off1)  =  wei;
    end
end

