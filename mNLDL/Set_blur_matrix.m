function  A   =  Set_blur_matrix( par )
 
s          =   par.scale;       %降采样因子
[lh lw ch] =   size( par.LR );  %第一层低分辨率图像高宽还有通道数(这个处理不了RGB啊..后面有错)
hh         =   lh*s;            %高分辨率图像的高宽
hw         =   lw*s;
M          =   lh*lw;           %低分辨率图像素数
N          =   hh*hw;           %高分辨率图像素数
 
ws         =   size( par.psf, 1 );%7
t          =   (ws-1)/2;        %3
cen        =   ceil(ws/2);      %4
ker        =   par.psf;         %模糊核psf
 
nv         =   ws*ws;           
nt         =   (nv)*M;                      %模糊核像素数乘以低分辨率像素数什么意思？卷积所需要的空间？
R          =   zeros(nt,1);                 %下面4个参数目前也不懂
C          =   zeros(nt,1);
V          =   zeros(nt,1);
cnt        =   1;
 
pos     =  (1:hh*hw);          
pos     =  reshape(pos, [hh hw]); %reshape函数列优先，就是先填满第一列，再第二列。也就是说第一维先增加，再按第二维增加
 
%% 低分辨率高分辨率坐标变换
for lrow = 1:lh
    for lcol = 1:lw
        
        row        =   (lrow-1)*s + 1;%1、3、5、7、9...
        col        =   (lcol-1)*s + 1;
        
        row_idx    =   (lcol-1)*lh + lrow;
        
        
        rmin       =  max( row-t, 1);
        rmax       =  min( row+t, hh);
        cmin       =  max( col-t, 1);
        cmax       =  min( col+t, hw);
        sup        =  pos(rmin:rmax, cmin:cmax);
        col_ind    =  sup(:);
        
        r1         =  row-rmin;
        r2         =  rmax-row;
        c1         =  col-cmin;
        c2         =  cmax-col;
        
        ker2       =  ker(cen-r1:cen+r2, cen-c1:cen+c2);
        ker2       =  ker2(:);
 
        nn         =  size(col_ind,1);
        R(cnt:cnt+nn-1)  =  row_idx;
        C(cnt:cnt+nn-1)  =  col_ind;
        V(cnt:cnt+nn-1)  =  ker2/sum(ker2);
        
        cnt              =  cnt + nn;
    end
end
 
R   =  R(1:cnt-1);
C   =  C(1:cnt-1);
V   =  V(1:cnt-1);
A   =  sparse(R, C, V, M, N);
