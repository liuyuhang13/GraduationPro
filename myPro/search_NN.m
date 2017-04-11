function [ is_found,r_idx,c_idx,similarity,similar_p ] = search_NN( patch_Q, I_LL,  PATCH_SIZE)
%search_NN �����뽵��ͼ����Ѱ��patch_Q�����ڽ��������Ƿ�����Լ����ڸ�ͼ���е���������
%input:
%   patch_Q:ԭʼ�ͷֱ���ͼ���г�ȡ��ͼ���
%   I_LL:Ԫ�ǵͷ�ͼ�Ľ���ͼ
%   PATCH_SIZE:ͼ����С
%outpu:
%   is_found: ��ʾ�Ƿ��ҵ�������ͼ���
%   r_idx:����ͼ�����ԭʼ�ͷ�ͼ�ж�Ӧ��ͼ����������
%   c_idx:����ͼ�����ԭʼ�ͷ�ͼ�ж�Ӧ��ͼ����������
%   similarity:�����ϵ����������
patch_r = extract_Patches(I_LL, PATCH_SIZE, 1);% �õ�����ͼ��ͼ���
size_Q = size(patch_Q);
size_r = size(patch_r);
is_found = zeros(size_Q(2),1);
index = zeros(size_Q(2),1);
distance = zeros(1,size_r(2));%����ռ�
d1 = size(I_LL,1)-PATCH_SIZE+1;%����ͼ����һά��ͼ�����Ŀ�������������ת��
% �������ԣ�ŷ�Ͼ���С��0.5���ڴ˻��������ϵ������Ϊ����ͼ���
similar_p = zeros(PATCH_SIZE^2,size_Q(2));
similarity = zeros(size_Q(2),1);

for x = 1:size_Q(2)
    for y = 1:size_r(2)
        distance(y) = sum((patch_r(:,y)-patch_Q(:,x)).^2);
    end
    flag = find(distance<0.5);%��¼����ŷ�Ͼ���Ҫ���ͼ���λ��
    patch_temp = patch_r(:,flag);%�ݴ���Щ����Ҫ���ͼ��飬�Ա���һ����Ѱ
    if(size(patch_temp,2)<1)  %���û�ҵ�����ô����ͼ�����Ϊȫ�ڣ�����is_found=0;
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
% figure;%չʾ����ͼ����
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
% distance = zeros(1,y_temp(2));%����ռ�
% % �������ԣ�ŷ�Ͼ���С��0.5���ڴ˻��������ϵ������Ϊ����ͼ���
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


