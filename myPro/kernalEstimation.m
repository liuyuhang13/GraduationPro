%kernalEstimation
%A simple implementation of the BlindS-R Algorithm
clear;clc;
addpath('lib/TreeCANN_code_20121022')
addpath('lib/TreeCANN_code_20121022/matlab_tools/ann_wrapper')
addpath('lib/TreeCANN_code_20121022/C_code')
%% 利用给定模糊核模糊和降采样参考高分图来得到低分图并保存
TEST_IMAGE_DIR   =   'images';
OUTPUT_DIR = 'LR_images'
IMAGE_NAME = '2.1.05';
IMAGE_FORMAT = '.bmp';
DOWN_SAMPLE_FACTOR = 2;%降采样因子
PATCH_SIZE = 5;%图像块大小
KERNEL_SIZE = 9;
KERNEL_RADIUS = (KERNEL_SIZE-1)/2;
I_H = im2double(imread(sprintf('%s/%s%s',TEST_IMAGE_DIR, IMAGE_NAME, IMAGE_FORMAT)));
Ground_truth_k = fspecial('gauss',9,2.5);
%低分辨率图像是高分辨率图像的模糊加降采样
I_L = Blur(I_H,Ground_truth_k);
% I_TEST = imfilter(I_H,Ground_truth_k,'replicate'); 
% 不需要用我写的Blur，matlab自带 imfilter函数就可以

I_L = I_L(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);

% figure;%高分辨图与低分辨率图展示
% subplot(1,3,1)
% imshow(I_H);
% title('I\_H')
% subplot(1,3,2)
% imshow(I_L);
% title('I\_L')
% subplot(1,3,3)
% imshow(Ground_truth_k/Ground_truth_k(5,5));
% title('Ground\_truth\_k');
fname = strcat(IMAGE_NAME,'_LR',IMAGE_FORMAT);
imwrite(I_L, fullfile(OUTPUT_DIR, fname));
%% 恢复模糊核
k_hat = fspecial('gauss',KERNEL_SIZE,0.01);
k_iter = zeros(KERNEL_SIZE,KERNEL_SIZE,10);
figure;
imshow(k_hat);
patch_Q = extract_Patches(I_L, PATCH_SIZE, 1);
var_patch_Q = var(patch_Q);
flag = find(var_patch_Q > 0.01)';
patch_Q = patch_Q(:,flag);
if size(patch_Q, 2) > 10%图像块数目大于20，随机抽取20个
    rand_select = randperm(size(patch_Q, 2))';
    patch_Q = patch_Q(:, rand_select(1: 10));
    
end
err_qr = zeros(15,1);
err_k = zeros(15,1);
for iter = 1:15
    I_LL = Blur(I_L,k_hat);
    I_LL = I_LL(1:DOWN_SAMPLE_FACTOR:end,1:DOWN_SAMPLE_FACTOR:end);
    % 抽取部分I_L的大方差图像块，认为方差大于0.01是方差较大的
    % 即就是去掉 'flat pathces'，方差小于σ_min的和距离平均值小于dist_min的图像块

%     patch_Q = extract_Patches(I_L, PATCH_SIZE, 1);
%     var_patch_Q = var(patch_Q);
%     flag = find(var_patch_Q > 0.01)';
%     patch_Q = patch_Q(:,flag);
%     if size(patch_Q, 2) > 10%图像块数目大于20，随机抽取20个
%         rand_select = randperm(size(patch_Q, 2))';
%         patch_Q = patch_Q(:, rand_select(1: 10));
%         
%     end
    
    [ is_found,r_idx,c_idx,similarity,similar_p] = search_NN( patch_Q, I_LL,  PATCH_SIZE);
    figure( 'Name','相似图像块对','NumberTitle','off');%展示相似图像块对
    err_qr(iter) = sum(sum((patch_Q-similar_p).^2));
    for x = 1:10
        subplot(5,4,2*x-1);
        imshow(reshape(patch_Q(:,x),PATCH_SIZE,PATCH_SIZE));
        subplot(5,4,2*x);
        imshow(reshape(similar_p(:,x),PATCH_SIZE,PATCH_SIZE));
    end
        
 %% 展示q与r
