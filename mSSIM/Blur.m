function z=Blur(x,psf)

ws   =  size(psf);
t    =  (ws-1)/2;
 

s  = x;
se = [s(:,t:-1:1,:), s, s(:,end:-1:end-t+1,:)];
se = [se(t:-1:1,:,:); se; se(end:-1:end-t+1,:,:)];

if size(x,3)==3
    z(:,:,1) = conv2(se(:,:,1),psf,'valid');
    z(:,:,2) = conv2(se(:,:,2),psf,'valid');
    z(:,:,3) = conv2(se(:,:,3),psf,'valid');
else
    z = conv2(se,psf,'valid');
end
 

