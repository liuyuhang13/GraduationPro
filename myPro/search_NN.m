function [ is_found,r_idx,c_idx,similarity,similar_p ] = search_NN( patch_Q, I_LL,  PATCH_SIZE)
%search_NN 在输入降质图像中寻找patch_Q的最邻近，返回是否存在以及其在父图像中的行列坐标
%input:
%   patch_Q:原始低分辨率图像中抽取的图像块
%   I_LL:元是低分图的降质图
%   PATCH_SIZE:图像块大小
%outpu:
%   is_found: 表示是否找到最相似图像块
%   r_idx:相似图像块在原始低分图中对应父图像块的行坐标
%   c_idx:相似图像块在原始低分图中对应父图像块的列坐标
%   similarity:用相关系数做相似性
patch_r = extract_Patches(I_LL, PATCH_SIZE, 1);% 得到降质图中图像块
size_Q = size(patch_Q);
size_r = size(patch_r);
is_found = zeros(size_Q(2),1);
index = zeros(size_Q(2),1);
distance = zeros(1,size_r(2));%分配空间
d1 = size(I_LL,1)-PATCH_SIZE+1;%降质图像块第一维的图像块数目，方便后面坐标转换
% 搜索策略：欧氏距离小于0.5，在此基础上相关系数最大的为相似图像块
similar_p = zeros(PATCH_SIZE^2,size_Q(2));
similarity = zeros(size_Q(2),1);

for x = 1:size_Q(2)
    for y = 1:size_r(2)
        distance(y) = sum((patch_r(:,y)-patch_Q(:,x)).^2);
    end
    flag = find(distance<0.5);%记录满足欧氏距离要求的图像块位置
    patch_temp = patch_r(:,flag);%暂存这些满足要求的图像块，以便下一步搜寻
    if(size(patch_temp,2)<1)  %如果没找到，那么相似图像块置为全黑，并且is_found=0;
        similar_p(:,x)= zeros(PATCH_SIZE^2,1);
    else
        R = zeros(1,size(patch_temp,2));
        for y = 1:size(patch_temp,2)
            corr = corrcoef(patch_temp(:,y),patch_Q(:,x));
            R(y) = corr(1,2);
        end
        R_max = max(R);
        pos = find(R==R_max);
        index(x) = flag(pos);
        similar_p(:,x)= patch_temp(:,pos);
        similarity(x) = R_max;
        is_found(x) = 1;
    end
end
c_idx = ceil(index/d1);
r_idx = (index - (c_idx-1)*d1)*2-1;
c_idx = c_idx*2-1;
% figure;%展示相似图像块对
% for x = 1:20
%     subplot(3,4,2*x-1);
%     imshow(reshape(patch_Q(:,x),PATCH_SIZE,PATCH_SIZE));
%     subplot(3,4,2*x);
%     imshow(reshape(similar_p(:,x),PATCH_SIZE,PATCH_SIZE));
% end

end

% 
% patch_r = extract_Patches(I_LL, PATCH_SIZE, 1);
% tic;
% x_temp = size(patch_Q);
% y_temp = size(patch_r);
% distance = zeros(1,y_temp(2));%分配空间
% % 搜索策略：欧氏距离小于0.5，在此基础上相关系数最大的为相似图像块
% similar_p = zeros(PATCH_SIZE^2,x_temp(2));
% similarity = zeros(1,x_temp(2));
% index = zeros(1,x_temp(2));
% for y = 1:x_temp(2)
%     for x = 1:y_temp(2)
%             distance(x) = sum((patch_r(:,x)-patch_Q(:,y)).^2);
%     end
%     flag = find(distance<0.5);
%     patch_temp = patch_r(:,flag);
%     if(size(patch_temp,2)<1)  similar_p(:,y)= zeros(49,1);
%     else
%     R = zeros(1,size(patch_temp,2));
%     for x = 1:size(patch_temp,2)
%         corr = corrcoef(patch_temp(:,x),patch_Q(:,y));
%          R(x) = corr(1,2);
%     end
%      index(y) = flag(find(R==max(R)));
%      similar_p(:,y)= patch_temp(:,find(R==max(R)));
%      similarity(y) = max(R);
%      
%     end
% end
% figure;
% for x = 1:20
%     subplot(5,8,2*x-1);
%     imshow(reshape(patch_Q(:,x),7,7));
%      subplot(5,8,2*x);
%      imshow(reshape(similar_p(:,x),7,7));
% end


