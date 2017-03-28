function [ spco ] = searchSimilarPatches(R,C,img_patches,patch_size,img_size,d )
%searchSimilarPatches 根据给定图像块的左上角坐标，以及图像块大小、采样间隔等寻找返回相似图像块的左上角坐标组
%   R：给定图像块行坐标
%   C:给定图像块列坐标
%   img_patches:图像块集
%   patch_size:图像块大小
%   img_size:图像大小
%   d:采样间隔
%   spco:相似图像块左上角坐标组成的矩阵，[]则没有找到相似图像块
%        每行为一组坐标
    spco = [];
    num_of_each_row = floor((img_size - patch_size)/d)+1;   %每一行的图像块数目
    patch_index = (R-1) * num_of_each_row + (C-1)/d+1;  %行列坐标与图像块集列坐标的转换
    
    x_temp = size(img_patches);
    
    for x = 1:x_temp(2)
        cor = corrcoef(img_patches(:,x),img_patches(:,patch_index));
        distance = sum((img_patches(:,x)-img_patches(:,patch_index)).^2);
        %这里我是基于这样的假设，人眼能够识别的灰度级大概为30左右，图像块一共49个像素；
        %所以认为2/30*1/30*50≈0.05为高斯距离阈值
        if (cor>0.75)&(distance<0.10)&(x~=patch_index)
            spco = [spco;x];
        end
    %     distance(x) = sum((img_patches(:,x)-img_patches(:,3000)).^2);
    end
 
end