%  R_idx = zeros(size(r_idx));
%  C_idx = zeros(size(c_idx));
%  d1 = size(I_L,1)-PATCH_SIZE+1;
%  C_idx = ceil(flag(rand_select(1:6))/d1);
%  R_idx = flag(rand_select(1:6))- (C_idx-1)*d1;
%  for x = 1:6
%      if(is_found(x))
%      I_L_show = I_L;
%      I_L_show (R_idx(x)-1,C_idx(x)-1:C_idx(x)+PATCH_SIZE)=0;
%      I_L_show (R_idx(x)+PATCH_SIZE,C_idx(x)-1:C_idx(x)+PATCH_SIZE)=0;
%      I_L_show (R_idx(x)-1:R_idx(x)+PATCH_SIZE,C_idx(x)-1) = 0;
%      I_L_show (R_idx(x)-1:R_idx(x)+PATCH_SIZE,C_idx(x)+PATCH_SIZE) = 0;
%      I_L_show (r_idx(x)-1,c_idx(x)-1:c_idx(x)+2*PATCH_SIZE)=0;
%      I_L_show (r_idx(x)+2*PATCH_SIZE,c_idx(x)-1:c_idx(x)+2*PATCH_SIZE)=0;
%      I_L_show (r_idx(x)-1:r_idx(x)+2*PATCH_SIZE,c_idx(x)-1) = 0;
%      I_L_show (r_idx(x)-1:r_idx(x)+2*PATCH_SIZE,c_idx(x)+2*PATCH_SIZE) = 0;
%      figure;
%      imshow(I_L_show);
%      end
%  end
    
    %% 建立最小二乘方程矩阵
    
    k_hat = least_Square_Estimate( patch_Q,r_idx,c_idx,I_L,is_found,KERNEL_RADIUS,PATCH_SIZE);
%     figure( 'Name','模糊核估计','NumberTitle','off');%展示当前模糊和估计
%     
%     title(['iter = ',num2str(iter)]);
%     imshow(reshape(k_hat/max(max(k_hat)),9,9));
%     figure;
%     mesh(reshape(k_hat/max(max(k_hat)),9,9));
%     k_hat = abs(k_hat);
%      k_hat(k_hat<0) = 0;
    k_hat = k_hat-min(k_hat);
    k_hat = k_hat/sum(k_hat);
    k_hat = reshape(k_hat,9,9);
    k_iter(:,:,iter) = k_hat;
    err_k(iter) = sum(sum((k_hat - Ground_truth_k).^2));
    %% 展示父图像块
%     r_idx = r_idx ;
%     c_idx = c_idx ;
%     figure;
%     for x=1:6
%         subplot(3,2,x);
%         if is_found(x)
%             imshow(I_L(r_idx(x):r_idx(x)+2*PATCH_SIZE-1,c_idx(x):c_idx(x)+2*PATCH_SIZE-1));
%         else
%             imshow(zeros(14,14));
%         end
%     end
end
figure;
for x = 1:15
    subplot(3,5,x)
    imshow(k_iter(:,:,x)/max(max(k_iter(:,:,x))));
    title(['iter = ',num2str(x)]);
end
figure;
plot(err_qr);
title('相似图像块距离')
figure;
plot(err_k);
title('核距离');
    

   %% 展示q与r
%  R_idx = zeros(size(r_idx));
%  C_idx = zeros(size(c_idx));
%  d1 = size(I_L,1)-PATCH_SIZE+1;
%  C_idx = ceil(flag(r(1:20))/d1);
%  R_idx = flag(r(1:20))- (C_idx-1)*d1;
%  for x = 1:20
%      if(is_found(x))
%      I_L_show = I_L;
%      I_L_show (R_idx(x)-1,C_idx(x)-1:C_idx(x)+PATCH_SIZE)=0;
%      I_L_show (R_idx(x)+PATCH_SIZE,C_idx(x)-1:C_idx(x)+PATCH_SIZE)=0;
%      I_L_show (R_idx(x)-1:R_idx(x)+PATCH_SIZE,C_idx(x)-1) = 0;
%      I_L_show (R_idx(x)-1:R_idx(x)+PATCH_SIZE,C_idx(x)+PATCH_SIZE) = 0;
%      I_L_show (r_idx(x)-1,c_idx(x)-1:c_idx(x)+2*PATCH_SIZE)=0;
%      I_L_show (r_idx(x)+2*PATCH_SIZE,c_idx(x)-1:c_idx(x)+2*PATCH_SIZE)=0;
%      I_L_show (r_idx(x)-1:r_idx(x)+2*PATCH_SIZE,c_idx(x)-1) = 0;
%      I_L_show (r_idx(x)-1:r_idx(x)+2*PATCH_SIZE,c_idx(x)+2*PATCH_SIZE) = 0;
%      figure;
%      imshow(I_L_show);
%      end
%  end
% 
%  
%% 展示抽取的100个高方差图像块
% figure;
% for x = 1:100
%     subplot(10,10,x);
%     imshow(reshape(patch_Q(:,x),7,7));
% end
% % 

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

