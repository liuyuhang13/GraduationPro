%testofPatchRecurrence e.g. 7*7 patch
%测试遥感图集中单幅图像同尺度或不同尺度相似图像块的存在性
%% 同尺度单幅图像的图像块相似性检测
tic;
Test_image_dir   =   'images';
image_name = '2.1.05';
image_format = '.bmp';
I = im2double(imread(sprintf('%s/%s%s',Test_image_dir, image_name, image_format)));
patch_size = 7;
img_size = size(I,1);
img_patches = getPatches(I,patch_size,1);
x_temp = size(img_patches);
recurrence_num = zeros(x_temp(2),1);
%% 看一下图像块之间距离分布
% % 
% distance = zeros(x_temp(2),1);%分配空间
% % 暂且认为距离小于0.005为相似图像块？
% 
% for x = 1:x_temp(2)
%     R = corrcoef(img_patches(:,x),img_patches(:,8888));
%     distance(x) = abs(R(1,2));
% %     distance(x) = sum((img_patches(:,x)-img_patches(:,3000)).^2);
%  end
%% 统计一下各图像块所拥有的的相似图像块个数
% %认定欧式距离小于0.01为相似图像块
%     for x = 1:x_temp(2)
%         for y = x+1:x_temp(2)
%             distance = sum((img_patches(:,x)-img_patches(:,y)).^2);
%             if distance < 0.05;
%                 recurrence_num(x) =  recurrence_num(x)+1;
%                 recurrence_num(y) =  recurrence_num(y)+1;
%             end
%         end
%     end
%% 一些相似图像块的示例
spco  = searchSimilarPatches(194,226,img_patches,patch_size,img_size,1 );
%2.0.01[375,114]
figure;
for index = 1:size(spco,1)
    subplot(ceil(size(spco,1)/7),7,index);
    imshow(reshape(img_patches(:,spco(index)),patch_size,patch_size));
end

I_labelled = I;
d=1;
num_of_each_row = floor((img_size - patch_size)/d)+1;   %每一行的图像块数目
for index = 1:size(spco,1)
    R = ceil(spco(index)/num_of_each_row);
    C = (spco(index) - (R-1)*num_of_each_row -1)*d+1;
    I_labelled (R-1,C-1:C+patch_size)=0;
    I_labelled (R+patch_size,C-1:C+patch_size)=0;
    I_labelled (R-1:R+patch_size,C-1) = 0;
    I_labelled (R-1:R+patch_size,C+patch_size) = 0;
end
figure;
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I_labelled);
toc;
time = toc - tic;
