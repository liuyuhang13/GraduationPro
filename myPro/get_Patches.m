function [ img_patches ] = get_Patches( img, patch_size, d)
%get_Pathces ����ͼ����С������dΪ���������ͼ���
%   img:����ͼ��
%   patch_size:����ͼ����С
%   d:�������
%   img_patches:���ͼ���
%   ���Ը���ѧ������Ľ������Ӷ���n^2
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


% function [P, r, c] = extract_patches(im, p, s)
% % p: batch size
% % s: step.Every s pixels pick out one batch,for both row and column.
% 
% [h, w] = size(im);
% [r, c] = get_patch_grid(h, w, p, s);
% P = zeros(p*p, length(r)*length(c));
% 
% k = 0;
% for j = 1: p
%     for i = 1: p
%         k = k+1;
%         blk = im(r-1+i,c-1+j);
%         P(k, :) = blk(:)';
%     end
% end
% 
% 
% function [r, c] = get_patch_grid(h, w, p, s)
% % h: height of image used for patch extraction
% % w: width of image used for patch extraction
% % p: patch size
% % s: grid step
% 
% N = h - p + 1;
% M = w - p + 1;
% r = 1: s: N;
% r = [r, r(end)+1:N];%��һ����Ҫ���Ŀǰû��������ʲô�á���
% c = 1: s: M;
% c = [c, c(end)+1:M];