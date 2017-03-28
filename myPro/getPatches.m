function [ img_patches ] = getPatches( img, patch_size, d)
%getPathces ����ͼ����С������dΪ���������ͼ���
%   img:����ͼ��
%   patch_size:����ͼ����С
%   d:�������
%   img_patches:���ͼ���
    num_of_pixels = patch_size^2;   %ͼ������ظ���
    [row,col] = size(img);   %����ͼ���С
    num_of_patches = (floor((row-patch_size)/d)+1)*(floor((col-patch_size)/d)+1); % ���ͼ������
    img_patches = zeros(num_of_pixels,num_of_patches);  %����ռ�
    n = 0;  %ͼ������������
    for x = 1:d:row-patch_size+1  
        for y = 1:d:col-patch_size+1
            n = n+1;
            patch_temp = img(x:x+patch_size-1,y:y+patch_size-1);
            img_patches(:,n) = patch_temp(:);
        end
    end
    
    
end

