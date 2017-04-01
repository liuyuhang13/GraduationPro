%kernalEstimation
%A simple implementation of the BlindS-R Algorithm
addpath('lib/TreeCANN_code_20121022')
addpath('lib/TreeCANN_code_20121022/matlab_tools/ann_wrapper')
addpath('lib/TreeCANN_code_20121022/C_code')
%% 利用给定模糊核模糊和降采样参考高分图来得到低分图并保存
TEST_IMAGE_DIR   =   'images';
OUTPUT_DIR = 'LR_images'
IMAGE_NAME = '2.1.05';
IMAGE_FORMAT = '.bmp';
DOWN_SAMPLE_FACTOR = 2;%降采样因子
PATCH_SIZE = 7;%图像块大小
I_H = im2double(imread(sprintf('%s/%s%s',TEST_IMAGE_DIR, IMAGE_NAME, IMAGE_FORMAT)));
Ground_truth_k = fspecial('gauss',9,2.5);
%低分辨率图像是高分辨率图像的模糊加降采样
I_L = Blur(I_H,Ground_truth_k);
I_L = I_L(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);

figure;%高分辨图与低分辨率图展示
subplot(1,3,1)
imshow(I_H);
title('I\_H')
subplot(1,3,2)
imshow(I_L);
title('I\_L')
subplot(1,3,3)
imshow(Ground_truth_k/Ground_truth_k(5,5));
title('Ground\_truth\_k');
fname = strcat(IMAGE_NAME,'_LR',IMAGE_FORMAT);
imwrite(I_L, fullfile(OUTPUT_DIR, fname));
%% 恢复模糊核
k_hat = fspecial('gauss',9,0.01);
I_LL = Blur(I_L,k_hat);
I_LL = I_LL(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);
% 抽取部分I_L的大方差图像块，认为方差大于0.01是方差较大的
% 即就是去掉 'flat pathces'，方差小于σ_min的和距离平均值小于dist_min的图像块
patch_Q = extract_Patches(I_L, PATCH_SIZE, 1);
var_patch_Q = var(patch_Q);
patch_Q = patch_Q(:,var_patch_Q > 0.01);

if size(patch_Q, 2) > 100%图像块数目大于100，随机抽取100个
    r = randperm(size(patch_Q, 2));
    patch_Q = patch_Q(:, r(1: 100));
end
%% 展示抽取的100个高方差图像块
% figure;
% for x = 1:100
%     subplot(10,10,x);
%     imshow(reshape(patch_Q(:,x),7,7));
% end
% % 
%% 测试 图像块在I_LL中相似图像块个数
patch_r = extract_Patches(I_LL, PATCH_SIZE, 1);
tic;
x_temp = size(patch_Q);
y_temp = size(patch_r);
distance = zeros(1,y_temp(2));%分配空间
% 搜索策略：欧氏距离小于0.5，在此基础上相关系数最大的为相似图像块
similar_p = zeros(PATCH_SIZE^2,x_temp(2));
similarity = zeros(1,x_temp(2));
index = zeros(1,x_temp(2));
for y = 1:x_temp(2)
    for x = 1:y_temp(2)
            distance(x) = sum((patch_r(:,x)-patch_Q(:,y)).^2);
    end
    flag = find(distance<0.5);
    patch_temp = patch_r(:,flag);
    if(size(patch_temp,2)<1)  similar_p(:,y)= zeros(49,1);
    else
    R = zeros(1,size(patch_temp,2));
    for x = 1:size(patch_temp,2)
        corr = corrcoef(patch_temp(:,x),patch_Q(:,y));
         R(x) = corr(1,2);
    end
     index(y) = flag(find(R==max(R)));
     similar_p(:,y)= patch_temp(:,find(R==max(R)));
     similarity(y) = max(R);
     
    end
end
figure;
for x = 1:100
    subplot(10,20,2*x-1);
    imshow(reshape(patch_Q(:,x),7,7));
     subplot(10,20,2*x);
     imshow(reshape(similar_p(:,x),7,7));
end



% similar_p = patch_r(:,distance>0.9);
% similar_p = patch_r(:,find(distance==max(distance)));
 toc;
%  figure;
%  for x = 1:7
%      subplot(2,4,x)
%      imshow(reshape(similar_p(:,x),7,7));
%  end
%           subplot(2,4,x+1)
%           imshow(reshape(patch_Q(:,2),7,7));
 



% k_hat = least_Square_Solve(I_L,I_LL,PATCH_SIZE);




%% 这里拿 I_LL训练KSVD字典，并看一下字典结果
% D_ksvd = dictionary_Train(I_LL,PATCH_SIZE);
% % 打印KSVD_D
% D_demo = zeros(98,98);
% r = 1:7:98;
% c = 1:7:98;
% temp=0;
% for j = 1: 7
%     for i = 1: 7
%         temp = temp+1;
%         D_demo(r-1+i,c-1+j) = reshape(D_ksvd(temp,:),14,14);
%     end
% end
% figure;
% imshow(D_demo/max(max(D_demo)));
% title('稀疏字典');


figure;
imshow(I_LL);
title('I\_LL');
% xxxx = padarray(I_L, [1000,1000], 'circular');
% figure;
% imshow(xxxx)

