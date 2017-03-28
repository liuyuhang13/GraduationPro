function [ img_patches ] = getPatches( img, patch_size, d)
%getPathces 根据图像块大小，返回d为采样间隔的图像块
%   img:输入图像
%   patch_size:矩形图像块大小
%   d:采样间隔
%   img_patches:输出图像块
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

