function z=Blur(x,psf)

ws   =  size(psf);
t    =  (ws-1)/2;
 

s  = x;
se = [s(:,t:-1:1,:), s, s(:,end:-1:end-t+1,:)];
%图像边缘处理，方便卷积？比如32112345....789987这样
%不过我觉得这样外插还不如直接认为图像是周期平铺的
se = [se(t:-1:1,:,:); se; se(end:-1:end-t+1,:,:)];

if size(x,3)==3
    z(:,:,1) = conv2(se(:,:,1),psf,'valid');
    z(:,:,2) = conv2(se(:,:,2),psf,'valid');
    z(:,:,3) = conv2(se(:,:,3),psf,'valid');
else
    z = conv2(se,psf,'valid');
    %'valid' Returns only those parts of the convolution that are computed without the zero-padded edges. Using this option,
    %'full' Returns the full two-dimensional convolution (default).
    %'same' Returns the central part of the convolution of the same size as A
    %所以我觉得可以不需要扩展边缘，直接利用same参数用默认的卷积不就可以了？
    %所以经过试验，可以得出结论是不可以的，conv2是零扩展，full的size不正确，same虽然大小正确，但因为零扩展边缘会黑化。
    %而人工处理边缘会减小边缘影响。
end
 

