function z=Blur(img,psf)
%Blur ���ݸ�����psf��������ͼ��img����ģ��
% img:����ͼ��
% psf:����ģ����
% z:  ���ͼ��
% ���ﴦ���ԵЧʱ����ͼ�������չ����ȡ���ڽ����ص�ֵ��jiaoȡ���ڽ����ص�ֵ

wh   =  size(psf);  %ģ���˿��
r    =  (wh(1)-1)/2;   %ģ���˰뾶

% s  = img;
% se = [s(:,r:-1:1,:), s, s(:,end:-1:end-r+1,:)];
% %ͼ���Ե����������������32112345....789987����
% %�����Ҿ���������廹����ֱ����Ϊͼ��������ƽ�̵�
% se = [se(r:-1:1,:,:); se; se(end:-1:end-r+1,:,:)];

%ֱ������padarray�������б߽����䣬��С����ı߽�ЧӦ
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
    %�����Ҿ��ÿ��Բ���Ҫ��չ��Ե��ֱ������same������Ĭ�ϵľ�����Ϳ����ˣ�
    %���Ծ������飬���Եó������ǲ����Եģ�conv2������չ��full��size����ȷ��same��Ȼ��С��ȷ������Ϊ����չ��Ե��ڻ���
    %���˹������Ե���С��ԵӰ�졣
end
 