function z=Blur(img,psf)
%Blur 根据给定的psf，对输入图像img进行模糊
% img:输入图像
% psf:给定模糊核
% z:  输出图像
% 这里处理边缘效时，对图像进行扩展，边取四邻接像素的值，jiao取八邻接像素的值

wh   =  size(psf);  %模糊核宽高
r    =  (wh(1)-1)/2;   %模糊核半径

% s  = img;
% se = [s(:,r:-1:1,:), s, s(:,end:-1:end-r+1,:)];
% %图像边缘处理，方便卷积？比如32112345....789987这样
% %不过我觉得这样外插还不如直接认为图像是周期平铺的
% se = [se(r:-1:1,:,:); se; se(end:-1:end-r+1,:,:)];

%直接利用padarray函数进行边界扩充，减小卷积的边界效应
s = padarray(img, [r,r], 'replicate');

if size(s,3)==3
    z(:,:,1) = conv2(s(:,:,1),psf,'valid');
    z(:,:,2) = conv2(s(:,:,2),psf,'valid');
    z(:,:,3) = conv2(s(:,:,3),psf,'valid');
else
    z = conv2(s,psf,'valid');
    %'valid' Returns only those parts of the convolution that are computed without the zero-padded edges. Using this option,
    %'full' Returns the full two-dimensional convolution (default).
    %'same' Returns the central part of the convolution of the same size as A
    %所以我觉得可以不需要扩展边缘，直接利用same参数用默认的卷积不就可以了？
    %所以经过试验，可以得出结论是不可以的，conv2是零扩展，full的size不正确，same虽然大小正确，但因为零扩展边缘会黑化。
    %而人工处理边缘会减小边缘影响。
end
 