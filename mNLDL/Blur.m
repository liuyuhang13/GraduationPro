function z=Blur(x,psf)

ws   =  size(psf);
t    =  (ws-1)/2;
 

s  = x;
se = [s(:,t:-1:1,:), s, s(:,end:-1:end-t+1,:)];
%ͼ���Ե����������������32112345....789987����
%�����Ҿ���������廹����ֱ����Ϊͼ��������ƽ�̵�
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
    %�����Ҿ��ÿ��Բ���Ҫ��չ��Ե��ֱ������same������Ĭ�ϵľ�����Ϳ����ˣ�
    %���Ծ������飬���Եó������ǲ����Եģ�conv2������չ��full��size����ȷ��same��Ȼ��С��ȷ������Ϊ����չ��Ե��ڻ���
    %���˹������Ե���С��ԵӰ�졣
end
 

