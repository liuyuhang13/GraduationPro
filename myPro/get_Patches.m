function [ img_patches ] = get_Patches( img, patch_size, d)
%get_Pathces 根据图像块大小，返回d为采样间隔的图像块
%   img:输入图像
%   patch_size:矩形图像块大小
%   d:采样间隔
%   img_patches:输出图像块
%   可以根据学长程序改进，复杂度是n^2
    num_of_pixels = patch_size^2;   %图像块像素个数
    [row,col] = size(img);   %输入图像大小
    num_of_patches = (floor((row-patch_size)/d)+1)*(floor((col-patch_size)/d)+1); % 输出图像块个数
    img_patches = zeros(num_of_pixels,num_of_patches);  %分配空间
    n = 0;  %图像块输出所在列
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
% r = [r, r(end)+1:N];%这一步是要干嘛？目前没看出来有什么用。。
% c = 1: s: M;
% c = [c, c(end)+1:M];