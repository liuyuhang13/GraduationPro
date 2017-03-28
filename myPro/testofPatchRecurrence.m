%testofPatchRecurrence e.g. 7*7 patch
%����ң��ͼ���е���ͼ��ͬ�߶Ȼ�ͬ�߶�����ͼ���Ĵ�����
%% ͬ�߶ȵ���ͼ���ͼ��������Լ��
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
%% ��һ��ͼ���֮�����ֲ�
% % 
% distance = zeros(x_temp(2),1);%����ռ�
% % ������Ϊ����С��0.005Ϊ����ͼ��飿
% 
% for x = 1:x_temp(2)
%     R = corrcoef(img_patches(:,x),img_patches(:,8888));
%     distance(x) = abs(R(1,2));
% %     distance(x) = sum((img_patches(:,x)-img_patches(:,3000)).^2);
%  end
%% ͳ��һ�¸�ͼ�����ӵ�еĵ�����ͼ������
% %�϶�ŷʽ����С��0.01Ϊ����ͼ���
%     for x = 1:x_temp(2)
%         for y = x+1:x_temp(2)
%             distance = sum((img_patches(:,x)-img_patches(:,y)).^2);
%             if distance < 0.05;
%                 recurrence_num(x) =  recurrence_num(x)+1;
%                 recurrence_num(y) =  recurrence_num(y)+1;
%             end
%         end
%     end
%% һЩ����ͼ����ʾ��
spco  = searchSimilarPatches(194,226,img_patches,patch_size,img_size,1 );
%2.0.01[375,114]
figure;
for index = 1:size(spco,1)
    subplot(ceil(size(spco,1)/7),7,index);
    imshow(reshape(img_patches(:,spco(index)),patch_size,patch_size));
end

I_labelled = I;
d=1;
num_of_each_row = floor((img_size - patch_size)/d)+1;   %ÿһ�е�ͼ�����Ŀ
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
